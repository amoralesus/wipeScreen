//
//  IAPHelper.m
//  wipe
//
//  Created by Alberto Morales on 11/24/13.
//  Copyright (c) 2013 wipemyscreenclean.com. All rights reserved.
//



#import "IAPHelper.h"
#import <StoreKit/StoreKit.h>

#import "IAPProductPurchase.h"

#import "IAPProduct.h"


NSString *const IAPHelperProductPurchasedNotification = @"IAPHelperProductPurchasedNotification";

@interface IAPHelper () <SKProductsRequestDelegate, SKPaymentTransactionObserver>
@end

@implementation IAPHelper {

    SKProductsRequest * _productsRequest;

    RequestProductsCompletionHandler _completionHandler;
    NSSet * _productIdentifiers;
    NSMutableSet * _purchasedProductIdentifiers;
}

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers {
    
    if ((self = [super init])) {

        // Store product identifiers
        _productIdentifiers = productIdentifiers;
        
        // Check for previously purchased products
        _purchasedProductIdentifiers = [NSMutableSet set];
        for (NSString * productIdentifier in _productIdentifiers) {
            BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:productIdentifier];
            if (productPurchased) {
                [_purchasedProductIdentifiers addObject:productIdentifier];
                NSLog(@"Previously purchased: %@", productIdentifier);
            } else {
                NSLog(@"I don't see it purchased: '%@'", productIdentifier);
            }
        }
        
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        
    }
    return self;
}


- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler {
    

    _completionHandler = [completionHandler copy];
    

    _productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers];
    _productsRequest.delegate = self;
    [_productsRequest start];
    
}


#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    _productsRequest = nil;
    
    NSArray * skProducts = response.products;
    _completionHandler(YES, skProducts);
    _completionHandler = nil;
    
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    
    NSLog(@"Failed to load list of products.");
    _productsRequest = nil;
    
    _completionHandler(NO, nil);
    _completionHandler = nil;
    
}

- (BOOL)productPurchased:(NSString *)productIdentifier {
    return [_purchasedProductIdentifiers containsObject:productIdentifier];
}

- (void)buyProduct:(SKProduct *)skProduct {
    
    NSLog(@"%@",skProduct.productIdentifier);
    
    IAPProduct *product = [self addProductForSkProduct:skProduct];
    
    NSLog(@"Buying %@...", product.productIdentifier);
    
    product.purchaseInProgress = YES;
    SKPayment * payment = [SKPayment
                           paymentWithProduct:product.skProduct];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
}




- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction * transaction in transactions) {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    };
}


- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"completeTransaction...");
    
    [self provideContentForProductIdentifier:transaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"restoreTransaction...");
    
    [self provideContentForProductIdentifier:transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    
    NSLog(@"failedTransaction...");
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}


- (void)provideContentForProductIdentifier:(NSString *)productIdentifier {
    
    [_purchasedProductIdentifiers addObject:productIdentifier];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:productIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductPurchasedNotification object:productIdentifier userInfo:nil];
    
}

- (void)provideContentForTransaction: (SKPaymentTransaction *)transaction productIdentifier:(NSString *)productIdentifier {
    [[SKPaymentQueue defaultQueue] startDownloads:transaction.downloads];
}


- (void)paymentQueue:(SKPaymentQueue *)queue
    updatedDownloads:(NSArray *)downloads {
    
    // 1
    SKDownload * download = [downloads objectAtIndex:0];
    SKPaymentTransaction * transaction = download.transaction;
    SKPayment * payment = transaction.payment;
    NSString * productIdentifier = payment.productIdentifier;
    IAPProduct * product = _products[productIdentifier];
    
    // 2
    product.progress = download.progress;
    
    // 3
    NSLog(@"Download state: %d", download.downloadState);
    if (download.downloadState == SKDownloadStateFinished) {
        
        // 4
        [self purchaseNonconsumableAtURL:download.contentURL
                    forProductIdentifier:productIdentifier];
        product.purchaseInProgress = NO;
        [[SKPaymentQueue defaultQueue] finishTransaction:
         transaction];
        
    } else if (download.downloadState ==
               SKDownloadStateFailed) {
        
        // 5
        NSLog(@"Download failed.");
        [self notifyStatusForProductIdentifier:productIdentifier
                                        string:@"Download failed."];
        product.purchaseInProgress = NO;
        [[SKPaymentQueue defaultQueue] finishTransaction:
         transaction];
        
    } else if (download.downloadState ==
               SKDownloadStateCancelled) {
        
        // 6
        NSLog(@"Download cancelled.");
        [self notifyStatusForProductIdentifier:productIdentifier
                                        string:@"Download cancelled."];
        product.purchaseInProgress = NO;
        [[SKPaymentQueue defaultQueue] finishTransaction:
         transaction];
        
    } else {
        // 7
        NSLog(@"Download for %@: %0.2f complete",
              productIdentifier, product.progress);
    }
}

- (NSString *)libraryPath {
    NSArray * libraryPaths =
    NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,
                                        NSUserDomainMask, YES);
    return libraryPaths[0];
}


- (void)purchaseNonconsumableAtURL:(NSURL *)nonLocalURL
              forProductIdentifier:(NSString *)productIdentifier {
    
    NSError * error = nil;
    BOOL success = FALSE;
    BOOL exists = FALSE;
    BOOL isDirectory = FALSE;
    
    // 1
    NSString * libraryRelativePath =
    nonLocalURL.lastPathComponent;
    NSString * localPath = [[self libraryPath]
                            stringByAppendingPathComponent:libraryRelativePath];
    NSURL * localURL = [NSURL fileURLWithPath:localPath
                                  isDirectory:YES];
    exists = [[NSFileManager defaultManager]
              fileExistsAtPath:localPath isDirectory:&isDirectory];
    
    // 2
    if (exists) {
        BOOL success = [[NSFileManager defaultManager]
                        removeItemAtURL:localURL error:&error];
        if (!success) {
            NSLog(@"Couldn't delete directory at %@: %@",
                  localURL, error.localizedDescription);
        }
    }
    
    // 3
    NSLog(@"Copying directory from %@ to %@", nonLocalURL,
          localURL);
    success = [[NSFileManager defaultManager]
               copyItemAtURL:nonLocalURL toURL:localURL error:&error];
    if (!success) {
        NSLog(@"Failed to copy directory: %@",
              error.localizedDescription);
        [self notifyStatusForProductIdentifier:productIdentifier
                                        string:@"Copying failed."];
        return;
    }
    
    // 1
    NSString * contentVersion = @"";
    NSURL * contentInfoURL = [localURL
                              URLByAppendingPathComponent:@"ContentInfo.plist"];
    exists = [[NSFileManager defaultManager]
              fileExistsAtPath:contentInfoURL.path
              isDirectory:&isDirectory];
    if (exists) {
        // 2
        NSDictionary * contentInfo = [NSDictionary
                                      dictionaryWithContentsOfURL:contentInfoURL];
        contentVersion = contentInfo[@"ContentVersion"];
        NSString * contentsPath = [libraryRelativePath
                                   stringByAppendingPathComponent:@"Contents"];
        // 3
        NSString * fullContentsPath = [[self libraryPath]
                                       stringByAppendingPathComponent:contentsPath];
        if ([[NSFileManager defaultManager]
             fileExistsAtPath:fullContentsPath]) {
            libraryRelativePath = contentsPath;
            localPath = [[self libraryPath]
                         stringByAppendingPathComponent:libraryRelativePath];
            localURL = [NSURL fileURLWithPath:localPath
                                  isDirectory:YES];
        }
    }
    
    // 4
    [self provideContentWithURL:localURL];
    
    // 5
    IAPProductPurchase * previousPurchase = [self purchaseForProductIdentifier:productIdentifier];
    
    
    if (previousPurchase) {
        previousPurchase.timesPurchased++;
        
        // 6
        NSString * oldPath = [[self libraryPath]
                              stringByAppendingPathComponent:
                              previousPurchase.libraryRelativePath];
        success = [[NSFileManager defaultManager]
                   removeItemAtPath:oldPath error:&error];
        if (!success) {
            NSLog(@"Could not remove old purchase at %@",
                  oldPath);
        } else {
            NSLog(@"Removed old purchase at %@", oldPath);
        }
        
        // 7
        previousPurchase.libraryRelativePath =
        libraryRelativePath;
        previousPurchase.contentVersion = contentVersion;
    } else {
        IAPProductPurchase * purchase =
        [[IAPProductPurchase alloc]
         initWithProductIdentifier:productIdentifier
         consumable:NO timesPurchased:1
         libraryRelativePath:libraryRelativePath
         contentVersion:contentVersion];
        [self addPurchase:purchase
     forProductIdentifier:productIdentifier];
    }
    
    [self notifyStatusForProductIdentifier:productIdentifier string:@"Purchase complete!"];
    

    
}





- (void)provideContentWithURL:(NSURL *)URL {
}

- (void)notifyStatusForProductIdentifier: (NSString *)productIdentifier string:(NSString *)string {
    IAPProduct * product = _products[productIdentifier];
    [self notifyStatusForProduct:product string:string];
}

- (void)notifyStatusForProduct:(IAPProduct *)product
                        string:(NSString *)string {
    
}


- (IAPProductPurchase *)purchaseForProductIdentifier: (NSString *)productIdentifier {
    IAPProduct * product = _products[productIdentifier];
    if (!product) return nil;
    
    return product.purchase;
}


- (void)addPurchase:(IAPProductPurchase *)purchase forProductIdentifier:(NSString *)productIdentifier {
    
    IAPProduct * product = _products[productIdentifier];
    product.purchase = purchase;
    
}

- (IAPProduct *)addProductForSkProduct: (SKProduct *)skProduct {
    IAPProduct * product = _products[skProduct.productIdentifier];
    if (product == nil) {
        product = [[IAPProduct alloc] initWithProductIdentifier:skProduct.productIdentifier];
        product.skProduct = skProduct;
        _products[skProduct.productIdentifier] = product;
    }
    return product;
}


- (void)cancelDownloads:(NSArray *)downloads {
    [[SKPaymentQueue defaultQueue] cancelDownloads:downloads];
}

- (void)pauseDownloads:(NSArray *)downloads {
    [[SKPaymentQueue defaultQueue] pauseDownloads:downloads];
}

- (void)resumeDownloads:(NSArray *)downloads {
    [[SKPaymentQueue defaultQueue] resumeDownloads:downloads];
}

- (void)restoreCompletedTransactions {
    [[SKPaymentQueue defaultQueue]
     restoreCompletedTransactions];
}



@end
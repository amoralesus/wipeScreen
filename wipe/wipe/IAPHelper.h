//
//  IAPHelper.h
//  wipe
//
//  Created by Alberto Morales on 11/24/13.
//  Copyright (c) 2013 wipemyscreenclean.com. All rights reserved.
//

#import <StoreKit/StoreKit.h>
UIKIT_EXTERN NSString *const IAPHelperProductPurchasedNotification;


typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray * products);


@class IAPProduct;

@interface IAPHelper : NSObject

@property (nonatomic, strong) NSMutableDictionary * products;

- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler;
- (void)buyProduct:(IAPProduct *)product;
- (void)restoreCompletedTransactions;
- (void)pauseDownloads:(NSArray *)downloads;
- (void)resumeDownloads:(NSArray *)downloads;
- (void)cancelDownloads:(NSArray *)downloads;

- (BOOL)productPurchased:(NSString *)productIdentifier;


@end

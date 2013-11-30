//
//  IAPProduct.m

#import "IAPProduct.h"
#import "IAPProductInfo.h"

@implementation IAPProduct

- (id)initWithProductIdentifier:(NSString *)productIdentifier {
    if ((self = [super init])) {
        self.availableForPurchase = NO;
        self.productIdentifier = productIdentifier;
        self.skProduct = nil;
    }
    return self;
}

- (BOOL)allowedToPurchase {
    NSLog(@"here allowd to purh");
    if (!self.availableForPurchase) return NO;
    
    NSLog(@"here allowd to purh");
    if (self.purchaseInProgress) return NO;
    
    NSLog(@"here allowd to purh");
    if (!self.info) return NO;
    
    NSLog(@"here allowd to purh");
    if (!self.info.consumable && self.purchase) {
        return NO;
    }
    
    NSLog(@"here allowd to purh");
    
    return YES;
}

@end

//
//  IAPProduct.h


@class SKProduct;
@class IAPProductInfo;
@class IAPProductPurchase;
@class SKDownload;

@interface IAPProduct : NSObject



@property (nonatomic, assign) BOOL availableForPurchase;
@property (nonatomic, strong) NSString * productIdentifier;
@property (nonatomic, strong) SKProduct * skProduct;
@property (nonatomic, assign) BOOL purchaseInProgress;
@property (nonatomic, strong) IAPProductPurchase * purchase;
@property (nonatomic, strong) IAPProductInfo * info;
@property (nonatomic, strong) SKDownload * skDownload;
@property (nonatomic, assign) float progress;

- (id)initWithProductIdentifier:(NSString *)productIdentifier;
- (BOOL)allowedToPurchase;


@end

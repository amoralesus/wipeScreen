//
//  IAPProductPurchase.h


#import <Foundation/Foundation.h>

@interface IAPProductPurchase : NSObject <NSCoding>

- (id)initWithProductIdentifier:(NSString *)productIdentifier
                     consumable:(BOOL)consumable
                 timesPurchased:(int)timesPurchased
            libraryRelativePath:(NSString *)libraryRelativePath
                 contentVersion:(NSString *)contentVersion;

@property (nonatomic, strong) NSString * productIdentifier;
@property (nonatomic, assign) BOOL consumable;
@property (nonatomic, assign) int timesPurchased;
@property (nonatomic, strong) NSString * libraryRelativePath;
@property (nonatomic, strong) NSString * contentVersion;

@end

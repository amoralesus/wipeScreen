//
//  IAPProductInfo.h


#import <Foundation/Foundation.h>

@interface IAPProductInfo : NSObject

- (id)initFromDict:(NSDictionary *)dict;

@property (nonatomic, strong) NSString * productIdentifier;
@property (nonatomic, strong) NSString * icon;
@property (nonatomic, assign) BOOL consumable;
@property (nonatomic, strong) NSString * consumableIdentifier;
@property (nonatomic, assign) int consumableAmount;
@property (nonatomic, strong) NSString * bundleDir;

@end

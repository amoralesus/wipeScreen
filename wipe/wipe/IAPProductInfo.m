//
//  IAPProductInfo.m


#import "IAPProductInfo.h"

@implementation IAPProductInfo

- (id)initFromDict:(NSDictionary *)dict {
    if ((self = [super init])) {
        self.productIdentifier = dict[@"productIdentifier"];
        self.icon = dict[@"icon"];
        self.consumable = [dict[@"consumable"] boolValue];
        self.consumableIdentifier =
        dict[@"consumableIdentifier"];
        self.consumableAmount =
        [dict[@"consumableAmount"] intValue];
        self.bundleDir = dict[@"bundleDir"];
    }
    return self;
}

@end

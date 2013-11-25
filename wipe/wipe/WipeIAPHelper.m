//
//  WipeIAPHelper.m
//  wipe
//
//  Created by Alberto Morales on 11/24/13.
//  Copyright (c) 2013 wipemyscreenclean.com. All rights reserved.
//

#import "WipeIAPHelper.h"
#import "Search.h"
@implementation WipeIAPHelper

+ (WipeIAPHelper *)sharedInstance {
    static dispatch_once_t once;
    static WipeIAPHelper * sharedInstance;
    dispatch_once(&once, ^{
        Search *search = [[Search alloc]init];
        
        NSSet * productIdentifiers = [search setWithAllProductIdentifiers];
        
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}

@end


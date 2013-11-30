//
//  SearchResult.m
//  wipe
//
//  Created by Alberto Morales on 11/23/13.
//  Copyright (c) 2013 wipemyscreenclean.com. All rights reserved.
//

#import "SearchResult.h"
#import "WipeIAPHelper.h"
#import <StoreKit/StoreKit.h>

@implementation SearchResult


-(NSString *) productURL {
    NSString * url = [NSString stringWithFormat: @"http://personal.amorales.us/girls/1/avatar/?product_code=%@", self.productCode];
    return url;
}

-(BOOL) productPurchased {
    return [[WipeIAPHelper sharedInstance] productPurchased:self.productCode];
}

-(void) buyProduct {
    [[WipeIAPHelper sharedInstance] buyProduct:self.product];
}

@end

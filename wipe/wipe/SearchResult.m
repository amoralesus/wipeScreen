//
//  SearchResult.m
//  wipe
//
//  Created by Alberto Morales on 11/23/13.
//  Copyright (c) 2013 wipemyscreenclean.com. All rights reserved.
//

#import "SearchResult.h"

@implementation SearchResult


-(NSString *) productURL {
    NSString * url = [NSString stringWithFormat: @"http://personal.amorales.us/girls/1/avatar/?product_code=%@", self.productCode];
    NSLog(@"%@",url);
    return url;
}

@end

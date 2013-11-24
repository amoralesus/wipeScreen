//
//  Girl.m
//  wipe
//
//  Created by Alberto Morales on 11/24/13.
//  Copyright (c) 2013 wipemyscreenclean.com. All rights reserved.
//

#import "Girl.h"


@implementation Girl

@dynamic name;
@dynamic girlDescription;
@dynamic product_code;

-(NSString *) productURL {
    
    NSString * string = @"infer from the product code and the documents directory";
    return string;
}

-(NSString *) productVideo {
    NSString * string = [NSString stringWithFormat:@"%@.mov", self.product_code];
    return string;
}

@end

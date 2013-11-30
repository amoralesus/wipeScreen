//
//  SearchResult.h
//  wipe
//
//  Created by Alberto Morales on 11/23/13.
//  Copyright (c) 2013 wipemyscreenclean.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchResult : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *description;

@property (nonatomic, copy) NSString *productCode;



-(NSString *) productURL;

-(BOOL) productPurchased;

@end

//
//  SearchResult.h
//  wipe
//
//  Created by Alberto Morales on 11/23/13.
//  Copyright (c) 2013 wipemyscreenclean.com. All rights reserved.
//
// SearchResult is the object representation of the json object sent
// from the rails app that holds the inventory
// the object also is set with an skProduct which is the corresponding object
// uploaded to the apple in store purchase
// this object holds both object representations


#import <Foundation/Foundation.h>
#import "IAPProduct.h"

@interface SearchResult : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *description;

@property (nonatomic, copy) NSString *productCode;

@property IAPProduct *product;


-(NSString *) productURL;

-(BOOL) productPurchased;

-(void) buyProduct;

@end

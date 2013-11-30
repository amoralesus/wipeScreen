//
//  Search.h
//  wipe
//
//  Created by Alberto Morales on 11/23/13.
//  Copyright (c) 2013 wipemyscreenclean.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SearchResult.h"




@interface Search : NSObject

@property NSMutableArray * searchResults;
@property BOOL isLoading;

- (NSURL *)urlWithSearchText:(NSString *)searchText;

- (NSString *)performRequestWithURL:(NSURL *)url ;

- (void)showNetworkError;

- (NSDictionary *)parseJSON:(NSString *)jsonString;

- (NSMutableArray *)parseDictionaryAndSetResults:(NSDictionary *)dictionary;

-(NSSet *) setWithAllProductIdentifiers;

- (void)refreshStoreKitProductsList;


-(void) runSearchFor:(NSString *)string AndUpdateView: (UITableView *) theView;

@end

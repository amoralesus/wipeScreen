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


-(id) initWithCollection:(NSMutableArray *) array andTableView: (UITableView *) view;

-(void) runSearchFor:(NSString *) string;

@end

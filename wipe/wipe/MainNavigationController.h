//
//  MainNavigationController.h
//  wipe
//
//  Created by Alberto Morales on 11/24/13.
//  Copyright (c) 2013 wipemyscreenclean.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchViewController.h"
#import "GirlsViewController.h"


@interface MainNavigationController : UINavigationController

-(void) gotoSearchResultsController;

@property SearchViewController *searchViewController;


@end

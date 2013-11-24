//
//  MainNavigationController.m
//  wipe
//
//  Created by Alberto Morales on 11/24/13.
//  Copyright (c) 2013 wipemyscreenclean.com. All rights reserved.
//

#import "MainNavigationController.h"

@interface MainNavigationController ()

@end

@implementation MainNavigationController

-(id) init {
    
    self = [super init];
    
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) gotoSearchResultsController {
    
    self.searchViewController = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
    [self pushViewController: self.searchViewController animated: YES];
    
    
    NSLog(@"here");

}

@end

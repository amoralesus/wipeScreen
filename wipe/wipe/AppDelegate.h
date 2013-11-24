//
//  AppDelegate.h
//  wipe
//
//  Created by Alberto Morales on 11/23/13.
//  Copyright (c) 2013 wipemyscreenclean.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "SeedCoredata.h"
#import "MainNavigationController.h"

#import "SearchViewController.h"

#import "GirlsViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) SearchViewController *searchViewController;

@property (strong, nonatomic) GirlsViewController *girlsViewController;

@property (strong, nonatomic) SeedCoredata *seedCoredata;

@property (strong, nonatomic) MainNavigationController * mainNavigationController;


#pragma mark Core Data
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

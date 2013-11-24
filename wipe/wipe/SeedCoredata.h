//
//  SeedCoredata.h
//  wipe
//
//  Created by Alberto Morales on 11/24/13.
//  Copyright (c) 2013 wipemyscreenclean.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface SeedCoredata : NSObject


-(id) initWithContext:(NSManagedObjectContext *)theContext;

-(void) setupInitialDataset;

-(NSArray *) allGirlRecords;

@end

//
//  SeedCoredata.m
//  wipe
//
//  Created by Alberto Morales on 11/24/13.
//  Copyright (c) 2013 wipemyscreenclean.com. All rights reserved.
//

#import "SeedCoredata.h"
#import <CoreData/CoreData.h>
#import "Girl.h"

@implementation SeedCoredata {
    NSManagedObjectContext * _context;
}

+(void) setupInitialDatasetForContext:(NSManagedObjectContext *)context; {
    SeedCoredata *seed = [[SeedCoredata alloc] initWithContext:context];
    [seed setupInitialDatasetForContext:context];
    
}

-(id) initWithContext:(NSManagedObjectContext *)theContext {
    self = [super init];
    _context = theContext;
    return self;
}

-(void) setupInitialDatasetForContext:(NSManagedObjectContext *)context; {
    if ([self recordsInCoredata] == 0) {
        [self createLucia];
    }
    NSLog(@"%f",[self recordsInCoredata]);
    
}

-(void) createLucia {
    Girl *girl = [NSEntityDescription insertNewObjectForEntityForName:@"Girl" inManagedObjectContext:_context];
    girl.name = @"Lucia";
    girl.girlDescription = @"Pays for someone else to clean";
    girl.product_code = @"com.wipemyscreenclean.lucia";
    NSError * error;
    if(![_context save:&error]) {
        NSLog(@"could not save to db");
    }
}

-(double) recordsInCoredata {
    NSError * error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Girl" inManagedObjectContext:_context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [_context executeFetchRequest:fetchRequest error:&error];
    return [fetchedObjects count];
    
}

@end

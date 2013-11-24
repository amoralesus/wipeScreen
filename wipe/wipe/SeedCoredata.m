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
    NSArray *keys = [NSArray arrayWithObjects:@"entityName", @"primaryKeyName", @"name", @"girlDescription", @"product_code", nil];
    NSArray *objects = [NSArray arrayWithObjects:@"Girl", @"product_code", @"Bethany", @"Let me wipe your screen clean", @"com.wipemyscreenclean.bethany", nil];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    [self findOrCreateRecordsWithAttributes:dictionary];
    
    // this will be different when purchasing
    [self copyDemoFilesForDict: dictionary];
    
}

// NSArray *keys = [NSArray arrayWithObjects:@"entityName", @"primaryKeyName", @"name", @"girlDescription", @"product_code", nil];
// NSArray *objects = [NSArray arrayWithObjects:@"Girl", @"product_code", @"Bethany", @"Let me wipe your screen clean", @"com.wipemyscreenclean.bethany", nil];
// NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objectsforKeys:keys];

-(void) findOrCreateRecordsWithAttributes:(NSDictionary *) dict {
    if ([[self findRecordsWithAttributes:dict] count] == 0) {
        [self createGirlRecordWithAttributes:dict];
    }
}

-(NSArray *) findRecordsWithAttributes:(NSDictionary *) dict {

    NSString * entityName = [dict valueForKey:@"entityName"];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:_context];
    
    NSFetchRequest *fetch=[[NSFetchRequest alloc] init];
    [fetch setEntity:entity];
    
    NSString * primaryKeyName = [dict valueForKey:@"primaryKeyName"];
    NSString * primaryKeyValue = [dict valueForKey:primaryKeyName];
    NSPredicate *p=[NSPredicate predicateWithFormat:@"%@ == %@", primaryKeyName, primaryKeyValue];
    [fetch setPredicate:p];
    
    NSError *fetchError;
    NSArray *fetchedRecords=[_context executeFetchRequest:fetch error:&fetchError];
    return fetchedRecords;
}

-(void) createGirlRecordWithAttributes:(NSDictionary *) dict {
    Girl *girl = [NSEntityDescription insertNewObjectForEntityForName:@"Girl" inManagedObjectContext:_context];
    girl.name = [dict valueForKey:@"name"];
    girl.girlDescription = [dict valueForKey:@"girlDescription"];
    girl.product_code = [dict valueForKey:@"product_code"];
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

-(void) copyDemoFilesForDict:(NSDictionary *) dict {
    [self copyFile:[dict valueForKey:@"product_code"] ofType: @"mov"];
    [self copyFile:[dict valueForKey:@"product_code"] ofType: @"jpg"];
}

-(void) copyFile:(NSString *) filename ofType: (NSString *) fileType {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSMutableString *fileBaseName = [NSMutableString stringWithString:filename];
    [fileBaseName appendString:fileType];
    
    NSString *txtPath = [documentsDirectory stringByAppendingPathComponent: fileBaseName];
    
    if ([fileManager fileExistsAtPath:txtPath] == NO) {
        NSString *resourcePath = [[NSBundle mainBundle] pathForResource:filename ofType:fileType];
        [fileManager copyItemAtPath:resourcePath toPath:txtPath error:&error];
    }
}

@end

//
//  Girl.h
//  wipe
//
//  Created by Alberto Morales on 11/24/13.
//  Copyright (c) 2013 wipemyscreenclean.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Girl : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * girlDescription;
@property (nonatomic, retain) NSString * product_code;

-(NSString *) productURL;

-(NSString *) productVideo;

@end

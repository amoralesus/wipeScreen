//
//  VideoPlayer.h
//  wipe
//
//  Created by Alberto Morales on 11/24/13.
//  Copyright (c) 2013 wipemyscreenclean.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoPlayer : NSObject

-(void) playMovie:(NSString *) fileBasename inView:(UIView *) view;

@end

//
//  VideoPlayer.m
//  wipe
//
//  Created by Alberto Morales on 11/24/13.
//  Copyright (c) 2013 wipemyscreenclean.com. All rights reserved.
//

#import "VideoPlayer.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation VideoPlayer {
    MPMoviePlayerController * _moviePlayerController;
}


-(void) playMovie:(NSString *) fileBasename inView:(UIView *) view {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths firstObject];
    NSString *filename = [documentsDirectory stringByAppendingPathComponent:fileBasename];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:filename] == YES) {
        NSURL * url = [[NSURL alloc] initFileURLWithPath:filename];
        
        // create movie player
        _moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:url];
        _moviePlayerController.view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
        
        [self registerObservers];
        
        [view addSubview:_moviePlayerController.view];
        
        _moviePlayerController.fullscreen = YES;
        _moviePlayerController.allowsAirPlay = YES;
        _moviePlayerController.shouldAutoplay = YES;
        _moviePlayerController.controlStyle = MPMovieControlStyleEmbedded;
        
    }
    else {
        NSLog(@"File path wrong");
    }
}

#pragma mark Observers

-(void) registerObservers {
    // add observers to stop the movie
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackDidFinish:) name: MPMoviePlayerPlaybackDidFinishNotification object:_moviePlayerController];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MPMoviePlayerDidExitFullscreen:) name:MPMoviePlayerDidExitFullscreenNotification object:_moviePlayerController];
    
}

- (void) moviePlayBackDidFinish:(NSNotification*)notification {
    MPMoviePlayerController *player = [notification object];
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:MPMoviePlayerPlaybackDidFinishNotification
     object:player];
    
    if ([player
         respondsToSelector:@selector(setFullscreen:animated:)])
    {
        [player.view removeFromSuperview];
    }
}

- (void)MPMoviePlayerDidExitFullscreen:(NSNotification *)notification
{
    MPMoviePlayerController *player = [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerDidExitFullscreenNotification object:player];
    [player stop];
    [player.view removeFromSuperview];
}

@end

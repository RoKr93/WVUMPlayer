//
//  RKViewController.h
//  WVUMPlayer
//
//  Created by Roshan Krishnan on 12/17/13.
//  Copyright (c) 2013 Roshan Krishnan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <AVFoundation/AVFoundation.h>

@interface RKViewController : UIViewController{
    IBOutlet UIButton *playMusic;
    IBOutlet UIButton *stopMusic;
    IBOutlet UIButton *infoButton;
    IBOutlet UILabel *currentInfo;
    MPMoviePlayerController *player;
    
    BOOL isPlaying;
}

@property (nonatomic) AVPlayer *audioPlayer;

-(IBAction)startButtonPressed:(id)sender;
-(IBAction)stopButtonPressed:(id)sender;
-(IBAction)infoButtonPressed:(id)sender;
-(void)loadCurrentInfo;
-(BOOL)connected;

@end

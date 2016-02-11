//
//  RKViewController.m
//  WVUMPlayer
//
//  Created by Roshan Krishnan on 12/17/13.
//  Copyright (c) 2013 Roshan Krishnan. All rights reserved.
//

#import "RKViewController.h"

@interface RKViewController ()

@end

@implementation RKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    isPlaying = NO;
    self.audioPlayer = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:@"http://www.wvum.org:9010/stream"]];
    currentInfo.numberOfLines = 0;
    CGSize labelSize = [currentInfo.text sizeWithFont:currentInfo.font
                              constrainedToSize:currentInfo.frame.size
                                  lineBreakMode:currentInfo.lineBreakMode];
    currentInfo.frame = CGRectMake(
                             currentInfo.frame.origin.x, currentInfo.frame.origin.y,
                             currentInfo.frame.size.width, labelSize.height);
    
    //check for internet connection
    if(![self connected]){
        //if no connection, display warning message.
        NSString *message = @"Your iPhone does not have a network connection. Please try again later.";
        
        UIAlertView *info = [[UIAlertView alloc]
                             initWithTitle:@"Warning" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [info show];
    }else{
        //if connected, get info from web.
        [self loadCurrentInfo];
        [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(loadCurrentInfo) userInfo:nil repeats:YES];
    }
    
}
-(void)loadCurrentInfo{
    //grab HTML code from web player.
    NSError *error = nil;
    NSString *html = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.wvum.org/web-player/"] encoding:NSASCIIStringEncoding error:&error];
    
    //get string that contains artist name and song name.
    NSScanner *stringScanner = [NSScanner scannerWithString:html];
    NSString *htmlContent = [[NSString alloc] init];
    while ([stringScanner isAtEnd] == NO) {
        [stringScanner scanUpToString:@"<!--includeThisInApp-->" intoString:nil];
        [stringScanner scanUpToString:@"</" intoString:&htmlContent];
    }
    htmlContent = [htmlContent substringFromIndex:23];

    //replace irregular HTML characters.
    NSMutableString *printedContent = [[NSMutableString alloc] init];
    for(int i = 0; i < htmlContent.length; i++){
        char c = [htmlContent characterAtIndex:i];
        NSString *firstString = [NSString stringWithFormat:@"%c", c];
        NSString *compString = [NSString stringWithFormat:@"â"];
        if([firstString isEqualToString:compString]){
            [printedContent appendString:@"'"];
        }else{
            NSString *s = [NSString stringWithFormat:@"%c", c];
            [printedContent appendString:s];
        }
    }
    
    currentInfo.text = printedContent;
    [self.view setNeedsDisplay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)startButtonPressed:(id)sender{
    //if not already playing, begin streaming.
    if([self connected] && !isPlaying){
        isPlaying = YES;
        
        // this should always happen, but check anyway I suppose
        if(self.audioPlayer)
            [self.audioPlayer play];
        
        [self loadCurrentInfo];
    }
}

-(IBAction)stopButtonPressed:(id)sender{
    //if already playing, stop streaming.
    if([self connected] && isPlaying){
        isPlaying = NO;
        
        // this is super dumb, but AVPlayers don't have a stop method. So we pause, destroy the
        // object, then re-create it. Re-creation is done here so there's minimal delay when we
        // press start again.
        [self.audioPlayer pause];
        self.audioPlayer = nil;
        self.audioPlayer = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:@"http://www.wvum.org:9010/stream"]];
    }
}

-(IBAction)infoButtonPressed:(id)sender{
    //display information.
    NSString *message = @"WVUM 90.5 is the voice of the University of Miami. Check us out at www.wvum.org.";

    UIAlertView *info = [[UIAlertView alloc]
                         initWithTitle:@"Information" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [info show];
}

-(BOOL)connected{
    //check for internet connection using Tony Million's Reachability.h/.m, return YES or NO accordingly.
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}

@end

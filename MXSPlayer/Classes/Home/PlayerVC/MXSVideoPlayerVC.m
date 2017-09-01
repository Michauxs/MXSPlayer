//
//  MXSVideoPlayerVC.m
//  MXSPlayer
//
//  Created by Alfred Yang on 30/8/17.
//  Copyright © 2017年 MXS. All rights reserved.
//

#import "MXSVideoPlayerVC.h"
#import "AppDelegate.h"
#import "JWPlayer.h"
#import "MXSPLayerCoverView.h"

@interface MXSVideoPlayerVC ()

@end

@implementation MXSVideoPlayerVC {
	AVPlayer *handlePlayer;
	MXSPLayerCoverView *coverView;
	
	
	NSTimer *sliderTimer;
	
	BOOL isHideStatus;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [Tools blackColor];
	isHideStatus = YES;
	
	NSURL *videoURL = [NSURL fileURLWithPath:self.videoPath];
	
	AVPlayerItem *item = [AVPlayerItem playerItemWithURL:videoURL];
	handlePlayer = [[AVPlayer alloc] initWithPlayerItem:item];
	
	AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:handlePlayer];
	playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
	playerLayer.contentsScale = SCREEN_SCALE;
	playerLayer.frame = CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
	[self.view.layer addSublayer:playerLayer];
	
	[handlePlayer play];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished) name:AVPlayerItemDidPlayToEndTimeNotification object:handlePlayer.currentItem];
	
	coverView = [[MXSPLayerCoverView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH) andregController:self];
	[self.view addSubview:coverView];
	coverView.itemDuration = CMTimeGetSeconds(item.asset.duration);
	coverView.videoTitle = _videoData.videoName;
	
	self.view.userInteractionEnabled = YES;
	[self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelfViewTap)]];
	
	
	sliderTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(sliderTimerRun) userInfo:nil repeats:YES];
	[sliderTimer setFireDate:[NSDate distantPast]];
	
	
//	JWPlayer *player = [[JWPlayer alloc] initWithFrame:CGRectMake(0, 0, 414,9*414/16)];
//	[player updatePlayerWith:[NSURL URLWithString:@"http://120.25.226.186:32812/resources/videos/minion_01.mp4"]];
////	[player updatePlayerWith:[NSURL URLWithString:self.videoPath]];
//	[self.view addSubview:player];
	
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
//	self.view.transform = CGAffineTransformRotate (self.view.transform, -M_PI_2);
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark -- actions
- (void)sliderTimerRun {
	
	CGFloat current = CMTimeGetSeconds([handlePlayer.currentItem currentTime]);
	coverView.currentSecond = current;
}

- (void)didSelfViewTap {
	isHideStatus = NO;
	[self setNeedsStatusBarAppearanceUpdate];
	coverView.hidden = NO;
}

- (void)playbackFinished {
	[coverView videoPlayFinished];
	[self didBackBtnClick];
}

- (void)didBackBtnClick {
	
	[sliderTimer invalidate];
	sliderTimer = nil;
	
	NSLog(@"didBackBtnClick");
	[self dismissViewControllerAnimated:YES completion:^{
		[handlePlayer.currentItem cancelPendingSeeks];
		[handlePlayer.currentItem.asset cancelLoading];
		[[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
	}];
}

- (BOOL)prefersStatusBarHidden {
	return isHideStatus;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
	return UIInterfaceOrientationLandscapeRight;
}

- (BOOL)shouldAutorotate {
	return NO;
}

#pragma mark -- notifies
- (id)seekProgressWithTrans:(id)args {
	NSNumber *tmp = args;
	[handlePlayer.currentItem seekToTime:CMTimeMake(tmp.floatValue, 1) completionHandler:^(BOOL finished) {
		
	}];
	return nil;
}

- (id)playerPause {
	[sliderTimer setFireDate:[NSDate distantFuture]];
	[handlePlayer pause];
	return nil;
}

- (id)playerResume {
	[sliderTimer setFireDate:[NSDate distantPast]];
	[handlePlayer play];
	return nil;
}

- (id)didCoverViewTap {
	isHideStatus = YES;
	[self setNeedsStatusBarAppearanceUpdate];
	coverView.hidden = YES;
	return nil;
}


@end

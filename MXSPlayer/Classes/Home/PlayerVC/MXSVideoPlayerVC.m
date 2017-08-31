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
	
	self.view.userInteractionEnabled = YES;
	[self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelfViewTap)]];
	
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
- (void)didSelfViewTap {
	isHideStatus = NO;
	[self setNeedsStatusBarAppearanceUpdate];
	coverView.hidden = NO;
}

- (void)playbackFinished {
	[self didBackBtnClick];
}

- (void)didBackBtnClick {
	[coverView videoPlayFinished];
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


#pragma mark -- notifies
- (id)demo:(id)args {
//	[handlePlayer.currentItem avi];
	return nil;
}

- (id)playerPause {
	
	[handlePlayer pause];
	return nil;
}

- (id)playerResume {
	
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

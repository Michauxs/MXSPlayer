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

@interface MXSVideoPlayerVC ()

@end

@implementation MXSVideoPlayerVC {
	AVPlayer *handlePlayer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
//	AppDelegate *degate = [[UIApplication sharedApplication] delegate];
//	degate.allowRotation = YES;
//	
	NSURL *videoURL = [NSURL fileURLWithPath:self.videoPath];
	
	handlePlayer = [[AVPlayer alloc] initWithPlayerItem:[AVPlayerItem playerItemWithURL:videoURL]];
	
	AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:handlePlayer];
//	playerLayer size
	playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
	playerLayer.contentsScale = SCREEN_SCALE;
	playerLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
	[self.view.layer addSublayer:playerLayer];
	
	[handlePlayer play];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished) name:AVPlayerItemDidPlayToEndTimeNotification object:handlePlayer.currentItem];
	
	
	
	UIButton *backBtn = [Tools creatUIButtonWithTitle:@"BACK" andTitleColor:[Tools whiteColor] andFontSize:13.f andBackgroundColor:[Tools borderAlphaColor]];
	[self.view addSubview:backBtn];
	[backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.view).offset(15);
		make.top.equalTo(self.view).offset(10);
		make.size.mas_equalTo(CGSizeMake(44, 44));
	}];
	[backBtn addTarget:self action:@selector(didBackBtnClick) forControlEvents:UIControlEventTouchUpInside];
	
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
- (void)playbackFinished {
	[self didBackBtnClick];
}

- (void)didBackBtnClick {
	[self dismissViewControllerAnimated:YES completion:^{
		[handlePlayer.currentItem cancelPendingSeeks];
		[handlePlayer.currentItem.asset cancelLoading];
		[[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
	}];
}

- (BOOL)prefersStatusBarHidden {
	return YES;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return UIDeviceOrientationLandscapeLeft;
}

- (BOOL)shouldAutorotate {
//	if ([self.topViewController isKindOfClass:[AddMovieViewController class]]) {// 如果是这个 vc 则支持自动旋转
//		return YES;
//	}
	return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
	return UIInterfaceOrientationMaskAllButUpsideDown;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  MXSPLayerCoverView.m
//  MXSPlayer
//
//  Created by Alfred Yang on 31/8/17.
//  Copyright © 2017年 MXS. All rights reserved.
//

#import "MXSPLayerCoverView.h"

@implementation MXSPLayerCoverView {
	
	UIView *topDivView;
	UIView *btmDivView;
	
	UIView *progressBG;
	UIView *progressSlider;
	
	NSTimer *sliderTimer;
	CGFloat slider_time_count;
}

- (instancetype)initWithFrame:(CGRect)frame andregController:(id)controller {
	self = [super initWithFrame:frame];
	if (self) {
		
		self.controller = controller;
		self.backgroundColor = [UIColor clearColor];
		self.hidden = YES;
		self.userInteractionEnabled = YES;
		[self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didCoverViewTap)]];
		slider_time_count = 0.5;
		
		topDivView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, kSTATUSANDNAVHEIGHT)];
		[self addSubview:topDivView];
		topDivView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5f];
		
		btmDivView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH - kTABBARHEIGHT, SCREEN_HEIGHT, kTABBARHEIGHT)];
		[self addSubview:btmDivView];
		btmDivView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5f];
		
		UIButton *backBtn = [[UIButton alloc] init];
		[backBtn setImage:IMGRESOURE(@"icon_arrow_back") forState:UIControlStateNormal];
		[topDivView addSubview:backBtn];
		[backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(topDivView).offset(15);
			make.centerY.equalTo(topDivView).offset(10);
			make.size.mas_equalTo(CGSizeMake(44, 44));
		}];
		[backBtn addTarget:self action:@selector(didBackBtnClick) forControlEvents:UIControlEventTouchUpInside];
		
		
		UIButton *startAndPauseBtn = [[UIButton alloc] init];
		[startAndPauseBtn setImage:IMGRESOURE(@"play_icon_start") forState:UIControlStateNormal];
		[startAndPauseBtn setImage:IMGRESOURE(@"play_icon_pause") forState:UIControlStateSelected];
		[btmDivView addSubview:startAndPauseBtn];
		[startAndPauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(btmDivView);
			make.left.equalTo(btmDivView).offset(15);
			make.size.equalTo(backBtn);
		}];
		[startAndPauseBtn addTarget:self action:@selector(didStartAndPauseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
		startAndPauseBtn.selected = YES;
		
		CGFloat progressBGWith = SCREEN_HEIGHT - 15 - 44 - 15 - 15;
		progressBG = [UIView new];
		progressBG.backgroundColor  = [UIColor colorWithWhite:0.f alpha:0.75];
		[btmDivView addSubview:progressBG];
		[progressBG mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(startAndPauseBtn.mas_right).offset(15);
			make.centerY.equalTo(btmDivView);
			make.width.mas_equalTo(progressBGWith);
			make.height.mas_equalTo(2);
		}];
		progressSlider = [UIView new];
		progressSlider.backgroundColor  = [UIColor orangeColor];
		[btmDivView addSubview:progressSlider];
		[progressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(progressBG);
			make.centerY.equalTo(btmDivView);
			make.width.mas_equalTo(0);
			make.height.mas_equalTo(2);
		}];
		
		[Tools setViewBorder:progressBG withRadius:1.f andBorderWidth:0 andBorderColor:nil andBackground:nil];
		[Tools setViewBorder:progressSlider withRadius:1.f andBorderWidth:0 andBorderColor:nil andBackground:nil];
		
		sliderTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
		[sliderTimer setFireDate:[NSDate distantPast]];
	}
	
	return self;
}

- (void)timerRun {
	slider_time_count = slider_time_count + 0.5;
	CGFloat percet = slider_time_count/_itemDuration;
	NSLog(@"%f", percet);
	
	[UIView animateWithDuration:0.5 animations:^{
		progressSlider.frame = CGRectMake(progressBG.frame.origin.x, progressBG.frame.origin.y, progressBG.frame.size.width * percet, progressBG.bounds.size.height);
	}];
	
}

- (void)videoPlayFinished {
	slider_time_count = 0;
	[sliderTimer invalidate];
	sliderTimer = nil;
}

- (void)setItemDuration:(CGFloat)itemDuration {
	_itemDuration = itemDuration;
	
}

- (void)didBackBtnClick {
	[self notifyWithMethod:@"didBackBtnClick" andArgs:nil];
}

- (void)didStartAndPauseBtnClick:(UIButton*)btn {
	
	if (btn.selected) {
		[self notifyWithMethod:@"playerPause" andArgs:nil];
		[sliderTimer setFireDate:[NSDate distantFuture]];
	} else {
		[self notifyWithMethod:@"playerResume" andArgs:nil];
		[sliderTimer setFireDate:[NSDate distantPast]];
	}
	
	btn.selected = !btn.selected;
}

- (void)didCoverViewTap {
	[self notifyWithMethod:@"didCoverViewTap" andArgs:nil];
}

- (void)notifyWithMethod:(NSString*)methodName andArgs:(id)args {
	
	SEL sel = NSSelectorFromString(methodName);
	Method m = class_getInstanceMethod([_controller class], sel);
	IMP imp = method_getImplementation(m);
	if (m) {
		if (args) {
			id (*func)(id, SEL, id) = (id (*)(id, SEL, id))imp;
			func(_controller, sel, args);
		} else {
			id (*func)(id, SEL) = (id (*)(id, SEL))imp;
			func(_controller, sel);
		}
	}
}

@end

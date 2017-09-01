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
	
	UILabel *titleLabel;
	UILabel *timeGoLabel;
	
	UIView *progressBG;
	UIView *progressSlider;
	
}

- (instancetype)initWithFrame:(CGRect)frame andregController:(id)controller {
	self = [super initWithFrame:frame];
	if (self) {
		
		self.controller = controller;
		self.backgroundColor = [UIColor clearColor];
		self.hidden = YES;
		
		self.userInteractionEnabled = YES;
		UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didCoverViewTap)];
		[self addGestureRecognizer:tapGR];
		
		UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGRAction:)];
		[self addGestureRecognizer:panGR];
		
		topDivView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, kSTATUSANDNAVHEIGHT)];
		[self addSubview:topDivView];
		topDivView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5f];
		titleLabel = [Tools creatUILabelWithText:@"Video Title" andTextColor:[Tools whiteColor] andFontSize:313.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
		[topDivView addSubview:titleLabel];
		[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(topDivView);
			make.centerY.equalTo(topDivView).offset(10);
		}];
		
		
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
		
		timeGoLabel = [Tools creatUILabelWithText:@"00:00/00:00" andTextColor:[Tools whiteColor] andFontSize:10.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentRight];
		[btmDivView addSubview:timeGoLabel];
		[timeGoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(btmDivView);
			make.right.equalTo(btmDivView).offset(-15);
		}];
		
		progressBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, 2)];
		progressBG.backgroundColor  = [UIColor colorWithWhite:0.f alpha:0.75];
		[btmDivView addSubview:progressBG];
		
		progressSlider = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 2)];
		progressSlider.backgroundColor  = [UIColor orangeColor];
		[btmDivView addSubview:progressSlider];
		
		[Tools setViewBorder:progressBG withRadius:1.f andBorderWidth:0 andBorderColor:nil andBackground:nil];
		[Tools setViewBorder:progressSlider withRadius:1.f andBorderWidth:0 andBorderColor:nil andBackground:nil];
		
	}
	
	return self;
}

- (void)panGRAction:(UIPanGestureRecognizer*)pan {
	
	static CGFloat time_node = 0.f;
	UIGestureRecognizerState state = pan.state;
	switch (state) {
		case UIGestureRecognizerStateBegan:
		{
			time_node = _currentSecond;
		}
			break;
		case UIGestureRecognizerStateEnded:
		{
			CGPoint p = [pan translationInView:self];
			NSLog(@"%f,%f",p.x, p.y);
			
			CGFloat t_x = p.x;
			CGFloat video_real_changed = t_x - (_currentSecond - time_node) + _currentSecond;
			
			NSNumber *tmp = [NSNumber numberWithFloat:video_real_changed];
			[self notifyWithMethod:@"seekProgressWithTrans:" andArgs:tmp];
			
			CGFloat percet = (video_real_changed)/_itemDuration;
			progressSlider.frame = CGRectMake(progressBG.frame.origin.x, progressBG.frame.origin.y, progressBG.frame.size.width * percet, progressBG.bounds.size.height);
			
		}
			break;
		default:
			break;
	}
}

- (void)videoPlayFinished {
	progressSlider.frame = CGRectMake(progressBG.frame.origin.x, progressBG.frame.origin.y, progressBG.frame.size.width, progressBG.bounds.size.height);
}

- (void)setCurrentSecond:(CGFloat)currentSecond {
	_currentSecond = currentSecond;
	
	CGFloat percet = _currentSecond/_itemDuration;
	progressSlider.frame = CGRectMake(progressBG.frame.origin.x, progressBG.frame.origin.y, progressBG.frame.size.width * percet, progressBG.bounds.size.height);
	
	int second_d = _itemDuration/60;
	int miniter_d = (int)_itemDuration%60;
	int second_t = _currentSecond/60;
	int miniter_t = (int)_currentSecond%60;
	
	timeGoLabel.text = [NSString stringWithFormat:@"%.2d:%.2d/%.2d:%.2d",second_t, miniter_t, second_d, miniter_d];
	
}

- (void)setVideoTitle:(NSString *)videoTitle {
	_videoTitle = videoTitle;
	titleLabel.text = videoTitle;
}

- (void)didBackBtnClick {
	[self notifyWithMethod:@"didBackBtnClick" andArgs:nil];
}

- (void)didStartAndPauseBtnClick:(UIButton*)btn {
	
	if (btn.selected) {
		[self notifyWithMethod:@"playerPause" andArgs:nil];
	} else {
		[self notifyWithMethod:@"playerResume" andArgs:nil];
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

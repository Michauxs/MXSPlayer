//
//  MXSPLayerCoverView.h
//  MXSPlayer
//
//  Created by Alfred Yang on 31/8/17.
//  Copyright © 2017年 MXS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MXSPLayerCoverView : UIView

@property (nonatomic, weak) id controller;
@property (nonatomic, assign) CGFloat itemDuration;

- (instancetype)initWithFrame:(CGRect)frame andregController:(id)controller;
- (void)videoPlayFinished;

@end

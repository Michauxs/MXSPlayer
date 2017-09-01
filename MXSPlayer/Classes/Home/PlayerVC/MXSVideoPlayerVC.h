//
//  MXSVideoPlayerVC.h
//  MXSPlayer
//
//  Created by Alfred Yang on 30/8/17.
//  Copyright © 2017年 MXS. All rights reserved.
//

#import "MXSViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "VideoModel.h"

@interface MXSVideoPlayerVC : MXSViewController <AVPlayerItemOutputPullDelegate>

@property (nonatomic, strong) NSString *videoPath;
@property (nonatomic, strong) VideoModel *videoData;

@end

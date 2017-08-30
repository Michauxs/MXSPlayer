//
//  UIImage+categorys.m
//  
//
//  Created by peiwen on 14/12/15.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface UIImage (category)

+ (UIImage *)imageWithColor:(UIColor *)color;
- (UIColor *)colorAtPoint:(CGPoint )point;
- (UIColor *)colorAtPixel:(CGPoint)point;

//返回该图片是否有透明度通道
- (BOOL)hasAlphaChannel;

///获得灰度图
+ (UIImage*)covertToGrayImageFromImage:(UIImage*)sourceImage;

+ (UIImage *)imageWithLayer:(CALayer *)lay;

+(UIImage *)getThumbnailImage:(NSString *)videoURL;

@end

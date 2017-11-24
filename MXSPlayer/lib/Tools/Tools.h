//
//  Tools.h
//  BabySharing
//
//  Created by monkeyheng on 16/2/23.
//  Copyright © 2016年 BM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Tools : NSObject

+ (UIImage *)imageWithView:(UIView *)view;
+ (NSString *)subStringWithByte:(NSInteger)byte str:(NSString *)str;
+ (NSInteger)bityWithStr:(NSString *)str;
+ (UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size;
+ (NSArray *)sortWithArr:(NSArray *)arr headStr:(NSString *)headStr;
+ (UIColor *)colorWithRED:(CGFloat)RED GREEN:(CGFloat)GREEN BLUE:(CGFloat)BLUE ALPHA:(CGFloat)ALPHA;
+ (UIImage *)addPortraitToImage:(UIImage *)image userHead:(UIImage *)userhead userName:(NSString *)userName;
+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSString *)compareCurrentTime:(NSDate*) compareDate;
+ (NSString *)compareFutureTime:(NSDate *)compareDate;

+ (NSString*)getDeviceUUID;
+ (NSString*)getUUIDString;

+ (UIViewController *)activityViewController;
+ (UIViewController *)activityViewController2;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
+ (CGSize)sizeWithString:(NSString*)str withFont:(UIFont*)font andMaxSize:(CGSize)sz;

+ (UIColor *)randomColor;
+ (UIColor *)whiteColor;

+ (UIColor *)themeColor;
+ (UIColor *)themeBorderColor;

+ (UIColor *)blackColor;
+ (UIColor *)garyColor;
+ (UIColor *)lightGaryColor;
+ (UIColor*)RGB153GaryColor;
+ (UIColor*)RGB89GaryColor;
+ (UIColor*)RGB127GaryColor;
+ (UIColor*)RGB225GaryColor;

+ (UIColor *)garyLineColor;
+ (UIColor *)garyBackgroundColor;
+ (UIColor *)darkBackgroundColor;

+ (UIColor *)disableBackgroundColor;

+ (UIColor *)borderAlphaColor;

#pragma mark -- UIView
+ (UILabel*)creatUILabelWithText:(NSString*)text andTextColor:(UIColor*)color andFontSize:(CGFloat)font andBackgroundColor:(UIColor*)backgroundColor andTextAlignment:(NSTextAlignment)align;
+ (UIButton*)creatUIButtonWithTitle:(NSString*)title andTitleColor:(UIColor*)TitleColor andFontSize:(CGFloat)font andBackgroundColor:(UIColor*)backgroundColor;

+ (void)setViewBorder:(UIView*)view withRadius:(CGFloat)radius andBorderWidth:(CGFloat)width andBorderColor:(UIColor*)color andBackground:(UIColor*)backColor;
+ (void)setShadowOfView:(UIView*)view withViewRadius:(CGFloat)radius_v andColor:(UIColor*)color andOffset:(CGSize)size andOpacity:(CGFloat)opacity andShadowRadius:(CGFloat)radius_s;

#pragma mark -- CALayer
+ (void)addBtmLineWithMargin:(CGFloat)margin andAlignment:(NSInteger)alignment andColor:(UIColor*)lineColor inSuperView:(UIView*)superView;
+ (void)creatCALayerWithFrame:(CGRect)frame andColor:(UIColor*)color inSuperView:(UIView*)view;

#pragma mark -- AYBtmAlert
- (void)AYShowBtmAlertWithArgs:(NSDictionary*)args;

#pragma mark -- NSAttributedString
+ (NSAttributedString*)transStingToAttributeString:(NSString*)string withLineSpace:(CGFloat)lineSpace;

#pragma mark -- NSTime
+ (NSDateFormatter*)creatDateFormatterWithString:(NSString*)formatter;

#pragma mark -- Bit64String
+ (NSString*)Bit64String:(NSString*)string;

+ (UIImage*)SourceImageWithRect:(CGRect)rc fromView:(UIView*)view;
+ (UIImage*)splitImage:(UIImage *)image from:(CGFloat)height left:(UIImage**)pImg;
@end

//
//  PDProgressHUD+ALExtension.h
//  ALExtension
//
//  Created by Albert Lee on 4/7/15.
//  Copyright (c) 2015 Albert Lee. All rights reserved.
//
#import "../Objects/PDProgressHUD.h"
@class PDProgressHUD;
@interface PDProgressHUD (ALExtension)
#pragma mark MBProgressHUB
+ (void)showTip:(NSString*)tip;
+ (void)showTip:(NSString*)tip time:(CGFloat)time;
+ (void)showTip:(NSString*)tip onView:(UIView*)view;
+ (void)showTip:(NSString*)tip detail:(NSString *)detail time:(CGFloat)time completionBlock:(PDProgressHUDCompletionBlock)block;
+ (void)showTipForever:(NSString*)tip onView:(UIView*)view;
+ (PDProgressHUD *)showLoadingInView:(UIView*)view;
@end

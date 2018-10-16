//
//  PDProgressHUD+ALExtension.m
//  ALExtension
//
//  Created by Albert Lee on 4/7/15.
//  Copyright (c) 2015 Albert Lee. All rights reserved.
//

#import "PDProgressHUD+ALExtension.h"

@implementation PDProgressHUD (ALExtension)
#pragma mark - MBProgressHUB
+ (void)showTip:(NSString*)tip
{
  [self showTip:tip time:1.0];
}

+ (void)showTip:(NSString*)tip time:(CGFloat)time{
  PDProgressHUD *hud = [PDProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
  hud.mode = PDProgressHUDModeText;
  hud.labelText = tip;
  hud.removeFromSuperViewOnHide = YES;
  [hud hide:YES afterDelay:time];
}

+ (void)showTip:(NSString*)tip detail:(NSString *)detail time:(CGFloat)time completionBlock:(PDProgressHUDCompletionBlock)block{
  PDProgressHUD *hud = [PDProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
  hud.completionBlock = block;
  hud.mode = PDProgressHUDModeText;
  hud.labelText = tip;
  hud.detailsLabelText = detail;
  hud.removeFromSuperViewOnHide = YES;
  [hud hide:YES afterDelay:time];
}

+ (void)showTip:(NSString*)tip onView:(UIView*)view;{
  PDProgressHUD *hud = [PDProgressHUD showHUDAddedTo:view animated:YES];
  hud.mode = PDProgressHUDModeText;
  hud.labelText = tip;
  hud.removeFromSuperViewOnHide = YES;
  [hud hide:YES afterDelay:1.5];
}
+ (void)showTipForever:(NSString*)tip onView:(UIView*)view
{
  PDProgressHUD *hud = [PDProgressHUD showHUDAddedTo:view animated:YES];
  hud.mode = PDProgressHUDModeText;
  hud.labelText = tip;
  hud.removeFromSuperViewOnHide = YES;
  [hud hide:YES afterDelay:10000.0];
}

+ (PDProgressHUD *)showLoadingInView:(UIView*)view
{
  PDProgressHUD *hud = [PDProgressHUD showHUDAddedTo:view animated:YES];
  hud.removeFromSuperViewOnHide = YES;
  return hud;
}
@end

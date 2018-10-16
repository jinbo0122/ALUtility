//
//  UIBarButtonItem+ALExtension.m
//  ALExtension
//
//  Created by Albert Lee on 4/7/15.
//  Copyright (c) 2015 Albert Lee. All rights reserved.
//

#import "UIBarButtonItem+ALExtension.h"
#import "ALExtension.h"
@implementation UIBarButtonItem (ALExtension)
#pragma mark Navigation Item
+ (NSArray *)loadBarButtonItemWithTitle:(NSString*)title
                                  color:(UIColor*)textColor
                                   font:(UIFont*)font
                                 target:(id)target
                                 action:(SEL)action
                                 offset:(CGFloat)offset{
  UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                     target:nil action:nil];
  if (offset!=0) {
    negativeSpacer.width = offset;
  }else{
    negativeSpacer.width = 0;
  }
  if (isRunningOnIOS11) {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:title
                                                             style:UIBarButtonItemStylePlain
                                                            target:target
                                                            action:action];
    [item setTitlePositionAdjustment:UIOffsetMake(10, 0) forBarMetrics:UIBarMetricsDefault];
    [item setTitleTextAttributes:@{NSFontAttributeName:font} forState:UIControlStateNormal];
    item.tintColor = textColor;
    return @[negativeSpacer,item];
  }else{
    UIBarButtonItem *bbtn;
    CGFloat offsetX = 10;
#ifndef BBSDKMODE
#else
    if ([BBLiveSDKUtility isBaiduVideoSDK]) {
      offsetX = -5;
    }
#endif
    CGSize size = [title sizeWithAttributes:@{NSFontAttributeName:font}];
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, 0, MAX(70, size.width), 40)];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.text = title;
    lblTitle.textColor = textColor;
    lblTitle.textAlignment = NSTextAlignmentRight;
    lblTitle.font = font;
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, lblTitle.width, 40) ];
    [view addSubview:lblTitle];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    tapGesture.numberOfTouchesRequired = 1;
    [view addGestureRecognizer:tapGesture];
    
    bbtn = [[UIBarButtonItem alloc] initWithCustomView:view];
    return @[negativeSpacer,bbtn];
  }
}

+ (UIBarButtonItem*)loadBarButtonItemWithImage:(NSString*)imageName rect:(CGRect)rect arget:(id)target action:(SEL)action{
  if (isRunningOnIOS11) {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamedNoCache:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                             style:UIBarButtonItemStylePlain
                                                            target:target
                                                            action:action];
    return item;
  }else{
    UIBarButtonItem *bbtn;
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamedNoCache:imageName]];
#ifndef BBSDKMODE
#else
    if ([imageName isEqualToString:[ALUtility backBarButtonArrowResource]] && !imageView.image) {
      NSString *url = [BBLiveSDKDownloadURL stringByAppendingString:
                       [[ALUtility backBarButtonArrowResource]
                        isEqualToString:PDResourceIconBlackArrow]?BBLiveSDKDownloadIconBack:BBLiveSDKDownloadIconBackWhite];
      [imageView setImageWithURL:url placeholderImage:nil
                         options:ALWebImageRetryFailed
                       retryTime:ALImageDownloadRetryTime
                      wifiString:@"" noneWifiString:@""];
    }
#endif
    imageView.frame = rect;
    [view addSubview:imageView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    tapGesture.numberOfTouchesRequired = 1;
    [view addGestureRecognizer:tapGesture];
    
    bbtn = [[UIBarButtonItem alloc] initWithCustomView:view];
    return bbtn;
    
  }
}

+ (UIBarButtonItem*)loadRightBarButtonItemWithImage:(NSString*)imageName rect:(CGRect)rect target:(id)target action:(SEL)action{
  if (isRunningOnIOS11) {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamedNoCache:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                             style:UIBarButtonItemStylePlain
                                                            target:target
                                                            action:action];
    item.imageInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    return item;
  }else{
    UIBarButtonItem *bbtn;
#ifndef BBSDKMODE
#else
    if ([BBLiveSDKUtility isBaiduVideoSDK]) {
      rect.origin.x-=10;
    }
#endif
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamedNoCache:imageName]];
    imageView.frame = rect;
    [view addSubview:imageView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    tapGesture.numberOfTouchesRequired = 1;
    [view addGestureRecognizer:tapGesture];
    view.userInteractionEnabled = YES;
    
    bbtn = [[UIBarButtonItem alloc] initWithCustomView:view];
    return bbtn;
  }
}
@end

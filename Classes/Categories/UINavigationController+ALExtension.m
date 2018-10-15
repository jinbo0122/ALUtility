//
//  UINavigationController+Animation.m
//  pandora
//
//  Created by Albert Lee on 2/14/14.
//  Copyright (c) 2014 Albert Lee. All rights reserved.
//

#import "UINavigationController+ALExtension.h"

@implementation UINavigationController (ALExtension)
- (void)pushViewControllerWithCustomAnimation: (UIViewController*)controller{
  controller.hidesBottomBarWhenPushed = YES;
  [self pushViewController:controller animated:YES];
}

- (UIViewController*)popViewControllerCustomAnimation {
  UIViewController* poppedController = [self popViewControllerAnimated:YES];
  return poppedController;
}

- (void)pushAnimationDidStop {
}
@end

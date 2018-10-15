//
//  UINavigationController+Animation.h
//  pandora
//
//  Created by Albert Lee on 2/14/14.
//  Copyright (c) 2014 Albert Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (ALExtension)
- (void)pushViewControllerWithCustomAnimation:(UIViewController  *)controller;
- (UIViewController*)popViewControllerCustomAnimation;
@end

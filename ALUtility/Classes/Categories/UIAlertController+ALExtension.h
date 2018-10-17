//
//  UIAlertController+YDUtility.h
//  XSB
//
//  Created by Albert Lee on 02/03/2018.
//  Copyright © 2018 Baobao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface UIAlertController (ALUtility)

- (void)show;
- (void)show:(BOOL)animated;

@end

@interface UIAlertController (Private)

@property (nonatomic, strong) UIWindow *alertWindow;

@end

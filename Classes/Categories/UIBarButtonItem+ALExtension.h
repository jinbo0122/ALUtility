//
//  UIBarButtonItem+ALExtension.h
//  ALExtension
//
//  Created by Albert Lee on 4/7/15.
//  Copyright (c) 2015 Albert Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (ALExtension)
#pragma mark Navigation Item

+ (NSArray *)loadBarButtonItemWithTitle:(NSString*)title color:(UIColor*)textColor
                                   font:(UIFont*)font target:(id)target action:(SEL)action
                                 offset:(CGFloat)offset;
+ (UIBarButtonItem*)loadBarButtonItemWithImage:(NSString*)imageName rect:(CGRect)rect arget:(id)target action:(SEL)action;
+ (UIBarButtonItem*)loadRightBarButtonItemWithImage:(NSString*)imageName
                                               rect:(CGRect)rect target:(id)target action:(SEL)action;
@end

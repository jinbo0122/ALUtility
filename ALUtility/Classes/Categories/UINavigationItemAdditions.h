//
//  UINavigationItemAdditions.h
//  unicorn
//
//  Created by weiwang on 13-12-15.
//  Copyright (c) 2013年 weiwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UINavigationItem (Additions)
- (void)addLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem;
- (void)addRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem;
- (void)addLeftBarButtonItems:(NSArray *)leftBarButtonItems;
- (void)addRightBarButtonItems:(NSArray *)rightBarButtonItems;

- (void)updateLeftBarButtonItem:(UIBarButtonItem *)item;
@end

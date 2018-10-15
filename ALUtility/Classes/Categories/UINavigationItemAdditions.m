//
//  UINavigationItemAdditions.m
//  unicorn
//
//  Created by weiwang on 13-12-15.
//  Copyright (c) 2013年 weiwang. All rights reserved.
//

#import "UINavigationItemAdditions.h"
#import "NSArray+ALExtension.h"
@implementation UINavigationItem (Additions)

- (void)updateLeftBarButtonItem:(UIBarButtonItem *)item{
  [self setLeftBarButtonItems:nil];
  [self setLeftBarButtonItem:item];
}

- (void)addLeftBarButtonItems:(NSArray *)leftBarButtonItems{
  UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                  target:nil action:nil];
  negativeSpacer.width = -10;
  NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:5];
  [array safeAddObject:negativeSpacer];
  [array addObjectsFromArray:leftBarButtonItems];
  
  [self setLeftBarButtonItems:array];
}

- (CGFloat)spaceOffsetForLeftButton{
  return -20;
}

- (CGFloat)spaceOffsetForRightButton{
  return -14;
}

- (void)addRightBarButtonItems:(NSArray *)rightBarButtonItems{
  UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                     target:nil action:nil];
  negativeSpacer.width = [self spaceOffsetForRightButton];
  NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:5];
  [array safeAddObject:negativeSpacer];
  [array addObjectsFromArray:rightBarButtonItems];
  
  [self setRightBarButtonItems:array];
}

- (void)addLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem{
  UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                  target:nil action:nil];
  negativeSpacer.width = [self spaceOffsetForLeftButton];
  [self setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, leftBarButtonItem, nil]];
}

- (void)addRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem{
  self.rightBarButtonItem = rightBarButtonItem;
}

@end

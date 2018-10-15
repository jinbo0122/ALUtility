//
//  UIView+SubView.m
//  pandora
//
//  Created by zhongbin on 2017/6/16.
//  Copyright © 2017年 Albert Lee. All rights reserved.
//

#import "UIView+SubView.h"

@implementation UIView (SubView)

- (UIView *)subViewOfClassName:(NSString *)className{

  for (UIView* subView in self.subviews) {
    if ([NSStringFromClass(subView.class) isEqualToString:className]) {
      return subView;
    }
    UIView* resultFound = [subView subViewOfClassName:className];
    if (resultFound) {
      return resultFound;
    }
  }
  return nil;
  
}

@end

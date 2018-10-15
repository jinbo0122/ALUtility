//
//  ALReceiveHitTestSubView.m
//  ALExtension
//
//  Created by Albert Lee on 3/24/15.
//  Copyright (c) 2015 Albert Lee. All rights reserved.
//

#import "ALReceiveHitTestSubView.h"

@implementation ALReceiveHitTestSubView
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
  if (!self.clipsToBounds && !self.hidden && self.alpha > 0) {
    for (UIView *subview in self.subviews.reverseObjectEnumerator) {
      CGPoint subPoint = [subview convertPoint:point fromView:self];
      UIView *result = [subview hitTest:subPoint withEvent:event];
      if (result != nil) {
        return result;
      }
    }
  }
  
  return nil;
}
@end

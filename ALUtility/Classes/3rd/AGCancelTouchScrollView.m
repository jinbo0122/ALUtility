//
//  ALCancelTouchScrollView.m
//  ALExtension
//
//  Created by Albert Lee on 10/9/14.
//  Copyright (c) 2014 Albert Lee. All rights reserved.
//

#import "AGCancelTouchScrollView.h"
#import "AGEmojiPageView.h"
@implementation AGCancelTouchScrollView
- (BOOL)touchesShouldCancelInContentView:(UIView *)view{
  if ( [view isKindOfClass:[UIButton class]] ||
      [view isKindOfClass:[AGEmojiPageView class]]||
      [view isKindOfClass:[UISegmentedControl class]]) {
    return YES;
  }
  
  return [super touchesShouldCancelInContentView:view];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

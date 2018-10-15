//
//  UISegmentedControl+ALExtension.m
//  ALExtension
//
//  Created by Albert Lee on 4/11/15.
//  Copyright (c) 2015 Albert Lee. All rights reserved.
//

#import "UISegmentedControl+ALExtension.h"

@implementation UISegmentedControl (ALExtension)
- (void)setSegmentsWithStringArray:(NSArray *)segments
{
  while (self.numberOfSegments > 0) {
    [self removeSegmentAtIndex:0 animated:NO];
  }
  
  for (NSString *segment in segments) {
    [self insertSegmentWithTitle:segment atIndex:self.numberOfSegments animated:NO];
  }
}

- (void)setSegmentsWithImageArray:(NSArray *)segments
{
  while (self.numberOfSegments > 0) {
    [self removeSegmentAtIndex:0 animated:NO];
  }
  
  for (UIImage *image in segments) {
    [self insertSegmentWithImage:image atIndex:self.numberOfSegments animated:NO];
  }
}
@end

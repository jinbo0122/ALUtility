//
//  ALLineView.m
//  ALExtension
//
//  Created by Albert Lee on 10/9/15.
//  Copyright © 2015 Albert Lee. All rights reserved.
//

#import "ALLineView.h"

@implementation ALLineView

+ (ALLineView *)lineWithFrame:(CGRect)frame colorHex:(UInt32)colorHex{
  ALLineView *line = [[ALLineView alloc] initWithFrame:frame];
  line.backgroundColor = [UIColor colorWithRGBHex:colorHex];
  return line;
}

+ (ALLineView *)lineWithFrame:(CGRect)frame colorHex:(UInt32)colorHex alpha:(CGFloat)alpha{
  ALLineView *line = [[ALLineView alloc] initWithFrame:frame];
  line.backgroundColor = [UIColor colorWithRGBHex:colorHex alpha:alpha];
  return line;
}

@end

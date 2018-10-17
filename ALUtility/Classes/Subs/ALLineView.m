//
//  ALLineView.m
//  ALExtension
//
//  Created by Albert Lee on 10/9/15.
//  Copyright © 2015 Albert Lee. All rights reserved.
//

#import "ALLineView.h"
@interface ALLineView()
@property(nonatomic, strong)CAShapeLayer *maskLayer;
@property(nonatomic, assign)CGFloat       layerRadius;
@end

@implementation ALLineView
+ (ALLineView *)lineWithFrame:(CGRect)frame colorHex:(UInt32)colorHex{
  ALLineView *line = [[ALLineView alloc] initWithFrame:frame];
  line.backgroundColor = [UIColor colorWithRGBHex:colorHex];
  return line;
}

+ (ALLineView *)lineWithFrame:(CGRect)frame colorHex:(UInt32)colorHex cornerRadius:(CGFloat)cornerRadius{
  ALLineView *line = [[ALLineView alloc] initWithFrame:frame];
  line.backgroundColor = [UIColor colorWithRGBHex:colorHex];
  line.layer.masksToBounds = YES;
  line.layer.cornerRadius = cornerRadius;
  return line;
}

+ (ALLineView *)lineWithFrame:(CGRect)frame colorHex:(UInt32)colorHex alpha:(CGFloat)alpha{
  ALLineView *line = [[ALLineView alloc] initWithFrame:frame];
  line.backgroundColor = [UIColor colorWithRGBHex:colorHex alpha:alpha];
  return line;
}

+ (ALLineView *)lineWithFrame:(CGRect)frame colorHex:(UInt32)colorHex alpha:(CGFloat)alpha cornerRadius:(CGFloat)cornerRadius{
  ALLineView *line = [[ALLineView alloc] initWithFrame:frame];
  line.backgroundColor = [UIColor colorWithRGBHex:colorHex alpha:alpha];
  line.layer.masksToBounds = YES;
  line.layer.cornerRadius = cornerRadius;
  return line;
}

+ (ALLineView *)lineWithFrame:(CGRect)frame colorHex:(UInt32)colorHex layerRadius:(CGFloat)layerRadius{
  ALLineView *line = [[ALLineView alloc] initWithFrame:frame];
  line.backgroundColor = [UIColor colorWithRGBHex:colorHex];
  line.layer.masksToBounds = YES;
  UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:line.bounds
                                                 byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                                       cornerRadii:CGSizeMake(layerRadius, layerRadius)];
  line.maskLayer = [[CAShapeLayer alloc] init];
  line.maskLayer.frame = line.bounds;
  line.maskLayer.path = maskPath.CGPath;
  line.maskLayer.fillColor = [[UIColor colorWithRGBHex:colorHex] CGColor];
  line.layer.mask = line.maskLayer;
  line.layerRadius = layerRadius;
  return line;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor{
  [super setBackgroundColor:backgroundColor];
  if (_maskLayer && _layerRadius) {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                                         cornerRadii:CGSizeMake(_layerRadius, _layerRadius)];
    _maskLayer = [[CAShapeLayer alloc] init];
    _maskLayer.frame = self.bounds;
    _maskLayer.path = maskPath.CGPath;
    _maskLayer.fillColor = [[backgroundColor copy] CGColor];
    self.layer.mask = _maskLayer;
  }
}
@end

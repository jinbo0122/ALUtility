//
//  KKTitleLabel.m
//  KKShopping
//
//  Created by Albert Lee on 10/14/13.
//  Copyright (c) 2013 KiDulty. All rights reserved.
//

#import "ALTitleLabel.h"
#import "UILabel+ALExtension.h"
@implementation ALTitleLabel

- (id)initWithTitle:(NSString *)titleText color:(UIColor*)color{
  self = (ALTitleLabel *)[UILabel initWithFrame:CGRectZero
                                        bgColor:[UIColor clearColor]
                                      textColor:color
                                           text:titleText
                                  textAlignment:NSTextAlignmentCenter
                                           font:[UIFont boldSystemFontOfSize:18]];
  if (self) {
    [self sizeToFit];
  }
  return self;
}

- (id)initWithTitle:(NSString *)titleText color:(UIColor *)color fontSize:(CGFloat)fontSize{
  self = (ALTitleLabel *)[UILabel initWithFrame:CGRectZero
                                        bgColor:[UIColor clearColor]
                                      textColor:color
                                           text:titleText
                                  textAlignment:NSTextAlignmentCenter
                                           font:[UIFont systemFontOfSize:fontSize]];
  if (self) {
    [self sizeToFit];
  }
  return self;
}

- (id)initWithTitle:(NSString *)titleText color:(UIColor *)color boldFontSize:(CGFloat)fontSize{
  self = (ALTitleLabel *)[UILabel initWithFrame:CGRectZero
                                        bgColor:[UIColor clearColor]
                                      textColor:color
                                           text:titleText
                                  textAlignment:NSTextAlignmentCenter
                                           font:[UIFont boldSystemFontOfSize:fontSize]];
  if (self) {
    [self sizeToFit];
  }
  return self;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end

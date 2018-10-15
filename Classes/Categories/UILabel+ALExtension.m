//
//  UILabel+ALExtension.m
//  ALExtension
//
//  Created by Albert Lee on 8/28/14.
//  Copyright (c) 2014 Albert Lee. All rights reserved.
//

#import "UILabel+ALExtension.h"

@implementation UILabel (ALExtension)
+ (UILabel *)initWithFrame:(CGRect)frame
                   bgColor:(UIColor *)bgColor
                 textColor:(UIColor *)textColor
                      text:(NSString *)text
             textAlignment:(NSTextAlignment)alignment
                      font:(UIFont *)font{
  UILabel *label = [[UILabel alloc] initWithFrame:frame];
  label.backgroundColor = bgColor;
  label.text = text;
  label.textColor = textColor;
  label.textAlignment = alignment;
  label.font = font;
  return label;
}

+ (UILabel *)initWithFrame:(CGRect)frame
                   bgColor:(UIColor *)bgColor
                 textColor:(UIColor *)textColor
                      text:(NSString *)text
             textAlignment:(NSTextAlignment)alignment
                      font:(UIFont *)font
             numberOfLines:(NSInteger)numberOfLines{
  UILabel *label = [[UILabel alloc] initWithFrame:frame];
  label.backgroundColor = bgColor;
  label.text = text;
  label.textColor = textColor;
  label.textAlignment = alignment;
  label.font = font;
  label.numberOfLines = numberOfLines;
  return label;
}

+ (UILabel *)titleLabel:(NSString *)titleText color:(UIColor*)color{
  UILabel *label = [UILabel initWithFrame:CGRectZero
                                  bgColor:[UIColor clearColor]
                                textColor:color
                                     text:titleText
                            textAlignment:NSTextAlignmentCenter
                                     font:[UIFont boldSystemFontOfSize:18] numberOfLines:1];
  [label sizeToFit];
  return label;
}

- (void)setFrame:(CGRect)frame
         bgColor:(UIColor *)bgColor
       textColor:(UIColor *)textColor
            text:(NSString *)text
   textAlignment:(NSTextAlignment)alignment
            font:(UIFont *)font
   numberOfLines:(NSInteger)numberOfLines{
  self.frame = frame;
  self.backgroundColor = bgColor;
  self.text = text;
  self.textColor = textColor;
  self.textAlignment = alignment;
  self.font = font;
  self.numberOfLines = numberOfLines;
}


@end

//
//  ALAutoScrollLabel.m
//  Avalon
//
//  Created by Albert Lee on 16/05/2017.
//  Copyright © 2017 Baobao. All rights reserved.
//

#import "ALAutoScrollLabel.h"
#import <QuartzCore/QuartzCore.h>

@implementation ALAutoScrollLabel

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    self.clipsToBounds = YES;
    self.autoresizesSubviews = YES;
    
    _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width,   frame.size.height)];
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.textColor = [UIColor blackColor];
    _textLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_textLabel];
  }
  return self;
}

- (void)setText:(NSString *)text{
  _text = text;
  _textLabel.text  = text;
  CGSize textSize = [text sizeWithAttributes:@{NSFontAttributeName:_textLabel.font}];
  
  if(textSize.width > self.frame.size.width) {
    _textLabel.frame = CGRectMake(0, 0, textSize.width, self.frame.size.height);
  }
  else {
    _textLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
  }
  
  if(_textLabel.frame.size.width > self.frame.size.width) {
    [_timer invalidate];
    _timer = nil;
    CGRect frame = _textLabel.frame;
    frame.origin.x = self.frame.size.width-50;
    _textLabel.frame = frame;
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.15 target:self selector:@selector(moveText) userInfo:nil repeats:YES];
  }
  else {
    [_timer invalidate];
    _timer = nil;
  }
}

-(void)moveText {
  if(_textLabel.frame.origin.x < _textLabel.frame.size.width-2*_textLabel.frame.size.width) {
    CGRect frame = _textLabel.frame;
    frame.origin.x = self.frame.size.width;
    _textLabel.frame = frame;
  }
  [UIView beginAnimations:nil context:nil];
  CGRect frame = _textLabel.frame;
  frame.origin.x -= 5;
  _textLabel.frame = frame;
  [UIView commitAnimations];
}

- (void)setFont:(UIFont *)font{
  _font = font;
  _textLabel.font = font;
}

- (void)setTextColor:(UIColor *)textColor{
  _textColor = textColor;
  _textLabel.textColor = textColor;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment{
  _textAlignment = textAlignment;
  _textLabel.textAlignment = textAlignment;
}

- (void)stopTimer{
  [_timer invalidate];
  _timer = nil;
}

- (void)dealloc{
  [self stopTimer];
}
@end

//
//  ALBaseTitleView.m
//  pandora
//
//  Created by lixin on 15/3/10.
//  Copyright (c) 2015年 Albert Lee. All rights reserved.
//

#import "ALBaseTitleView.h"
#import "UIView+ALExtension.h"
#import "UILabel+ALExtension.h"
@interface ALBaseTitleView()
@property(nonatomic, strong)UILabel *lblTitle;
@property(nonatomic, strong)UIImageView *iconMore;
@end

@implementation ALBaseTitleView

- (id)init
{
  self = [super init];
  if (self) {
    // Initialization code
    self.lblTitle = [UILabel initWithFrame:CGRectMake(1, 0, 90, 14)
                                   bgColor:[UIColor clearColor]
                                 textColor:[UIColor whiteColor]
                                      text:@""
                             textAlignment:NSTextAlignmentLeft
                                      font:[UIFont systemFontOfSize:14] numberOfLines:1];
    [self addSubview:self.lblTitle];
    
    self.iconMore = [[UIImageView alloc] initWithFrame:CGRectMake(self.lblTitle.right+5, 5, 12, 7)];
    [self addSubview:self.iconMore];
    
    self.frame = CGRectMake(0, 0, self.iconMore.right, 14);
    
    self.titleGesture = [[UITapGestureRecognizer alloc] init];
    [self addGestureRecognizer:self.titleGesture];
  }
  return self;
}

- (void) setTitleContent:(NSString*)title icon:(NSString*)imgName{
  if (title != nil) {
    self.lblTitle.text = title;
  }
  if (imgName != nil) {
    self.iconMore.image = [UIImage imageNamed:imgName];
  }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

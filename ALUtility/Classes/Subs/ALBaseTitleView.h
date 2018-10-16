//
//  ALBaseTitleView.h
//  pandora
//
//  Created by lixin on 15/3/10.
//  Copyright (c) 2015年 Albert Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ALBaseTitleView : UIView
@property(nonatomic, strong)UITapGestureRecognizer *titleGesture;
- (void)setTitleContent:(NSString*)title icon:(NSString*)imgName;
@end

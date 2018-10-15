//
//  ALAutoScrollLabel.h
//  Avalon
//
//  Created by Albert Lee on 16/05/2017.
//  Copyright © 2017 Baobao. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ALAutoScrollLabel : UIView {
  UILabel *_textLabel;
  NSTimer *_timer;
}
@property(nonatomic, strong)NSString *text;
@property(nonatomic, strong)UIFont   *font;
@property(nonatomic, strong)UIColor  *textColor;
@property(nonatomic, assign)NSTextAlignment textAlignment;

- (void)stopTimer;
@end

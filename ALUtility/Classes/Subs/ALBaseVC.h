//
//  KKBaseViewController.h
//  KKShopping
//
//  Created by andaji on 13-8-13.
//  Copyright (c) 2013年 KiDulty. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ALBaseVC:UIViewController
@property(nonatomic, strong)UISwipeGestureRecognizer *swipeGesture;
- (void)onBackBarBtnClick;
@end

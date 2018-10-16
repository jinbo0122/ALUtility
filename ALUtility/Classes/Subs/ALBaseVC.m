//
//  KKBaseViewController.m
//  KKShopping
//
//  Created by andaji on 13-8-13.
//  Copyright (c) 2013年 KiDulty. All rights reserved.
//

#import "ALBaseVC.h"
#import "UINavigationController+ALExtension.h"
@implementation ALBaseVC
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.navigationItem.backBarButtonItem = nil;
  self.navigationItem.title = @" ";
  self.view.backgroundColor = [UIColor whiteColor];
  _swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onBackBarBtnClick)];
  [_swipeGesture setDirection:UISwipeGestureRecognizerDirectionRight];
  [_swipeGesture setNumberOfTouchesRequired:1];
  [self.view addGestureRecognizer:_swipeGesture];
  _swipeGesture.enabled = NO;
}

- (BOOL)shouldAutorotate{
  return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
  return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)onBackBarBtnClick
{
  [self.navigationController popViewControllerCustomAnimation];
}
@end

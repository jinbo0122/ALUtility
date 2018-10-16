//
//  ALWebVC.m
//  StudentLoan
//
//  Created by Albert Lee on 2/22/16.
//  Copyright © 2016 Albert Lee. All rights reserved.
//

#import "ALWebVC.h"
#import "UIBarButtonItem+ALExtension.h"
#import "UIColor+ALExtension.h"
#import "ALUtility.h"
#import "ALTitleLabel.h"
@interface ALWebVC()<UIWebViewDelegate>
@end

@implementation ALWebVC
- (void)viewDidLoad{
  [super viewDidLoad];
  
  _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
  _webView.backgroundColor = [UIColor whiteColor];
  [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
  
  [self.view addSubview:_webView];
  _webView.delegate = self;
  _webView.scalesPageToFit = YES;
  _webView.allowsInlineMediaPlayback = YES;
  
  if (_isModal) {
    UIBarButtonItem *leftBtn = [UIBarButtonItem loadBarButtonItemWithImage:ALBackBarButtonArrowResource
                                                                      rect:ALBackBarButtonArrowRect
                                                                     arget:self action:@selector(onDismiss)];
    self.navigationItem.leftBarButtonItems = nil;
    self.navigationItem.leftBarButtonItem = leftBtn;
  }else{
    self.navigationItem.leftBarButtonItems = nil;
  }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
  NSString *title=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
  __weak typeof(self)wSelf = self;
  if ([[wSelf.navigationController.viewControllers lastObject] isEqual:wSelf]) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      if ([[wSelf.navigationController.viewControllers lastObject] isEqual:wSelf]) {
        wSelf.navigationItem.titleView = [[ALTitleLabel alloc] initWithTitle:title
                                                                       color:[UIColor colorWithRGBHex:0x262626]];
      }
    });
  }
  
  if ([webView canGoBack]) {
    UIBarButtonItem *leftBtn = [UIBarButtonItem loadBarButtonItemWithImage:ALBackBarButtonArrowResource
                                                                      rect:ALBackBarButtonArrowRect
                                                                     arget:self
                                                                    action:@selector(goBack)];
    UIBarButtonItem *closeBtn = [UIBarButtonItem loadBarButtonItemWithImage:@"icon-close"
                                                                       rect:CGRectMake(-15, 13, 18, 18)
                                                                      arget:self
                                                                     action:@selector(onDismiss)];
    self.navigationItem.leftBarButtonItems = @[leftBtn,closeBtn];
  }else{
    if (_isModal) {
      UIBarButtonItem *leftBtn = [UIBarButtonItem loadBarButtonItemWithImage:ALBackBarButtonArrowResource
                                                                        rect:ALBackBarButtonArrowRect
                                                                       arget:self action:@selector(onDismiss)];
      self.navigationItem.leftBarButtonItems = nil;
      self.navigationItem.leftBarButtonItem = leftBtn;
    }else{
      self.navigationItem.leftBarButtonItems = nil;
    }
  }
}

- (void)onDismiss{
  if (_isModal) {
    [self dismissViewControllerAnimated:YES completion:nil];
  }else{
    [self onBackBarBtnClick];
  }
}

- (void)goBack{
  [_webView goBack];
}
@end

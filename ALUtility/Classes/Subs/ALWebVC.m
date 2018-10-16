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
@interface ALWebVC()<WKNavigationDelegate,WKUIDelegate>
@end

@implementation ALWebVC
- (void)viewDidLoad{
  [super viewDidLoad];
  
  NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
  
  WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
  WKUserContentController *wkUController = [[WKUserContentController alloc] init];
  [wkUController addUserScript:wkUScript];
  
  WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
  wkWebConfig.userContentController = wkUController;
  wkWebConfig.allowsInlineMediaPlayback = YES;
  _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:wkWebConfig];
  _webView.backgroundColor = [UIColor whiteColor];
  [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
  [self.view addSubview:_webView];
  _webView.navigationDelegate = self;
  _webView.UIDelegate = self;
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

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
  __weak typeof(self)wSelf = self;
  [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable title, NSError * _Nullable error) {
    if ([[wSelf.navigationController.viewControllers lastObject] isEqual:wSelf]) {
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([[wSelf.navigationController.viewControllers lastObject] isEqual:wSelf]) {
          wSelf.navigationItem.titleView = [[ALTitleLabel alloc] initWithTitle:title
                                                                         color:[UIColor colorWithRGBHex:0x262626]];
        }
      });
    }
  }];
  
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

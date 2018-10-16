//
//  ALWebVC.h
//  StudentLoan
//
//  Created by Albert Lee on 2/22/16.
//  Copyright © 2016 Albert Lee. All rights reserved.
//

#import "ALBaseVC.h"
#import <WebKit/WebKit.h>
@interface ALWebVC : ALBaseVC
@property (nonatomic, strong)NSString   *url;
@property (nonatomic, strong)NSString   *titleTxt;
@property (nonatomic, strong)WKWebView  *webView;
@property (nonatomic, assign)BOOL isModal;
@end

//
//  ALNavigationController.m
//  pandora
//
//  Created by Albert Lee on 2/24/14.
//  Copyright (c) 2014 Albert Lee. All rights reserved.
//

#import "ALNavigationController.h"
@interface ALNavigationController ()

@end

@implementation ALNavigationController

- (id)init {
  self = [super initWithNavigationBarClass:[UINavigationBar class] toolbarClass:nil];
  if(self) {
    // Custom initialization here, if needed.
  }
  return self;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController {
  self = [super initWithNavigationBarClass:[UINavigationBar class] toolbarClass:nil];
  if(self) {
    self.viewControllers = @[rootViewController];
  }
  
  return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

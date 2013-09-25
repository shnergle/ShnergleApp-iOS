//
//  CustomSlidingViewController.m
//  ShnergleApp
//
//  Created by Adam Hani Schakaki on 09/06/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "CustomSlidingViewController.h"
#import "MenuViewController.h"

@implementation CustomSlidingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shouldAllowPanningPastAnchor = NO;
    self.anchorRightRevealAmount = 230;
    self.anchorLeftRevealAmount = NSIntegerMax;
    self.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:self.mainController];
    if (![self.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"AroundMeMenu"];
    }
    [self.topViewController.view addGestureRecognizer:self.panGesture];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

@end

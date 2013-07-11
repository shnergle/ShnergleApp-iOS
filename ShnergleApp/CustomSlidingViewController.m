//
//  CustomSlidingViewController.m
//  ShnergleApp
//
//  Created by Adam Hani Schakaki on 09/06/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "CustomSlidingViewController.h"

@implementation CustomSlidingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:_mainController];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)resetTopViewWithAnimations:(void (^)())animations onComplete:(void (^)())complete {
    [super resetTopViewWithAnimations:animations onComplete:complete];
    @try {
        [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:233.0 / 255 green:235.0 / 255 blue:240.0 / 255 alpha:1.0]];
    } @catch (NSException *exception) {
    }
    [[UINavigationBar appearance] setBackgroundColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:1.0]]; //ios 7
}

@end

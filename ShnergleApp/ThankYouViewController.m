//
//  ThankYouViewController.m
//  ShnergleApp
//
//  Created by Stian Johansen on 12/09/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "ThankYouViewController.h"
#import "CustomSlidingViewController.h"

@implementation ThankYouViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.passcodeLabel.hidden = shouldHidePasscode;
    self.passcodeInfoLabel.hidden = shouldHidePasscode;
    self.passcodeInfoLabel.text = passcodeInfoString;
    self.passcodeLabel.text = passcodeString;
    self.pointsLabel.text = pointsString;
    self.navigationController.navigationBarHidden = YES;
}

- (void)setupFields:(NSString *)points :(NSString *)msg :(NSString *)passcode {
    pointsString = points;
    if ([msg length] > 0) {
        passcodeString = msg;
        passcodeInfoString = passcode;
        shouldHidePasscode = NO;
    } else {
        shouldHidePasscode = YES;
    }
}

- (IBAction)tappedDone:(id)sender {
    for (id viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[CustomSlidingViewController class]]) {
            [self.navigationController popToViewController:viewController animated:YES];
            return;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

@end

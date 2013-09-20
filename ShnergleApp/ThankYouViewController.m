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
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)setupFields:(NSString *)points :(NSString *)msg :(NSString *)passcode{
    pointsString = points;
    if ([msg length] > 0) {
        passcodeString = msg;
        passcodeInfoString = passcode;
    } else {
        shouldHidePasscode = YES;
    }
}

- (IBAction)tappedDone:(id)sender {
    [self toFirstAroundMe];
}

- (void)toFirstAroundMe {
    for (id viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[CustomSlidingViewController class]]) {
            [self.navigationController popToViewController:viewController animated:YES];
            return;
        }
    }
}

@end

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
    self.passcodeLabel.text = passcodeString;
    self.pointsLabel.text = pointsString;
}

- (void)setupFields:(NSString *)points :(NSString *)passcode {
    self.pointsLabel.text = points;
    if ([passcode length] > 0) {
        passcodeString = passcode;
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

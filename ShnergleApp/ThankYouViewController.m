//
//  ThankYouViewController.m
//  ShnergleApp
//
//  Created by Stian Johansen on 12/09/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "ThankYouViewController.h"
#import "CustomSlidingViewController.h"

@interface ThankYouViewController ()

@end

@implementation ThankYouViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setupFields:(NSString *)points :(NSString *)passcode
{
    self.pointsLabel.text = points;
    if([passcode length] > 0)
    {
        self.passcodeLabel.text = passcode;
    }else{
        self.passcodeInfoLabel.hidden = YES;
        self.passcodeLabel.hidden = YES;
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

//
//  ThankYouViewController.h
//  ShnergleApp
//
//  Created by Stian Johansen on 12/09/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomBackViewController.h"

@interface ThankYouViewController : CustomBackViewController
{
    NSString *pointsString;
    NSString *passcodeString;
    BOOL shouldHidePasscode;
}
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *passcodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *passcodeInfoLabel;
- (IBAction)tappedDone:(id)sender;
- (void)setupFields:(NSString *)points :(NSString *)passcode;
@end

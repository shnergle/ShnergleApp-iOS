//
//  ThankYouViewController.h
//  ShnergleApp
//
//  Created by Stian Johansen on 12/09/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

@interface ThankYouViewController : UIViewController
{
    NSString *pointsString;
    NSString *passcodeString;
    NSString *passcodeInfoString;
    BOOL shouldHidePasscode;
    BOOL shouldHidePoints;
}
@property (weak, nonatomic) IBOutlet UILabel *beforeInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *passcodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *passcodeInfoLabel;

- (void)setupFields:(NSString *)points :(NSString *)msg :(NSString *)passcode;
@end

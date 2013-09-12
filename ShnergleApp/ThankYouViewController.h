//
//  ThankYouViewController.h
//  ShnergleApp
//
//  Created by Stian Johansen on 12/09/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThankYouViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *passcodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *passcodeInfoLabel;
- (IBAction)tappedDone:(id)sender;

@end

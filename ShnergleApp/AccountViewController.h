//
//  AccountViewController.h
//  ShnergleApp
//
//  Created by Harshita Balaga on 12/08/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "CustomBackViewController.h"

@interface AccountViewController : CustomBackViewController <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UISwitch *optInSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *twitterSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *saveLocallySwitch;

@end

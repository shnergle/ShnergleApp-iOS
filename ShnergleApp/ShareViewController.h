//
//  ShareViewController.h
//  ShnergleApp
//
//  Created by Adam Hani Schakaki on 04/06/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "CustomBackViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface ShareViewController : CustomBackViewController <FBViewControllerDelegate, UITextViewDelegate, UIAlertViewDelegate, UITextFieldDelegate> {
    id selectedFriends;
    NSString *post_id;
}

@property (weak, nonatomic) IBOutlet UISwitch *fbSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *twSwitch;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIButton *nameList;
@property (weak, nonatomic) IBOutlet UILabel *friendLabel;
@property (weak, nonatomic) IBOutlet UITextView *textFieldname;
@property (weak, nonatomic) IBOutlet UILabel *counter;

@end

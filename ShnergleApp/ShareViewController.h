//
//  ShareViewController.h
//  ShnergleApp
//
//  Created by Adam Hani Schakaki on 04/06/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "GCPlaceholderTextView.h"
#import "CustomBackViewController.h"
#import <Toast+UIView.h>

@interface ShareViewController : CustomBackViewController <FBViewControllerDelegate, UITextViewDelegate> {
    id selectedFriends;
}

@property (nonatomic) bool shnergleThis;
@property (weak, nonatomic) IBOutlet UISwitch *fbSwitch;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIButton *nameList;
@property (weak, nonatomic) IBOutlet UILabel *friendLabel;
@property (weak, nonatomic) IBOutlet UISwitch *saveLocallySwitch;
@property (weak, nonatomic) IBOutlet GCPlaceholderTextView *textFieldname;

@end

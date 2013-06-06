//
//  ShareViewController.h
//  ShnergleApp
//
//  Created by Adam Hani Schakaki on 04/06/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FBViewController.h>
#import "GCPlaceholderTextView.h"


@interface ShareViewController : UIViewController <FBViewControllerDelegate> {
    id selectedFriends;
}
@property (weak, nonatomic) IBOutlet UIButton *nameList;
@property (weak, nonatomic) IBOutlet UILabel *friendLabel;
@property (weak, nonatomic) IBOutlet GCPlaceholderTextView *textFieldname;
//- (IBAction)cleartextfield:(id)sender;
@end

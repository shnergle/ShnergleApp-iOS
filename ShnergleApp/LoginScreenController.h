//
//  LoginScreenController.h
//  ShnergleApp
//
//  Created by Harshita Balaga on 26/04/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import <FacebookSDK/FBLoginView.h>

@interface LoginScreenController : UIViewController <FBLoginViewDelegate> {
    BOOL newUser;
}
@property (weak, nonatomic) IBOutlet UILabel *whyFacebookLabel;
@property (weak, nonatomic) IBOutlet UIButton *whyFacebookInfoButton;

@end

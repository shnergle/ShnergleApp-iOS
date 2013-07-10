//
//  LoginScreenController.h
//  ShnergleApp
//
//  Created by Harshita Balaga on 26/04/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

@interface LoginScreenController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *buttonLoginLogout;

@property (strong, nonatomic) NSMutableData *response;

- (IBAction)buttonClickHandler:(id)sender;
- (void)updateView;

@end

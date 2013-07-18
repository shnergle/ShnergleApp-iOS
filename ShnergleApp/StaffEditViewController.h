//
//  StaffEditViewController.h
//  ShnergleApp
//
//  Created by Adam Hani Schakaki on 12/06/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "CustomBackViewController.h"

@interface StaffEditViewController : CustomBackViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate> {
    UITableViewCell *secondCell;
    NSDictionary *currentStaff;
}
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobTitleLabel;
@property (weak, nonatomic) IBOutlet FBProfilePictureView *profileImage;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

-(void)setStaffMember:(NSDictionary *)staff;
@end

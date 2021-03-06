//
//  StaffEditViewController.m
//  ShnergleApp
//
//  Created by Adam Hani Schakaki on 12/06/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "StaffEditViewController.h"
#import <NSDate+TimeAgo/NSDate+TimeAgo.h>
#import <Toast/Toast+UIView.h>
#import "Request.h"

@implementation StaffEditViewController

- (void)setStaffMember:(NSDictionary *)staff {
    currentStaff = staff;
}

- (IBAction)deleteStaff:(id)sender {
    [[[UIAlertView alloc] initWithTitle:@"Really delete?" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil] show];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    self.nameLabel.text = currentStaff[@"name"];
    self.jobTitleLabel.text = appDelegate.staffType;
    self.profileImage.profileID = currentStaff[@"facebook_id"];
    self.dateLabel.text = [self getDateFromUnixFormat:currentStaff[@"time"]];

    NSString *type = appDelegate.staffType;
    if (type == nil) type = @"Staff";
    secondCell.textLabel.text = [NSString stringWithFormat:@"Status: %@", type];
    if ([@"Manager" isEqualToString : type]) {
        promoSwitch.on = YES;
        promoSwitch.enabled = NO;
    } else {
        promoSwitch.on = [currentStaff[@"promo_perm"] integerValue] == 1;
        promoSwitch.enabled = YES;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"Cell%ld", (long)indexPath.row ]];
    if (indexPath.row == 0) {
        UISwitch *textField = [[UISwitch alloc] initWithFrame:CGRectMake(210, 8, 50, 30)];
        cell.textLabel.text = @"Can create promotions";
        promoSwitch = textField;
        [cell.contentView addSubview:textField];
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"Status: Staff";
        secondCell = cell;
    }
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    secondCell.selected = NO;
}

- (void)goBack {
    [self.view makeToastActivity];
    appDelegate.addVenueType = nil;
    if (deleteMe) {
        NSDictionary *params = @{@"delete": @"true",
                                 @"venue_id": appDelegate.activeVenue[@"id"],
                                 @"staff_user_id": currentStaff[@"user_id"]};
        [Request post:@"venue_staff/set" params:params callback:^(id response) {
            [self didFinishSaving:response];
        }];
        deleteMe = NO;
    } else {
        NSDictionary *params = @{@"venue_id": appDelegate.activeVenue[@"id"],
                                 @"staff_user_id": currentStaff[@"user_id"],
                                 @"manager": [@"Manager" isEqualToString: appDelegate.staffType] ? @"true" : @"false",
                                 @"promo_perm": promoSwitch.on ? @"true" : @"false"};
        [Request post:@"venue_staff/set" params:params callback:^(id response) {
            [self didFinishSaving:response];
        }];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didFinishSaving:(id)response {
    if (response) {
        [self.view hideToastActivity];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        if ([appDelegate.staff[@"managers"] count] > 1) {
            deleteMe = YES;
            [self goBack];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"You cannot remove the last manager." message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }
}

- (NSString *)getDateFromUnixFormat:(id)unixFormat {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[unixFormat integerValue]];
    if ([unixFormat integerValue] < [[NSDate date] timeIntervalSince1970] - 86400 * 8) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterShortStyle;
        dateFormatter.timeStyle = NSDateFormatterShortStyle;
        return [dateFormatter stringFromDate:date];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"ccc H:mm";
    return [date timeAgoWithLimit:86400 dateFormatter:dateFormatter];
}

@end

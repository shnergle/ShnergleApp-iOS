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
#import "PostRequest.h"

@implementation StaffEditViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title = @"Staff";
}
-(void)setStaffMember:(NSDictionary *)staff
{
    currentStaff = staff;
}

- (IBAction)deleteStaff:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Really delete?" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
    [alert show];
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
    NSLog(@"%@",appDelegate.staffType);
    NSLog(@"%@",currentStaff);
    if ([@"Manager" isEqualToString:type]) {
        promoSwitch.on = YES;
        promoSwitch.enabled = NO;
    } else {
        promoSwitch.on = [currentStaff[@"promo_perm"] intValue] == 1;
        promoSwitch.enabled = YES;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"Cell%d", indexPath.row ]];
    if (indexPath.row == 0) {
        UISwitch *textField = [[UISwitch alloc] initWithFrame:CGRectMake(210, 8, 50, 30)];
        [textField addTarget:self action:@selector(canCreatePromo) forControlEvents:UIControlEventAllEvents];
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
        NSString *params = [NSString stringWithFormat:@"delete=true&venue_id=%@&staff_user_id=%@", [appDelegate.activeVenue[@"id"] stringValue], [currentStaff[@"user_id"] stringValue]];
        [[[PostRequest alloc] init] exec:@"venue_staff/set" params:params delegate:self callback:@selector(didFinishSaving:) type:@"string"];
        deleteMe = NO;
    } else {
        NSString *params = [NSString stringWithFormat:@"venue_id=%@&staff_user_id=%@&manager=%@&promo_perm=%@", [appDelegate.activeVenue[@"id"] stringValue], [currentStaff[@"user_id"] stringValue], [@"Manager" isEqualToString:appDelegate.staffType] ? @"true" : @"false", promoSwitch.on ? @"true" : @"false"];
        [[[PostRequest alloc] init] exec:@"venue_staff/set" params:params delegate:self callback:@selector(didFinishSaving:) type:@"string"];
    }
    [super goBack];
}

- (void)didFinishSaving:(id)response {
    if ([@"true" isEqualToString:response]) {
        [self.view hideToastActivity];
        [super goBack];
    }
}

- (void)canCreatePromo {
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        deleteMe = YES;
        [self goBack];
    }
}

- (NSString *)getDateFromUnixFormat:(id)unixFormat {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[unixFormat intValue]];
    return [date timeAgoWithLimit:86400 dateFormat:NSDateFormatterShortStyle andTimeFormat:NSDateFormatterShortStyle];
}

@end

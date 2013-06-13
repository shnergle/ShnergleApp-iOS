//
//  StaffEditViewController.m
//  ShnergleApp
//
//  Created by Adam Hani Schakaki on 12/06/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "AppDelegate.h"
#import "StaffEditViewController.h"

@implementation StaffEditViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title = @"Staff";
}

- (IBAction)deleteStaff:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Really delete?" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
    [alert show];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSString *type = appDelegate.staffType;
    if (type == nil) type = @"Staff";
    secondCell.textLabel.text = [NSString stringWithFormat:@"Status: %@", type];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.addVenueType = nil;
    [super goBack];
}

- (void)canCreatePromo {
    NSLog(@"switch");
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        NSLog(@"delete");
    }
}

@end

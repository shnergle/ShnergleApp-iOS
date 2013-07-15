//
//  VenueDetailsViewController.m
//  ShnergleApp
//
//  Created by Harshita Balaga on 11/06/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "VenueDetailsViewController.h"

@implementation VenueDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Venue Details";

    appDelegate.venueDetailsContent = [[NSMutableArray alloc]init];
    tableData = @[@"Phone", @"Email", @"Website"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setRightBarButton:@"Done" actionSelector:@selector(goBack)];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"Cell%d", indexPath.row ]];
    cell.textLabel.text = tableData[indexPath.row];
    if (indexPath.row == 0) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
        textField.tag = 0;
        textField.placeholder = @"(Required)";
        textField.delegate = self;
        [cell.contentView addSubview:textField];
    } else if (indexPath.row == 1) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
        textField.tag = 1;
        textField.placeholder = @"(Required)";
        textField.delegate = self;

        [cell.contentView addSubview:textField];
    } else if (indexPath.row == 2) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
        textField.tag = 2;
        textField.placeholder = @"(Required)";
        textField.delegate = self;
        [cell.contentView addSubview:textField];
    }
    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    appDelegate.venueDetailsContent[textField.tag] = textField.text;
}

@end

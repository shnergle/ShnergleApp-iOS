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
    self.navigationItem.title = @"Place Details";

    appDelegate.venueDetailsContent = [[NSMutableDictionary alloc] init];
    tableData = @[@"Phone", @"Email", @"Website"];
    textFields = [NSMutableArray arrayWithCapacity:3];

    if (appDelegate.claiming) [self setRightBarButton:@"Done" actionSelector:@selector(checkAndSave:)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)checkAndSave:(id)sender {
    if ([self allFieldsFilledIn]) {
        for (UITextField *textField in textFields) {
            [self textFieldDidEndEditing:textField];
        }
        [super goBack];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please fill in all fields." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (BOOL)allFieldsFilledIn {
    for (UITextField *textField in textFields) {
        if (textField == nil || [textField.text isEqualToString:@""]) return NO;
    }
    return YES;
}

- (void)goBack {
    if (appDelegate.claiming) appDelegate.venueDetailsContent = nil;
    else
        for (UITextField *textField in textFields) {
            [self textFieldDidEndEditing:textField];
        }
    appDelegate.claiming = NO;
    [super goBack];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"Cell%d", indexPath.row ]];
    cell.textLabel.text = tableData[indexPath.row];
    if (indexPath.row == 0) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
        textField.tag = 8;
        textField.placeholder = @"(Required)";
        textField.delegate = self;
        textField.keyboardType = UIKeyboardTypePhonePad;
        [cell.contentView addSubview:textField];
        [textFields addObject:textField];
    } else if (indexPath.row == 1) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
        textField.tag = 9;
        textField.placeholder = @"(Required)";
        textField.delegate = self;
        textField.keyboardType = UIKeyboardTypeEmailAddress;
        [cell.contentView addSubview:textField];
        [textFields addObject:textField];
    } else if (indexPath.row == 2) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
        textField.tag = 10;
        textField.placeholder = @"(Required)";
        textField.delegate = self;
        textField.keyboardType = UIKeyboardTypeURL;
        [cell.contentView addSubview:textField];
        [textFields addObject:textField];
    }
    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    appDelegate.venueDetailsContent[@(textField.tag)] = (textField.text == nil ? @"" : textField.text);
}

@end

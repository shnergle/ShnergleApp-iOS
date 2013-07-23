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
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setRightBarButton:@"Done" actionSelector:@selector(goBack)];
}

-(void)goBack
{
    [super goBack];
    for(UITextField *textField in textFields)
    {
        [self textFieldDidEndEditing:textField];
    }
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

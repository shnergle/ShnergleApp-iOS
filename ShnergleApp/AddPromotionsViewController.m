//
//  AddPromotionsViewController.m
//  ShnergleApp
//
//  Created by Harshita Balaga on 13/06/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "AddPromotionsViewController.h"

@implementation AddPromotionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Promotion";
    [self setRightBarButton:@"Publish" actionSelector:@selector(addVenue)];

    self.tableData = @[@"Title", @"", @"Passcode", @"Starts", @"Ends", @"Limit"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = self.tableData[indexPath.section];
    if (indexPath.section == 0) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
        textField.delegate = self;
        textField.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:textField];
    } else if (indexPath.section == 1) {
        UITextView *textField = [[UITextView alloc] initWithFrame:CGRectMake(10, 35, 280, 100)];
        textField.delegate = self;
        textField.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:textField];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 280, 25)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont fontWithName:cell.textLabel.font.fontName size:label.font.pointSize];
        label.text = @"Promotion Details";
        [cell.contentView addSubview:label];
    } else if (indexPath.section == 2) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
        textField.delegate = self;
        textField.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:textField];
    } else if (indexPath.section == 3) {
        UILabel *textField = [[UILabel alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
        textField.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:textField];
    } else if (indexPath.section == 4) {
        UILabel *textField = [[UILabel alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
        textField.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:textField];
    } else if (indexPath.section == 5) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
        textField.backgroundColor = [UIColor clearColor];
        textField.keyboardType = UIKeyboardTypeNumberPad;
        [cell.contentView addSubview:textField];
    }

    return cell;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3 || indexPath.section == 4) {
        if (self.pickerView.superview == nil) {
            CGRect startFrame = self.pickerView.frame;
            CGRect endFrame = self.pickerView.frame;
            startFrame.origin.y = self.view.frame.size.height;
            endFrame.origin.y = startFrame.origin.y - endFrame.size.height;

            self.pickerView.frame = startFrame;

            [self.view addSubview:self.pickerView];

            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.40];
            self.pickerView.frame = endFrame;
            [UIView commitAnimations];

            publishButton = self.navigationItem.rightBarButtonItem;

            self.navigationItem.rightBarButtonItem = self.doneButton;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    return indexPath.section == 1 ? 140 : cell.bounds.size.height;
}

- (IBAction)doneAction:(id)sender {
    CGRect pickerFrame = self.pickerView.frame;
    pickerFrame.origin.y = self.view.frame.size.height;

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.40];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(slideDownDidStop)];
    self.pickerView.frame = pickerFrame;
    [UIView commitAnimations];
    self.navigationItem.rightBarButtonItem = publishButton;
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)slideDownDidStop {
    [self.pickerView removeFromSuperview];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.tableData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

@end

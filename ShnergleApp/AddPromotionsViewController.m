//
//  AddPromotionsViewController.m
//  ShnergleApp
//
//  Created by Harshita Balaga on 13/06/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "AddPromotionsViewController.h"

@interface AddPromotionsViewController ()

@end

@implementation AddPromotionsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Promotion";
    [self setRightBarButton:@"Publish" actionSelector:@selector(addVenue)];

    _tableData = @[@"Title", @"Promotion Details", @"Passcode", @"Starts", @"Ends", @"Limit"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = _tableData[indexPath.section];
    if (indexPath.section == 0) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
        textField.delegate = self;
        //textField.placeholder = @"(Required)";
        [cell.contentView addSubview:textField];
    } else if (indexPath.section == 1) {
        UITextView *textField = [[UITextView alloc] initWithFrame:CGRectMake(10, 35, 280, 100)];
        textField.delegate = self;
        //textField.placeholder = @"(Required)";
        [cell.contentView addSubview:textField];
    } else if (indexPath.section == 2) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
        textField.delegate = self;
        //textField.placeholder = @"(Required)";
        [cell.contentView addSubview:textField];
    } else if (indexPath.section == 3) {
        UILabel *textField = [[UILabel alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
        //UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped)];
        //tap.delegate = self;
        //[textField addGestureRecognizer:tap];
        //textField.delegate = self;
        //textField.placeholder = @"(Required)";
        [cell.contentView addSubview:textField];
    } else if (indexPath.section == 4) {
        UILabel *textField = [[UILabel alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
        //textField.delegate = self;
        //textField.placeholder = @"(Required)";
        [cell.contentView addSubview:textField];
    } else if (indexPath.section == 5) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
        textField.keyboardType = UIKeyboardTypeNumberPad;
        //textField.delegate = self;
        //textField.placeholder = @"(Required)";
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
        //UITableViewCell *targetCell = [tableView cellForRowAtIndexPath:indexPath];
        //self.pickerView = [self.dateFormatter dateFromString:targetCell.detailTextLabel.text];

        // the date picker migt already be showing, so don't add it to our view
        if (self.pickerView.superview == nil) {
            CGRect startFrame = self.pickerView.frame;
            CGRect endFrame = self.pickerView.frame;

            // the start position is below the bottom of the visible frame
            startFrame.origin.y = self.view.frame.size.height;

            // the end position is slid up by the height of the view
            endFrame.origin.y = startFrame.origin.y - endFrame.size.height;

            self.pickerView.frame = startFrame;

            [self.view addSubview:self.pickerView];

            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.40];
            self.pickerView.frame = endFrame;
            [UIView commitAnimations];

            // add the "Done" button to the nav bar
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
    // remove the "Done" button in the nav bar
    self.navigationItem.rightBarButtonItem = publishButton;

    // deselect the current table row
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)slideDownDidStop {
    // the date picker has finished sliding downwards, so remove it from the view hierarchy
    [self.pickerView removeFromSuperview];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _tableData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

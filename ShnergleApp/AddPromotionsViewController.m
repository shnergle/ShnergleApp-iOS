//
//  AddPromotionsViewController.m
//  ShnergleApp
//
//  Created by Harshita Balaga on 13/06/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "AddPromotionsViewController.h"
#import "PostRequest.h"
#import <Toast+UIView.h>

@implementation AddPromotionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Promotion";
    [self setRightBarButton:@"Publish" actionSelector:@selector(addPromotion)];

    self.tableData = @[@"Title", @"", @"Passcode", @"Starts", @"Ends", @"Limit"];
    textFields = [NSMutableDictionary dictionary];
    pickerValues = [NSMutableDictionary dictionary];
}

-(void)addPromotion
{
    NSMutableString *params = [[NSMutableString alloc]initWithFormat:@"venue_id=%@&title=%@&description=%@&passcode=%@&start=%d&end=%d&maximum=%@",[appDelegate.activeVenue[@"id"] stringValue],((UITextField *)textFields[@0]).text,((UITextField *)textFields[@1]).text,((UITextField *)textFields[@2]).text,(int)[(NSDate *)pickerValues[@3] timeIntervalSince1970],(int)[(NSDate *)pickerValues[@4] timeIntervalSince1970],((UITextField *)textFields[@5]).text];
    if(appDelegate.activePromotion[@"id"] != nil)
    {
        [params appendFormat:@"&promotion_id=%@",[appDelegate.activePromotion[@"id"] stringValue]];
    }
    [self.view makeToastActivity];
    [[[PostRequest alloc]init]exec:@"promotions/set" params:[params stringByReplacingOccurrencesOfString:@"(null)" withString:@"0"] delegate:self callback:@selector(didFinishAddingPromotion:) type:@"string"];
}

-(void)didFinishAddingPromotion:(NSString *)response
{
    [self.view hideToastActivity];
    if([@"true" isEqualToString:response]){
    [self goBack];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = self.tableData[indexPath.section];
    if (indexPath.section == 0) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
        textField.delegate = self;
        textField.backgroundColor = [UIColor clearColor];
        textField.text = appDelegate.activePromotion != nil ? appDelegate.activePromotion[@"title"] : @"";
        textFields[@0] = textField;
        [cell.contentView addSubview:textField];
    } else if (indexPath.section == 1) {
        UITextView *textField = [[UITextView alloc] initWithFrame:CGRectMake(10, 35, 280, 100)];
        textField.delegate = self;
        textField.backgroundColor = [UIColor clearColor];
        textField.text = appDelegate.activePromotion != nil ? appDelegate.activePromotion[@"description"] : @"";
        textFields[@1] = textField;
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
        textField.text = appDelegate.activePromotion != nil ? appDelegate.activePromotion[@"passcode"] : @"";
        textFields[@2] = textField;
        [cell.contentView addSubview:textField];
    } else if (indexPath.section == 3) {
        UILabel *textField = [[UILabel alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
        textField.backgroundColor = [UIColor clearColor];
        if (pickerValues[@(indexPath.section)] == nil)
            if ([@"0" isEqualToString:[appDelegate.activePromotion[@"start"] stringValue]]) {
                textField.text = @"";
            } else
                textField.text = appDelegate.activePromotion != nil ? [NSDateFormatter localizedStringFromDate:[NSDate dateWithTimeIntervalSince1970:[appDelegate.activePromotion[@"start"] intValue]] dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle] : @"";
        else
            textField.text = [NSDateFormatter localizedStringFromDate:pickerValues[@(indexPath.section)] dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
        if ([@"0" isEqualToString:textField.text])
            textField.text = @"";
        textFields[@3] = textField;
        [cell.contentView addSubview:textField];
    } else if (indexPath.section == 4) {
        UILabel *textField = [[UILabel alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
        textField.backgroundColor = [UIColor clearColor];
        if (pickerValues[@(indexPath.section)] == nil)
            if ([@"0" isEqualToString:[appDelegate.activePromotion[@"end"] stringValue]]) {
                textField.text = @"";
            } else
                textField.text = appDelegate.activePromotion != nil ? [NSDateFormatter localizedStringFromDate:[NSDate dateWithTimeIntervalSince1970:[appDelegate.activePromotion[@"end"] intValue]] dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle] : @"";
        else
            textField.text = [NSDateFormatter localizedStringFromDate:pickerValues[@(indexPath.section)] dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
        textFields[@4] = textField;
        [cell.contentView addSubview:textField];
    } else if (indexPath.section == 5) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];        textField.backgroundColor = [UIColor clearColor];
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.text = appDelegate.activePromotion != nil ? [appDelegate.activePromotion[@"maximum"] stringValue] : @"";
        textFields[@5] = textField;
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
    pickerValues[@(indexPath.section)] = self.pickerView.date;
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
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

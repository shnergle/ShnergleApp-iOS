//
//  AddPromotionsViewController.h
//  ShnergleApp
//
//  Created by Harshita Balaga on 13/06/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "CustomBackViewController.h"

@interface AddPromotionsViewController : CustomBackViewController<UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate>
{
    UIBarButtonItem *publishButton;
    NSMutableArray *textFields;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *tableData;
@property (weak, nonatomic) IBOutlet UIDatePicker *pickerView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;
- (IBAction)doneAction:(id)sender;

@end

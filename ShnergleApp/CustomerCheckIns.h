//
//  CustomerCheckIns.h
//  ShnergleApp
//
//  Created by Harshita Balaga on 11/09/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "CustomBackViewController.h"

@interface CustomerCheckIns : CustomBackViewController <UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textfield1;
@property (weak, nonatomic) IBOutlet UITextField *textfield2;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@end

//
//  VenueDetailsViewController.h
//  ShnergleApp
//
//  Created by Harshita Balaga on 11/06/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "CustomBackViewController.h"

@interface VenueDetailsViewController : CustomBackViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    NSArray *tableData;
    NSMutableArray *textFields;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView2;

@end

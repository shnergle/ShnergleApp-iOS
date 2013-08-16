//
//  ImpViewController.h
//  ShnergleApp
//
//  Created by Harshita Balaga on 14/08/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "CustomBackViewController.h"

@interface ImpViewController : CustomBackViewController <UICollectionViewDelegate, UICollectionViewDataSource>

- (IBAction)showInfo:(id)sender;
//@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *tableData;

@end

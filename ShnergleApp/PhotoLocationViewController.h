//
//  PhotoLocationViewController.h
//  ShnergleApp
//
//  Created by Stian Johansen on 3/22/13.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomBackViewController.h"

@interface PhotoLocationViewController : CustomBackViewController
@property (weak, nonatomic) IBOutlet UILabel *headline;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *searchResultTable;
@property (nonatomic, retain) NSArray *tableData;


@end

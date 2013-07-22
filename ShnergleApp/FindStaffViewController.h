//
//  FindStaffViewController.h
//  ShnergleApp
//
//  Created by Adam Hani Schakaki on 22/07/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "CustomBackViewController.h"

@interface FindStaffViewController : CustomBackViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>
{
    NSArray *results;
}
@property (weak, nonatomic) IBOutlet UITableView *resultsView;

@end

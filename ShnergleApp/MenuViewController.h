//
//  MenuViewController.h
//  ShnergleApp
//
//  Created by Stian Johansen on 11/05/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "SearchResultsView.h"

@interface MenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    NSArray *tableSections;
    NSArray *tableData;
    NSMutableArray *searchResults;
    NSMutableArray *searchResultsLocation;
    UITableViewCell *profileCell;
    UIView *searchB;
}

@property (weak, nonatomic) IBOutlet UIView *searchBar;
@property (weak, nonatomic) IBOutlet UITextField *bar;
@property (weak, nonatomic) IBOutlet SearchResultsView *searchResultsView;
@property (weak, nonatomic) IBOutlet UITableView *menuItemsTableView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end

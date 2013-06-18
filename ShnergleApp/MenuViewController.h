//
//  MenuViewController.h
//  ShnergleApp
//
//  Created by Stian Johansen on 11/05/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "SearchBarView.h"
#import "SearchResultsView.h"

@interface MenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet SearchBarView *searchBar;
@property (weak, nonatomic) IBOutlet UITextField *bar;
@property (strong, nonatomic) NSArray *tableSections;
@property (strong, nonatomic) NSDictionary *tableData;
@property (strong, nonatomic) NSMutableArray *searchResults;
@property (weak, nonatomic) IBOutlet UITableView *menuItemsTableView;

@property (strong, nonatomic) UITableViewCell *profileCell;
@property (weak, nonatomic) IBOutlet SearchResultsView *searchResultsView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
- (IBAction)cancelButtonTapped:(id)sender;

@end

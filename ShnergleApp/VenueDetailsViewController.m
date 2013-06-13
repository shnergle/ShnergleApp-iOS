//
//  VenueDetailsViewController.m
//  ShnergleApp
//
//  Created by Harshita Balaga on 11/06/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "VenueDetailsViewController.h"

@interface VenueDetailsViewController ()

@end

@implementation VenueDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Venue Details";
    //[self setRightBarButton: [NSString @"Done"];

    self.tableData = @[@"Phone", @"Email", @"Website"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setRightBarButton:@"Done" actionSelector:@selector(goBack)];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"Cell%d", indexPath.row ]];
    cell.textLabel.text = _tableData[indexPath.row];
    if (indexPath.row == 0) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
        textField.placeholder = @"(Required)";
        [cell.contentView addSubview:textField];
    } else if (indexPath.row == 1) {
        UILabel *textField = [[UILabel alloc] initWithFrame:CGRectMake(110, 6, 185, 30)];
        textField.text = @"(Required)";
        textField.textColor = [UIColor lightGrayColor];
        textField.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:textField];
    } else if (indexPath.row == 2) {
        UILabel *textField = [[UILabel alloc] initWithFrame:CGRectMake(110, 6, 185, 30)];
        textField.text = @"(Required)";
        textField.textColor = [UIColor lightGrayColor];
        textField.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:textField];
    }
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

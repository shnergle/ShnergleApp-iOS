//
//  StaffEditViewController.m
//  ShnergleApp
//
//  Created by Adam Hani Schakaki on 12/06/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "StaffEditViewController.h"

@implementation StaffEditViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title = @"Staff";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"Cell%d", indexPath.row ]];
    if (indexPath.row == 0) {
        UISwitch *textField = [[UISwitch alloc] initWithFrame:CGRectMake(210, 8, 50, 30)];
        [textField addTarget:self action:@selector(canCreatePromo) forControlEvents:UIControlEventAllEvents];
        cell.textLabel.text = @"Can create promotions";
        [cell.contentView addSubview:textField];
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"Status: Staff";
    }
    return cell;
}

- (void)canCreatePromo {
    NSLog(@"switch");
}

@end

//
//  ImpViewController.m
//  ShnergleApp
//
//  Created by Harshita Balaga on 14/08/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "ImpViewController.h"

@implementation ImpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableData = @[@"Estimated Revenue from Shnergle", @"Customers Checking in", @"Demographics of Check-Ins", @"Audience viewing your venue", @"Audience Demographics", @"Venue followers", @"Conversion rates"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"Cell%ld", (long)indexPath.row]];
    cell.textLabel.text = self.tableData[indexPath.row];
    return cell;
}

- (IBAction)showInfo:(id)sender {
    [[[UIAlertView alloc] initWithTitle:@"We use this figure to calculate the estimated financial value of the Shnergle users checking-in to your venue so that you don’t have to. This information will be kept confidential and will not be shared with anyone." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

@end

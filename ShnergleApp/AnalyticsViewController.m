//
//  AnalyticsViewController.m
//  ShnergleApp
//
//  Created by Harshita Balaga on 06/08/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "AnalyticsViewController.h"

@implementation AnalyticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    tableData = @[@"Important Stuff", @"Optimisation", @"Of Interest"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title = @"Analytics";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"Cell%ld", (long)indexPath.row]];
    if (indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"glyphicons_228_gbp"];
    } else if (indexPath.row == 1) {
        cell.imageView.image = [UIImage imageNamed:@"glyphicons_280_settings"];
    } else if (indexPath.row == 2) {
        cell.imageView.image = [UIImage imageNamed:@"glyphicons_194_circle_question_mark"];
    }
    cell.textLabel.text = tableData[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tableView.bounds.size.height / 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

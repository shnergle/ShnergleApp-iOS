//
//  AnalyticsViewController.m
//  ShnergleApp
//
//  Created by Harshita Balaga on 06/08/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "AnalyticsViewController.h"

@interface AnalyticsViewController ()

@end

@implementation AnalyticsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableData = @[@"Important Stuff", @"Optimisation", @"Of Interest"];
	// Do any additional setup after loading the view.
}


-(void)viewDidAppear:(BOOL)animated{
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title = @"Analytics";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"glyphicons_228_gbp"];
    }
    else if (indexPath.row == 1){
        cell.imageView.image = [UIImage imageNamed:@"glyphicons_280_settings"];
    }
    else if (indexPath.row == 2){
        cell.imageView.image = [UIImage imageNamed:@"glyphicons_194_circle_question_mark"];
    }
    cell.textLabel.text = self.tableData [indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableView.bounds.size.height/3;
}

@end

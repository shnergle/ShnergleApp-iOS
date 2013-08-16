//
//  ImpViewController.m
//  ShnergleApp
//
//  Created by Harshita Balaga on 14/08/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "ImpViewController.h"

@implementation ImpViewController

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
     self.tableData = @[@"Estimated Revenue from Shnergle", @"Customers Checking in", @"Demographics of Check-Ins", @"Audience viewing your venue", @"Audience Demographics", @"Venue followers", @"Conversion rates"];
	// Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"Cell%d", indexPath.row]];
   /* if (indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"glyphicons_228_gbp"];
    } else if (indexPath.row == 1) {
        cell.imageView.image = [UIImage imageNamed:@"glyphicons_280_settings"];
    } else if (indexPath.row == 2) {
        cell.imageView.image = [UIImage imageNamed:@"glyphicons_194_circle_question_mark"];
    }*/
    cell.textLabel.text = self.tableData[indexPath.row];
    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showInfo:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"We use this figure to calculate the estimated financial value of the Shnergle users checking-in to your venue so that you don’t have to. This information will be kept confidential and will not be shared with anyone." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title = @"Important Stuff";
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

@end

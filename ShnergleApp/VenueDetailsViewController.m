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
	self.navigationItem.title = @"Add Place";
    [self setRightBarButton:@"Add" actionSelector:@selector(addVenue)];
    
    self tableData = @[@"Name", @"Category", @"Address 1", @"Address 2", @"City", @"Postcode", @"Work here?"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

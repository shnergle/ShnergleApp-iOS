//
//  AddVenueViewController.m
//  ShnergleApp
//
//  Created by Stian Johansen on 10/06/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "AddVenueViewController.h"
#import "AppDelegate.h"

@interface AddVenueViewController ()

@end

@implementation AddVenueViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Add Place";
    [self setRightBarButton:@"Add" actionSelector:@selector(addVenue)];

    _tableData = @[@"Name", @"Category", @"Address 1", @"Address 2", @"City", @"Postcode", @"Work here?"];
    [self initMap];
}

- (void)addVenue {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"Cell%d", indexPath.row ]];
    cell.textLabel.text = _tableData[indexPath.row];
    if (indexPath.row == 0) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
        textField.delegate = self;
        textField.placeholder = @"(Required)";
        [cell.contentView addSubview:textField];
    } else if (indexPath.row == 1) {
        UILabel *textField = [[UILabel alloc] initWithFrame:CGRectMake(110, 6, 185, 30)];
        textField.text = @"(Required)";
        textField.textColor = [UIColor lightGrayColor];
        textField.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:textField];
        secondCellField = textField;
        secondCell = cell;
    } else if (indexPath.row == 2) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
        textField.delegate = self;
        textField.placeholder = @"(Optional)";
        [cell.contentView addSubview:textField];
    } else if (indexPath.row == 3) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
        textField.delegate = self;
        textField.placeholder = @"(Optional)";
        [cell.contentView addSubview:textField];
    } else if (indexPath.row == 4) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
        textField.delegate = self;
        textField.placeholder = @"(Optional)";
        [cell.contentView addSubview:textField];
    } else if (indexPath.row == 5) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
        textField.delegate = self;
        textField.placeholder = @"(Optional)";
        [cell.contentView addSubview:textField];
    } else if (indexPath.row == 6) {
        UISwitch *textField = [[UISwitch alloc] initWithFrame:CGRectMake(210, 8, 50, 30)];
        [textField addTarget:self action:@selector(segwayToWork) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:textField];
        _workSwitch = textField;
    }

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableData.count;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if (appDelegate.addVenueType != nil) {
        secondCellField.text = appDelegate.addVenueType;
        secondCellField.textColor = [UIColor blackColor];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)segwayToWork {
    if (_workSwitch.on == YES) {
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VenueDetailsViewIdentifier"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    secondCell.selected = NO;
}

- (void)goBack {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.addVenueType = nil;
    [super goBack];
}


- (void)initMap {
    hasPositionLocked = NO;
    self.mapView.myLocationEnabled = YES;
    self.mapView.delegate = self;
    [self.mapView addObserver:self forKeyPath:@"myLocation" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    // How it works:
    // Whenever position changes, this method is run. It then changes the camera to point to the current position, minus a small latitude (to make the map position center in the top part of our Around Me view). The zoom level is an average level of detail for a few blocks.
    
    //Make sure it is only run once:
    if (!hasPositionLocked) {
        NSLog(@"the location observer is being run");
        if ([keyPath isEqualToString:@"myLocation"] && [object isKindOfClass:[GMSMapView class]]) {
            [self.mapView animateToCameraPosition:[GMSCameraPosition cameraWithLatitude:self.mapView.myLocation.coordinate.latitude - 0.012
                                                                              longitude:self.mapView.myLocation.coordinate.longitude
                                                                                   zoom:13]];
            hasPositionLocked = YES;
        }
    }
}


@end

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

typedef enum {
    Name,
    Category,
    Address1,
    Address2,
    City,
    Postcode,
    WorkHere
    
} Field;

#define TextFieldTag 2

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
}

- (void)addVenue {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"Cell%d", indexPath.row ]];
    if(cell == nil)
        cell = [[UITableViewCell alloc] init];
    
    
    cell.textLabel.text = _tableData[indexPath.row];
    /*
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
    textField.delegate = self;
    textField.tag = indexPath.row;
    */
    
    UITextField *textField = (UITextField*) [cell viewWithTag:indexPath.row+1];
    if (!textField) {
        textField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
        textField.tag = indexPath.row+1;
        textField.delegate = self;
    }
    
    if (indexPath.row == Name) {
        textField.placeholder = @"(Required)";
        [cell.contentView addSubview:textField];
    } else if (indexPath.row == Category) {
        
        UILabel *label = (UILabel *) [cell viewWithTag:indexPath.row+10];
        if(!label){
        label = [[UILabel alloc] initWithFrame:CGRectMake(110, 6, 185, 30)];
        label.text = @"(Required)";
        label.tag = indexPath.row+10;
        label.textColor = [UIColor lightGrayColor];
        label.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:label];
        secondCellField = label;
        secondCell = cell;
        }
    } else if (indexPath.row == Address1) {
        textField.placeholder = @"(Optional)";
        [cell.contentView addSubview:textField];
    } else if (indexPath.row == Address2) {
        textField.placeholder = @"(Optional)";
        [cell.contentView addSubview:textField];
    } else if (indexPath.row == City) {
        textField.placeholder = @"(Optional)";
        [cell.contentView addSubview:textField];
    } else if (indexPath.row == Postcode) {
        textField.placeholder = @"(Optional)";
        [cell.contentView addSubview:textField];
    } else if (indexPath.row == WorkHere) {
        UISwitch *workSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(210, 8, 50, 30)];
        [workSwitch addTarget:self action:@selector(segwayToWork) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:workSwitch];
        
        _workSwitch = workSwitch;
    }
    
    
    if(![(self.userData)[indexPath.row] isEqualToString:@""]){
        //NSLog(@"%@ at indexPath.row %d",[self.userData objectAtIndex:indexPath.row], indexPath.row);
        textField.placeholder = nil;
        textField.text = (self.userData)[indexPath.row];
    }
    return cell;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.placeholder = nil;
    textField.text = @"";
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
    [self initMap];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    self.userData[textField.tag] = textField.text;
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
    map = [[GMSMapView alloc] initWithFrame:_mapView.frame];
    map.myLocationEnabled = YES;
    map.delegate = self;
    [map addObserver:self forKeyPath:@"myLocation" options:NSKeyValueObservingOptionNew context:nil];
    [_mapView addSubview:map];
    [_mapView sendSubviewToBack:map];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    // How it works:
    // Whenever position changes, this method is run. It then changes the camera to point to the current position, minus a small latitude (to make the map position center in the top part of our Around Me view). The zoom level is an average level of detail for a few blocks.

    //Make sure it is only run once:
    if (!hasPositionLocked) {
        if ([keyPath isEqualToString:@"myLocation"] && [object isKindOfClass:[GMSMapView class]]) {
            [map animateToCameraPosition:[GMSCameraPosition cameraWithLatitude:map.myLocation.coordinate.latitude
                                                                     longitude:map.myLocation.coordinate.longitude
                                                                          zoom:13]];

            [self mapView:map didTapAtCoordinate:map.myLocation.coordinate];
            venueCoord = map.myLocation.coordinate;

            hasPositionLocked = YES;
        }
    }
}

- (void)       mapView:(GMSMapView *)mapView
    didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    [mapView clear];
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude);
    GMSMarker *marker = [GMSMarker markerWithPosition:position];
    marker.title = @"Selected venue location";
    marker.map = mapView;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [map removeObserver:self forKeyPath:@"myLocation" context:nil];
    [map clear];
    [map stopRendering];
    [map removeFromSuperview];
    map = nil;
}



- (void)addBorder{
    CALayer *bottomBorder = [CALayer layer];
    
    bottomBorder.frame = CGRectMake(0.0f, 70.0f, self.mapView.frame.size.width, 1.0f);
    
    bottomBorder.backgroundColor = [UIColor lightGrayColor].CGColor;
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"%f  %f", self.mapView.frame.size.height, self.mapView.bounds.size.height);
    
    [self addBorder];
    
    CALayer *topBorder = [CALayer layer];
    
    topBorder.frame = CGRectMake(0.0f, self.mapView.bounds.size.height - 1 , self.mapView.frame.size.width
                                 , 1.0f);
    //topBorder.frame = CGRectMake(0.0f, self.mapView.bounds.origin.x + 190, self.mapView.frame.size.height
      //                           , 1.0f);
    
    topBorder.backgroundColor = [UIColor lightGrayColor].CGColor;
    
    [self.mapView.layer addSublayer:topBorder];
}

-(NSMutableArray *)userData
{
    if(!_userData){
        _userData = [[NSMutableArray alloc] initWithCapacity:[self.tableData count]];
        for (int i = 0; i < [self.tableData count]; i++)
            [_userData addObject:@""];
    }
    return _userData;
}

@end

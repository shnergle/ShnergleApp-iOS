//
//  PhotoLocationViewController.m
//  ShnergleApp
//
//  Created by Stian Johansen on 3/22/13.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "PhotoLocationViewController.h"
#import "ShareViewController.h"
#import "PostRequest.h"

@implementation PhotoLocationViewController

- (void)viewDidLoad {
    if(appDelegate.backFromShareView || appDelegate.activeVenue){
        
    }else{
    [super viewDidLoad];
    self.navigationItem.title = @"Location";
    appDelegate.locationPickerVenues = nil;
    [self.searchResultTable makeToastActivity];
    }
}

- (void)didFinishLoadingVenues:(NSArray *)response {
    appDelegate.locationPickerVenues = [NSMutableArray arrayWithArray:response];
    locationPickerVenuesImmutable = [NSArray arrayWithArray:response];
    [self.searchResultTable reloadData];
    [self.searchResultTable hideToastActivity];
}

- (void)viewWillAppear:(BOOL)animated {
    
    NSLog(@"%c",appDelegate.backFromShareView);
    if(appDelegate.backFromShareView){
        appDelegate.backFromShareView = NO;
        [self goBack];
    }else if(appDelegate.activeVenue){
        self.navigationController.navigationBarHidden = NO;

        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ShareViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self initMap];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [appDelegate.locationPickerVenues count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }

    cell.textLabel.text = appDelegate.locationPickerVenues[indexPath.row][@"name"];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont systemFontOfSize:20.0];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    appDelegate.activeVenue = appDelegate.locationPickerVenues[indexPath.row];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    appDelegate.locationPickerVenues = [[NSMutableArray alloc]init];
    for (id obj in locationPickerVenuesImmutable) {
        if ([obj[@"name"] rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch].length > 0) {
            [appDelegate.locationPickerVenues addObject:obj];
        }
    }
    [self.searchResultTable reloadData];
    [searchBar resignFirstResponder];
}

- (void)initMap {
    hasPositionLocked = NO;
    map = [[GMSMapView alloc] initWithFrame:_mapView.bounds];
    map.myLocationEnabled = YES;
    map.delegate = self;
    [map addObserver:self forKeyPath:@"myLocation" options:NSKeyValueObservingOptionNew context:nil];
    [_mapView addSubview:map];
    [_mapView sendSubviewToBack:map];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [map removeObserver:self forKeyPath:@"myLocation" context:nil];
    [map clear];
    [map stopRendering];
    [map removeFromSuperview];
    map = nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (!hasPositionLocked) {
        if ([keyPath isEqualToString:@"myLocation"] && [object isKindOfClass:[GMSMapView class]]) {
            coord = map.myLocation.coordinate;
            CGFloat screenDistance = [map.projection pointsForMeters:100 atCoordinate:coord];
            CGPoint screenCenter = [map.projection pointForCoordinate:coord];
            CGPoint screenPoint = CGPointMake(screenCenter.x - screenDistance, screenCenter.y);
            CLLocationCoordinate2D realPoint = [map.projection coordinateForPoint:screenPoint];
            CGFloat distanceInDegrees = coord.longitude - realPoint.longitude;
            [[[PostRequest alloc] init] exec:@"venues/get" params:[NSString stringWithFormat:@"my_lat=%f&my_lon=%f&distance=%f", coord.latitude, coord.longitude, distanceInDegrees] delegate:self callback:@selector(didFinishLoadingVenues:)];
            [map animateToCameraPosition:[GMSCameraPosition cameraWithLatitude:map.myLocation.coordinate.latitude
                                                                     longitude:map.myLocation.coordinate.longitude
                                                                          zoom:13]];

            hasPositionLocked = YES;
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual:@"SegueToShare"]) {
        ((ShareViewController *)[segue destinationViewController]).shnergleThis = YES;
    }
}


@end

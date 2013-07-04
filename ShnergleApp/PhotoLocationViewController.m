//
//  PhotoLocationViewController.m
//  ShnergleApp
//
//  Created by Stian Johansen on 3/22/13.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "PhotoLocationViewController.h"
#import "AppDelegate.h"

@implementation PhotoLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Location";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self initMap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    return [appDelegate.aroundVenues count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }

    cell.textLabel.text = appDelegate.aroundVenues[indexPath.row][@"name"];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont systemFontOfSize:20.0];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.activeVenue = appDelegate.aroundVenues[indexPath.row];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
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
    // How it works:
    // Whenever position changes, this method is run. It then changes the camera to point to the current position, minus a small latitude (to make the map position center in the top part of our Around Me view). The zoom level is an average level of detail for a few blocks.

    //Make sure it is only run once:
    if (!hasPositionLocked) {
        if ([keyPath isEqualToString:@"myLocation"] && [object isKindOfClass:[GMSMapView class]]) {
            [map animateToCameraPosition:[GMSCameraPosition cameraWithLatitude:map.myLocation.coordinate.latitude
                                                                     longitude:map.myLocation.coordinate.longitude
                                                                          zoom:13]];

            hasPositionLocked = YES;
        }
    }
}

@end

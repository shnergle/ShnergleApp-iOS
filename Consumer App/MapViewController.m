//
//  MapViewController.m
//  Consumer App
//
//  Created by Harshita Balaga on 05/04/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "MapViewController.h"
#import "GoogleMaps/GoogleMaps.h"
#import "CoreLocation/CoreLocation.h"

@interface MapViewController ()

@end

@implementation MapViewController {
    GMSMapView *mapView_;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}


/*- (NSString *)deviceLocation {
    NSString *theLocation = [NSString stringWithFormat:@"latitude: %f longitude: %f", locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude];
    return theLocation;
   }*/


- (void)loadView
{
    [super loadView];
    self.locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [_locationManager startUpdatingLocation];

    //NSLog(@"%@", [self deviceLocation]);


    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude: _locationManager.location.coordinate.latitude
                                 longitude: _locationManager.location.coordinate.longitude
                                 zoom:6];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
    self.view = mapView_;
    // Do any additional setup after loading the view.

    /*GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.8683
                                                            longitude:151.2086
                                                                 zoom:6];
       mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
       mapView_.myLocationEnabled = YES;
       self.view = mapView_;

       GMSMarkerOptions *options = [[GMSMarkerOptions alloc] init];
       options.position = CLLocationCoordinate2DMake(-33.8683, 151.2086);
       options.title = @"Sydney";
       options.snippet = @"Australia";
       [mapView_ addMarkerWithOptions:options];*/
}





/*- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
   {


   }*/


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
//
//  MapViewController.h
//  ShnergleApp
//
//  Created by Harshita Balaga on 05/04/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>

@interface MapViewController : UIViewController <CLLocationManagerDelegate> {
}

@property (strong, nonatomic) CLLocationManager *locationManager;
//@property (weak, nonatomic) IBOutlet GMSMapView *mapView_;

@end

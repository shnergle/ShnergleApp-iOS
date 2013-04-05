//
//  MapViewController.h
//  Consumer App
//
//  Created by Harshita Balaga on 05/04/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreLocation/CoreLocation.h"

@interface MapViewController : UIViewController <CLLocationManagerDelegate> {
}

@property (strong, nonatomic) CLLocationManager *location;

@end

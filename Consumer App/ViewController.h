//
//  ViewController.h
//  Consumer App
//
//  Created by Stian Johansen on 3/21/13.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoogleMaps/GoogleMaps.h"
#import "CoreLocation/CoreLocation.h"


NSInteger selectedVenueIndex;


@interface ViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate> {
    
    /*IBOutlet GMSMapView *mapView;
    IBOutlet CLLocationManager *locationManager;
    IBOutlet UILabel *Latitude;
    IBOutlet UILabel *Longitude;
    */
}
@property (weak, nonatomic) IBOutlet UICollectionView *crowdCollection;
/*@property (atomic, retain) IBOutlet GMSMapView *mapView;
@property (atomic, retain) IBOutlet UILabel *Latitude;
@property (atomic, retain) IBOutlet UILabel *Longitude;*/

@end

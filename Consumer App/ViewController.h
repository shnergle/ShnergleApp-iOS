//
//  ViewController.h
//  Consumer App
//
//  Created by Stian Johansen on 3/21/13.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoogleMaps/GoogleMaps.h"
#import "overlayText.h"


NSInteger selectedVenueIndex;


@interface ViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate> {
    
}
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UICollectionView *crowdCollection;
@property (weak, nonatomic) IBOutlet overlayText *overlay;
@property(nonatomic, retain) UIView *titleView;
-(BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView;
-(void)createTitleButton;
- (IBAction)tapMap:(id)sender;
-(void)hideOverlay;
-(void)showOverlay;
@end

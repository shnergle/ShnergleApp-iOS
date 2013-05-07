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
#import "DropDownMenu.h"
//#import <QuartzCore/QuartzCore.h> // shadow and border

NSInteger selectedVenueIndex;


@interface ViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate> {
    
}
@property (weak, nonatomic) IBOutlet UIImageView *dropDownIndicator;
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UICollectionView *crowdCollection;
@property (weak, nonatomic) IBOutlet overlayText *overlay;
@property(nonatomic, retain) UIView *titleView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet DropDownMenu *dropDownMenu;
-(BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView;
-(void)createTitleButton;
- (IBAction)tapMap:(id)sender;
- (IBAction)tapTitle:(id)sender;
-(void)hideOverlay;
-(void)showOverlay;
@end

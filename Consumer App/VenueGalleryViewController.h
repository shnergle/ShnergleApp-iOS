//
//  VenueGalleryViewController.h
//  Consumer App
//
//  Created by Stian Johansen on 26/04/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VenueGalleryViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *imagePageControl;

-(void)imageScrollerSetup;
@end

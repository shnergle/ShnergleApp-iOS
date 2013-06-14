//
//  VenueGalleryViewController.h
//  ShnergleApp
//
//  Created by Stian Johansen on 26/04/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Toast+UIView.h>
#import <Toast+UIView.h>
#import "CustomBackViewController.h"

@interface VenueGalleryViewController : CustomBackViewController <UIAlertViewDelegate>
{
    NSArray *images;
    NSInteger imageIndex;
}
@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;

- (IBAction)flagButtonPressed:(id)sender;
- (IBAction)likeButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

- (void)imageScrollerSetup;
- (void)setTitle:(NSString *)title;
- (void)setImages:(NSArray *)img index:(NSInteger)index;
@end

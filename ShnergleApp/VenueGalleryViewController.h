//
//  VenueGalleryViewController.h
//  ShnergleApp
//
//  Created by Stian Johansen on 26/04/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "CustomBackViewController.h"
#import <GVPhotoBrowser/GVPhotoBrowser.h>

@interface VenueGalleryViewController : CustomBackViewController <UIAlertViewDelegate, GVPhotoBrowserDataSource, GVPhotoBrowserDelegate>
{
    NSUInteger image;
    NSArray *images;
}
@property (weak, nonatomic) IBOutlet GVPhotoBrowser *photoScroller;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;

@property (weak, nonatomic) IBOutlet UIButton *likeButton;

- (void)setTitle:(NSString *)title;
- (void)setImage:(NSUInteger)img of:(NSArray *)imgs;
@end

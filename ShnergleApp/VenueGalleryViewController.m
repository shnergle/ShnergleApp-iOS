//
//  VenueGalleryViewController.m
//  ShnergleApp
//
//  Created by Stian Johansen on 26/04/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "VenueGalleryViewController.h"
#import "Request.h"
#import <Toast/Toast+UIView.h>
#import <NSDate+TimeAgo/NSDate+TimeAgo.h>

@implementation VenueGalleryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self imageSetup];
}

- (void)setImage:(NSUInteger)img of:(NSArray *)imgs {
    image = img;
    images = imgs;
}

- (void)setTitle:(NSString *)title {
    self.navigationItem.title = title;
}

- (IBAction)flagButtonPressed:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Flag for Review" message:@"Flag as inappropriate?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
    [alert show];
}

- (IBAction)likeButtonPressed:(id)sender {
    [Request post:@"post_likes/set" params:@{@"post_id": images[self.photoScroller.currentIndex][@"id"]} delegate:self callback:@selector(likedPostFinished:)];
}

- (void)likedPostFinished:(id)response {
    [self.view makeToast:@"Liked it!"
                duration:0.5
                position:@"center"
                   title:@""
                   image:[UIImage imageNamed:@"glyphicons_343_thumbs_up"]];
}

- (void)imageSetup {
    self.commentLabel.font = [UIFont systemFontOfSize:12];
    self.commentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.authorLabel.font = [UIFont boldSystemFontOfSize:12];
    self.authorLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.photoScroller.currentIndex = image;
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(GVPhotoBrowser *)photoBrowser {
    return [images count];
}

- (UIImageView *)photoBrowser:(GVPhotoBrowser *)photoBrowser customizeImageView:(UIImageView *)imageView forIndex:(NSUInteger)index {
    NSDictionary *key = @{@"entity": @"post",
                          @"entity_id": images[index][@"id"]};
    imageView.backgroundColor = [UIColor lightGrayColor];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    if (!(imageView.image = [Request getImage:key])) {
        [Request post:@"images/get" params:key delegate:self callback:@selector(didFinishDownloadingImages:forImageView:) userData:imageView];
    }
    return imageView;
}

- (void)didFinishDownloadingImages:(UIImage *)img forImageView:(UIImageView *)imageView {
    imageView.image = img;
}

- (NSString *)getDateFromUnixFormat:(id)unixFormat {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[unixFormat intValue]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"ccc H:mm";
    return [date timeAgoWithLimit:86400 dateFormatter:dateFormatter];
}

- (void)photoBrowser:(GVPhotoBrowser *)photoBrowser didSwitchToIndex:(NSUInteger)index {
    self.authorLabel.text = [NSString stringWithFormat:@"%@ %@", images[index][@"forename"], [images[index][@"surname"] substringToIndex:1]];
    self.commentLabel.text = [NSString stringWithFormat:@"%@ (%@)", images[index][@"caption"], [self getDateFromUnixFormat:images[index][@"time"]]];

    [Request post:@"post_views/set" params:@{@"post_id": images[index][@"id"]} delegate:self callback:@selector(doNothing:)];
    appDelegate.shareActivePostId = images[index][@"id"];

    NSDictionary *key = @{@"entity": @"post",
                          @"entity_id": images[index][@"id"]};
    [Request setImage:@{@"entity": @"image", @"entity_id": @"toShare"} image:[Request getImage:key]];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        [self.view makeToastActivity];
        if (appDelegate.venueStatus == Manager) {
            [Request post:@"posts/set" params:@{@"post_id": images[self.photoScroller.currentIndex][@"id"], @"hide": @"true"} delegate:self callback:@selector(doNothing:)];
        } else {
            [Request post:@"post_reports/set" params:@{@"post_id": images[self.photoScroller.currentIndex][@"id"]} delegate:self callback:@selector(doNothing:)];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([@"sharePostSegue" isEqualToString : segue.identifier]) {
        appDelegate.shareVenue = NO;
    }
}

- (void)doNothing:(id)whoCares {
    [self.view hideToastActivity];
}

@end

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

@implementation VenueGalleryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self imageSetup];
    [Request post:@"post_views/set" params:@{@"post_id": appDelegate.shareActivePostId} delegate:self callback:@selector(doNothing:)];
}

- (void)setImage:(UIImage *)img withAuthor:(NSString *)user withComment:(NSString *)msg withTimestamp:(NSString *)time withId:(NSString *)post_id {
    image = img;
    comment = msg;
    timestamp = time;
    author = user;
    postId = post_id;
}

- (void)setTitle:(NSString *)title {
    self.navigationItem.title = title;
}

- (IBAction)flagButtonPressed:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Flag for Review" message:@"Flag as inappropriate?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
    [alert show];
}

- (IBAction)likeButtonPressed:(id)sender {
    [Request post:@"post_likes/set" params:@{@"post_id": appDelegate.shareActivePostId} delegate:self callback:@selector(likedPostFinished:)];
}

- (void)likedPostFinished:(id)response {
    [self.view makeToast:@"Liked it!"
                duration:0.5
                position:@"center"
                   title:@""
                   image:[UIImage imageNamed:@"glyphicons_343_thumbs_up"]];
}

- (void)imageSetup {
    self.imageView.image = image;
    self.imageView.contentMode = UIViewContentModeCenter;
    self.commentLabel.font = [UIFont systemFontOfSize:12];
    self.commentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.commentLabel.text = [NSString stringWithFormat:@"%@ (%@)", comment, timestamp];
    self.authorLabel.font = [UIFont boldSystemFontOfSize:12];
    self.authorLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.authorLabel.text = author;

    [Request setImage:@{@"entity": @"image", @"entity_id": @"toShare"} image:image];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        [self.view makeToastActivity];
        if (appDelegate.venueStatus == Manager) {
            [Request post:@"posts/set" params:@{@"post_id": appDelegate.shareActivePostId, @"hide": @"true"} delegate:self callback:@selector(doNothing:)];
        } else {
            [Request post:@"post_reports/set" params:@{@"post_id": appDelegate.shareActivePostId} delegate:self callback:@selector(doNothing:)];
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

//
//  VenueGalleryViewController.m
//  ShnergleApp
//
//  Created by Stian Johansen on 26/04/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "VenueGalleryViewController.h"
#import "PostRequest.h"

@implementation VenueGalleryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self imageSetup];
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
    NSString *newButtonLabel;

    if ([self.likeButton.titleLabel.text isEqualToString:@"Like"]) {
        [self.view makeToast:@"Liked it!"
                    duration:0.5
                    position:@"center"
                       title:@""
                       image:[UIImage imageNamed:@"glyphicons_343_thumbs_up.png"]];

        newButtonLabel = @"Unlike";
    } else {
        newButtonLabel = @"Like";
    }

    [self.likeButton setTitle:newButtonLabel forState:UIControlStateNormal];
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

    appDelegate.shareImage = image;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.view makeToastActivity];
    if (buttonIndex != alertView.cancelButtonIndex) {
        if (appDelegate.venueStatus == Manager) {
            [[[PostRequest alloc] init] exec:@"posts/set" params:[NSString stringWithFormat:@"post_id=%@&hide=true", postId] delegate:self callback:@selector(doNothing:) type:@"string"];
        } else {
            [[[PostRequest alloc] init] exec:@"post_reports/set" params:[NSString stringWithFormat:@"post_id=%@", postId] delegate:self callback:@selector(doNothing:) type:@"string"];
        }
    }
}

- (void)doNothing:(id)whoCares {
    [self.view hideToastActivity];
}

@end

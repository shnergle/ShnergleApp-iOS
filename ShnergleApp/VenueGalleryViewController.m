//
//  VenueGalleryViewController.m
//  ShnergleApp
//
//  Created by Stian Johansen on 26/04/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "VenueGalleryViewController.h"
#import "AppDelegate.h"
@implementation VenueGalleryViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self imageSetup];
}

/*
   - (void)setImages:(NSArray *)img index:(NSInteger)index {
    images = img;
    imageIndex = index;
   }
 */

- (void)setImage:(UIImage *)img withAuthor:(NSString *)user withComment:(NSString *)msg withTimestamp:(NSString *)time {
    image = img;
    comment = msg;
    timestamp = time;
    author = user;
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

/*
   - (void)imageScrollerSetup {
    CGRect windowBounds = [[UIScreen mainScreen] bounds];
    _imageScrollView.bounds = CGRectMake(0, 0, windowBounds.size.width, 245);
    NSMutableArray *imageViews = [[NSMutableArray alloc]init];
    for (int i = 0; i < images.count; i++) {
        UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:images[i]]];
        [imageViews addObject:imgV];
    }
    //UIScrollView *imageScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];


    [self.view addSubview:_imageScrollView];  //This code assumes it's in a UIViewController
    CGRect cRect = _imageScrollView.bounds;
    UIImageView *cView;
    for (int i = 0; i < imageViews.count; i++) {
        cView = imageViews[i];
        cView.frame = cRect;
        cView.backgroundColor = [UIColor blueColor];
        [_imageScrollView addSubview:cView];
        cRect.origin.x += cRect.size.width;
    }
    _imageScrollView.contentSize = CGSizeMake(cRect.origin.x, _imageScrollView.bounds.size.height);
    _imageScrollView.contentOffset = CGPointMake(_imageScrollView.bounds.size.width * imageIndex, 1.0); //should be the center page in a 3 page setup
    [self.imageScrollView updateConstraints];
    _imageScrollView.pagingEnabled = YES;
   }
 */

- (void)imageSetup {
    self.imageView.image = image;
    self.commentLabel.font = [UIFont systemFontOfSize:12];
    self.commentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.commentLabel.text = [NSString stringWithFormat:@"%@ (%@)", comment, timestamp];
    self.authorLabel.font = [UIFont boldSystemFontOfSize:12];
    self.authorLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.authorLabel.text = author;

    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

    appDelegate.shareImage = image;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        NSLog(@"flag");
    }
}

@end

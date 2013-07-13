//
//  VenueGalleryViewController.h
//  ShnergleApp
//
//  Created by Stian Johansen on 26/04/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "CustomBackViewController.h"

@interface VenueGalleryViewController : CustomBackViewController <UIAlertViewDelegate>
{
    UIImage *image;
    NSString *timestamp;
    NSString *comment;
    NSString *author;
    NSString *postId;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;

- (IBAction)flagButtonPressed:(id)sender;
- (IBAction)likeButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

- (void)setTitle:(NSString *)title;
- (void)setImage:(UIImage *)img withAuthor:(NSString *)user withComment:(NSString *)msg withTimestamp:(NSString *)time withId:(NSString *)post_id;
@end

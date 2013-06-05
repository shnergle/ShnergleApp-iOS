//
//  VenueGalleryViewController.h
//  ShnergleApp
//
//  Created by Stian Johansen on 26/04/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VenueGalleryViewController : UIViewController
{
    NSArray *images;
    NSInteger imageIndex;
}
@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;


- (UIBarButtonItem *)createLeftBarButton:(NSString *)imageName actionSelector:(SEL)actionSelector;
- (void)goBack;
- (void)imageScrollerSetup;
-(void)setTitle:(NSString *)title;
-(void)setImages:(NSArray *)img index:(NSInteger)index;
@end

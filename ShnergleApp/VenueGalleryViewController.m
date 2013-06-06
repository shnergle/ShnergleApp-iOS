//
//  VenueGalleryViewController.m
//  ShnergleApp
//
//  Created by Stian Johansen on 26/04/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "VenueGalleryViewController.h"

@implementation VenueGalleryViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self imageScrollerSetup];
}

-(void)setImages:(NSArray *)img index:(NSInteger)index
{
    images = img;
   imageIndex = index;
}


-(void)setTitle:(NSString *)title
{
    self.navigationItem.title = title;
}

- (void)imageScrollerSetup {
    CGRect windowBounds = [[UIScreen mainScreen]bounds];
    _imageScrollView.bounds = CGRectMake(0, 0, windowBounds.size.width, 245);
    NSMutableArray *imageViews = [[NSMutableArray alloc]init];
    for (int i = 0; i<images.count; i++) {
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
        NSLog(@"image added at %f,%f", cRect.origin.x, cRect.origin.y);
    }
    NSLog(@"subviews of scrollview:%d", _imageScrollView.subviews.count);
    _imageScrollView.contentSize = CGSizeMake(cRect.origin.x, _imageScrollView.bounds.size.height);
    _imageScrollView.contentOffset = CGPointMake(_imageScrollView.bounds.size.width*imageIndex, 1.0); //should be the center page in a 3 page setup
    [self.imageScrollView updateConstraints];
    _imageScrollView.pagingEnabled = YES;
}
@end

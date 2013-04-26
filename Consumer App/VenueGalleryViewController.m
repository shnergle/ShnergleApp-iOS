//
//  VenueGalleryViewController.m
//  Consumer App
//
//  Created by Stian Johansen on 26/04/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "VenueGalleryViewController.h"

@interface VenueGalleryViewController ()

@end


@implementation VenueGalleryViewController
@synthesize imageScrollView;
@synthesize imagePageControl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self imageScrollerSetup];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)imageScrollerSetup{
    
    //UIImage *image = [UIImage imageNamed:@"mahiki.jpg"];
    UIImage *image = [UIImage imageNamed:@"mahiki.jpg"];
    UIImageView *imageView1 = [[UIImageView alloc] initWithImage:image];
    UIImageView *imageView2 = [[UIImageView alloc] initWithImage:image];
    UIImageView *imageView3 = [[UIImageView alloc] initWithImage:image];
    NSArray *imageViews = [NSArray arrayWithObjects:imageView1, imageView2, imageView3, nil];
    //UIScrollView *imageScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    imageScrollView.backgroundColor = [UIColor redColor];
    
    
    //[self.view addSubview: imageScrollView]; //This code assumes it's in a UIViewController
    CGRect cRect = imageScrollView.bounds;
    UIImageView *cView;
    for (int i = 0; i < imageViews.count; i++){
        cView = [imageViews objectAtIndex:i];
        cView.frame = cRect;
        cView.backgroundColor = [UIColor blueColor];
        [imageScrollView addSubview:cView];
        cRect.origin.x += cRect.size.width;
    }
    NSLog(@"subviews of scrollview:%d",imageScrollView.subviews.count);
    imageScrollView.contentSize = CGSizeMake(cRect.origin.x, imageScrollView.bounds.size.height);
    imageScrollView.contentOffset = CGPointMake(imageScrollView.bounds.size.width, 0); //should be the center page in a 3 page setup
    imageScrollView.pagingEnabled = YES;
}

@end

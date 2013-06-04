//
//  VenueGalleryViewController.m
//  ShnergleApp
//
//  Created by Stian Johansen on 26/04/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "VenueGalleryViewController.h"

@implementation VenueGalleryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self imageScrollerSetup];
    UIBarButtonItem *menuButton;
    menuButton = [self createLeftBarButton:@"arrow_west" actionSelector:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = menuButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imageScrollerSetup {
    CGRect windowBounds = [[UIScreen mainScreen]bounds];
    _imageScrollView.bounds = CGRectMake(0, 0, windowBounds.size.width, 245);
    UIImage *image = [UIImage imageNamed:@"mahiki.jpg"];
    UIImage *image2 = [UIImage imageNamed:@"liverpool.JPG"];
    UIImageView *imageView1 = [[UIImageView alloc] initWithImage:image];
    UIImageView *imageView2 = [[UIImageView alloc] initWithImage:image2];
    UIImageView *imageView3 = [[UIImageView alloc] initWithImage:image];
    NSArray *imageViews = [NSArray arrayWithObjects:imageView1, imageView2, imageView3, nil];
    //UIScrollView *imageScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    
    
    [self.view addSubview:_imageScrollView];  //This code assumes it's in a UIViewController
    CGRect cRect = _imageScrollView.bounds;
    UIImageView *cView;
    for (int i = 0; i < imageViews.count; i++) {
        cView = [imageViews objectAtIndex:i];
        cView.frame = cRect;
        cView.backgroundColor = [UIColor blueColor];
        [_imageScrollView addSubview:cView];
        cRect.origin.x += cRect.size.width;
        NSLog(@"image added at %f,%f", cRect.origin.x, cRect.origin.y);
    }
    NSLog(@"subviews of scrollview:%d", _imageScrollView.subviews.count);
    _imageScrollView.contentSize = CGSizeMake(cRect.origin.x, _imageScrollView.bounds.size.height);
    _imageScrollView.contentOffset = CGPointMake(_imageScrollView.bounds.size.width, 1.0); //should be the center page in a 3 page setup
    [self.imageScrollView updateConstraints];
    _imageScrollView.pagingEnabled = YES;
}

- (UIBarButtonItem *)createLeftBarButton:(NSString *)imageName actionSelector:(SEL)actionSelector {
    UIImage *menuButtonImg = [UIImage imageNamed:imageName];
    
    UIButton *menuButtonTmp = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButtonTmp.frame = CGRectMake(280.0, 10.0, 19.0, 16.0);
    [menuButtonTmp setBackgroundImage:menuButtonImg forState:UIControlStateNormal];
    [menuButtonTmp addTarget:self action:actionSelector forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc]initWithCustomView:menuButtonTmp];
    return menuButton;
}

//workaround to get the custom back button to work
- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

@end

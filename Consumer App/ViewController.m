//
//  ViewController.m
//  Consumer App
//
//  Created by Stian Johansen on 3/21/13.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "ViewController.h"
#import "CrowdItem.h"
#import "GoogleMaps/GoogleMaps.h"
#import "CoreLocation/CoreLocation.h"


@interface ViewController ()
{
    NSArray *venueNames;
    NSArray *images;
    NSInteger selectedVenue;
    Boolean crowdImagesHidden;
    Boolean dropDownHidden;
    
}


@end

@implementation ViewController

@synthesize titleView;
@synthesize dropDownIndicator;
@synthesize mapView;
@synthesize overlay;
@synthesize dropDownMenu;

// Don't need to modify the default initWithNibName:bundle: method.



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //TOOLBAR Additions (colour)
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:UITextAttributeTextColor];
    /*[[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], UITextAttributeTextColor,nil]
                                                                                            forState:UIControlStateNormal];
    */
    UIBarButtonItem *backButton = [UIBarButtonItem new];
    [backButton setTitle:@"Back"];
    [backButton setTintColor:[UIColor whiteColor]];
    [backButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],UITextAttributeTextColor,nil] forState:UIControlStateNormal];
    [[self navigationItem] setBackBarButtonItem:backButton];
     
    //CROWD stuff
    [[self crowdCollection]setDataSource:self];
    [[self crowdCollection]setDelegate:self];
    [self createTitleButton];
    images = [[NSArray alloc] initWithObjects:@"liverpool.JPG", @"liverpool2.jpg", @"mahiki.jpg",@"liverpool.JPG", @"liverpool2.jpg", @"mahiki.jpg",@"liverpool.JPG", @"liverpool2.jpg", @"mahiki.jpg",nil];
    venueNames = [[NSArray alloc] initWithObjects:@"liverpool street station",@"liverpool street station",@"mahiki",@"liverpool street station",@"liverpool street station",@"mahiki",@"liverpool street station",@"liverpool street station",@"mahiki", nil];

    crowdImagesHidden = NO;
    dropDownHidden = YES;
    
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationItem.hidesBackButton = YES;
    //Make it hidden whenever we navigate back to the view as well.
    dropDownHidden = YES;
    
    //SETUP BORDERS FOR OVERLAY
    /* Or.. Nevermind */
    CALayer *topBorder = [CALayer layer];
    topBorder.borderColor = [UIColor darkGrayColor].CGColor;
    topBorder.borderWidth = 1;
    topBorder.frame = CGRectMake(-1, -1, self.overlay.frame.size.width+2, self.overlay.frame.size.height+2);
    
    [self.overlay.layer addSublayer:topBorder];
    //self.overlay.layer.shouldRasterize = YES;
    
    
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //return the number of venue images
    return [images count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    CrowdItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    /*SHADOW AROUND OBJECTS*/
    item.layer.masksToBounds = NO;
    item.layer.borderColor = [UIColor grayColor].CGColor;
    item.layer.borderWidth = 1.5f;
    item.layer.contentsScale = [UIScreen mainScreen].scale;
    item.layer.shadowOpacity = 0.5f;
    item.layer.shadowRadius = 3.0f;
    item.layer.shadowOffset = CGSizeZero;
    item.layer.shadowPath = [UIBezierPath bezierPathWithRect:item.bounds].CGPath;
    //item.layer.shouldRasterize = YES;
    
    /* Here we can set the elements of the crowdItem (the cell) in the cellview */
    
    [[item crowdImage]setImage:[UIImage imageNamed:[images objectAtIndex:indexPath.item]]];
    [[item venueName]setText:[venueNames objectAtIndex:indexPath.item]];
    
    

    return item;



}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ToVenueSite"]) {
        [segue.destinationViewController setTitle:[venueNames objectAtIndex:selectedVenue]];
    }
}

- (void)collectionView:(UICollectionView *)collectionView
didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    selectedVenue = indexPath.row;
}

- (void)createTitleButton{
    /*
    //Setup the custom middle buttons 
    //------------------------------ 
    // Euurgh this changes every headline in this navigation!
    //------------------------------
    UIView *container = [[UIView alloc] init];
    container.frame = CGRectMake(0, 0, 80, 44);
    // create a button and add it to the container
    UIButton *notificationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    notificationButton.frame = CGRectMake(0, 0, 35, 44);
    notificationButton.backgroundColor = [UIColor redColor];
    [container addSubview:notificationButton];
    // Set the titleView to the container view
    [self.navigationItem setTitleView:container];
    */
}

- (IBAction)tapMap:(id)sender {
    if(crowdImagesHidden){
        [self showOverlay];
    }else{
        [self hideOverlay];
    }
}

- (IBAction)tapTitle:(id)sender {
    NSLog(@"tapTitle run from ViewController");
    if(dropDownHidden){
    [[self dropDownMenu] showAnimated:0 animationDelay:0 animationDuration:0.5];
        dropDownIndicator.highlighted = YES;
        dropDownHidden = NO;
    }else {
        [[self dropDownMenu] hideAnimated:0 animationDuration:0.5 targetSize:-280 contentView:[self dropDownMenu]];
        dropDownIndicator.highlighted = NO;
        dropDownHidden = YES;
    }
}

-(void)showOverlay {

    [[self overlay] showAnimated:126 animationDelay:0.2 animationDuration:0.5];

    crowdImagesHidden = NO;
}

-(void)hideOverlay {
    [[self overlay] hideAnimated:126 animationDuration:0.5 targetSize:300 contentView:[self overlay]];
    crowdImagesHidden = YES;
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    NSLog(@"Scrolled to top");
    return YES;
}

@end

//
//  VenueViewController.m
//  Consumer App
//
//  Created by Stian Johansen on 3/22/13.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "VenueViewController.h"
#import "CrowdItem.h"

@interface VenueViewController ()
{
    NSArray *venueNames;
    NSArray *images;
    NSInteger selectedVenue;
    BOOL textViewOpen;
    
    //Scrollhide
    CGFloat startContentOffset;
    CGFloat lastContentOffset;
    BOOL hidden;
}

@end

@implementation VenueViewController

@synthesize navBar;
@synthesize overlayView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    self.navBar.title = title;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    textViewOpen = false;
    [[self crowdCollectionV]setDataSource:self];
    [[self crowdCollectionV]setDelegate:self];
    
    images = [[NSArray alloc] initWithObjects:@"liverpool.JPG", @"liverpool2.jpg", @"mahiki.jpg",@"liverpool.JPG", @"liverpool2.jpg", @"mahiki.jpg",@"liverpool.JPG", @"liverpool2.jpg", @"mahiki.jpg",@"liverpool2.jpg", @"mahiki.jpg",@"liverpool2.jpg", @"mahiki.jpg",@"liverpool2.jpg", @"mahiki.jpg",@"liverpool.JPG", @"liverpool2.jpg", @"mahiki.jpg",@"liverpool.JPG", @"liverpool2.jpg", @"mahiki.jpg",@"liverpool.JPG", @"liverpool2.jpg", @"mahiki.jpg",@"liverpool2.jpg", @"mahiki.jpg",@"liverpool2.jpg", @"mahiki.jpg",@"liverpool2.jpg", @"mahiki.jpg",nil];
    venueNames = [[NSArray alloc] initWithObjects:@"liverpool street station",@"liverpool street station",@"mahiki",@"liverpool street station",@"liverpool street station",@"mahiki",@"liverpool street station",@"liverpool street station",@"mahiki",@"liverpool street station",@"mahiki",@"liverpool street station",@"mahiki",@"liverpool street station",@"mahiki",@"liverpool street station",@"liverpool street station",@"mahiki",@"liverpool street station",@"liverpool street station",@"mahiki",@"liverpool street station",@"liverpool street station",@"mahiki",@"liverpool street station",@"mahiki",@"liverpool street station",@"mahiki",@"liverpool street station",@"mahiki", nil];

    [self displayTextView];
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
    /* Here we can set the elements of the crowdItem (the cell) in the cellview */
    [[item crowdImage]setImage:[UIImage imageNamed:[images objectAtIndex:indexPath.item]]];
    [[item venueName]setText:[venueNames objectAtIndex:indexPath.item]];
    
    return item;
    
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)displayTextView {
    if(!textViewOpen){
        overlayView = [[[NSBundle mainBundle] loadNibNamed:@"overlayText" owner:self options:nil] objectAtIndex:0];
        overlayView.backgroundColor = [UIColor whiteColor];
        //[overlayView addSubview:label]; // label declared elsewhere
        //[overlayView addSubview:backgroundImage]; // backgroundImage declared elsewhere
        //... Add a bunch of other controls
        
        //... Release a bunch of other controls
        
        [self.view addSubview:overlayView];
        textViewOpen = true;
    }
}


// SCROLLHIDE
-(void)hideOverlay
{
    if(hidden)
        return;
    
    hidden = YES;
    
    [self.overlayView setTabBarHidden:YES
                                  animated:YES];
    
    [self.navigationController setNavigationBarHidden:YES
                                             animated:YES];
}

-(void)showOverlay
{
    if(!hidden)
        return;
    
    hidden = NO;
    
    [self.overlayView setTabBarHidden:NO
                                  animated:YES];
    
    [self.navigationController setNavigationBarHidden:NO
                                             animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    startContentOffset = lastContentOffset = scrollView.contentOffset.y;
    //NSLog(@"scrollViewWillBeginDragging: %f", scrollView.contentOffset.y);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat currentOffset = scrollView.contentOffset.y;
    CGFloat differenceFromStart = startContentOffset - currentOffset;
    CGFloat differenceFromLast = lastContentOffset - currentOffset;
    lastContentOffset = currentOffset;
    
    
    
    if((differenceFromStart) < 0)
    {
        // scroll up
        if(scrollView.isTracking && (abs(differenceFromLast)>1))
            [self hideOverlay];
    }
    else {
        if(scrollView.isTracking && (abs(differenceFromLast)>1))
            [self showOverlay];
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    [self showOverlay];
    return YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:hidden
                                             animated:YES];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.overlayView setTabBarHidden:hidden
                                  animated:NO];
}

@end

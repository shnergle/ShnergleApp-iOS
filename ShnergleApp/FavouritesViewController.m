//
//  FavouritesViewController.m
//  ShnergleApp
//
//  Created by Stian Johansen on 06/06/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "FavouritesViewController.h"
#import "MenuViewController.h"
#import "CrowdItem.h"
#import "AppDelegate.h"

@implementation FavouritesViewController {
    NSInteger selectedVenue;
}

- (void)decorateCheckInButton {
    //check in button
    [self.checkInButton setTitleTextAttributes:
     @{UITextAttributeTextColor: [UIColor whiteColor],
                UITextAttributeTextShadowColor: [UIColor clearColor],
               UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 0)],
                           UITextAttributeFont: [UIFont fontWithName:@"Roboto" size:14.0]}
                                      forState:UIControlStateNormal];
}


- (UIBarButtonItem *)createLeftBarButton:(NSString *)imageName actionSelector:(SEL)actionSelector {
    UIImage *menuButtonImg = [UIImage imageNamed:imageName];
    
    UIButton *menuButtonTmp = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButtonTmp.frame = CGRectMake(280.0, 10.0, 22.0, 22.0);
    [menuButtonTmp setBackgroundImage:menuButtonImg forState:UIControlStateNormal];
    [menuButtonTmp addTarget:self action:actionSelector forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc]initWithCustomView:menuButtonTmp];
    return menuButton;
}

- (void)menuButtonDecorations {
    SEL actionSelector = @selector(tapMenu);
    NSString *imageName = @"mainmenu_button.png";
    
    
    UIBarButtonItem *menuButton;
    menuButton = [self createLeftBarButton:imageName actionSelector:actionSelector];
    
    
    self.navBarItem.leftBarButtonItem = menuButton;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    if (_type)
        ((UINavigationItem *) self.navBar.items[0]).title = _type;
    [self menuButtonDecorations];
    [self decorateCheckInButton];
    //THE SANDWICH MENU SYSTEM (ECSlidingViewController)
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"AroundMeMenu"];
    }
    
    [self.slidingViewController setAnchorRightRevealAmount:230.0f];
    
    // Shadow for sandwich system
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    //remove shadow from navbar
    self.navigationController.navigationBar.clipsToBounds = YES;
    self.navBar.clipsToBounds = YES;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)vewDidAppear{
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
}

- (IBAction)menuButtonTriggered:(id)sender {
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (void)tapMenu {
    NSLog(@"menu triggered from button");
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    return [appDelegate.images count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"FavCell";
    CrowdItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];

    /*SHADOW AROUND OBJECTS*/
    /*
     item.layer.masksToBounds = NO;
     item.layer.borderColor = [UIColor grayColor].CGColor;
     item.layer.borderWidth = 1.5f;
     item.layer.contentsScale = [UIScreen mainScreen].scale;
     item.layer.shadowOpacity = 0.5f;
     item.layer.shadowRadius = 3.0f;
     item.layer.shadowOffset = CGSizeZero;
     item.layer.shadowPath = [UIBezierPath bezierPathWithRect:item.bounds].CGPath;
     //item.layer.shouldRasterize = YES;
     */
    /* Here we can set the elements of the crowdItem (the cell) in the cellview */
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [[item crowdImage] setImage:[UIImage imageNamed:appDelegate.images[indexPath.item]]];

    [[item venueName] setText:appDelegate.venueNames[indexPath.item]];

    item.venueName.font = [UIFont fontWithName:@"Roboto" size:11.0f];

    item.venueName.textColor = [UIColor whiteColor];

    //Turn the indicator on or off:
    if([item.venueName.text isEqual: @"mahiki"]){ //just an example filter
        item.promotionIndicator.hidden = YES;
    }else{
        item.promotionIndicator.hidden = NO;
    }

    return item;
}

- (void)         collectionView:(UICollectionView *)collectionView
    didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    selectedVenue = indexPath.row;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if ([segue.identifier isEqualToString:@"ToVenueSite"]) {
        [segue.destinationViewController setTitle:appDelegate.venueNames[selectedVenue]];
    }
}

@end

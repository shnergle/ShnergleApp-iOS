//
//  OverlayText.m
//  ShnergleApp
//
//  Created by Stian Johansen on 3/28/13.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "OverlayText.h"
#import "VenueViewController.h"
#import "CheckInViewController.h"
#import "PostRequest.h"
#import <Toast+UIView.h>
#import "ShareViewController.h"

@implementation OverlayText

- (IBAction)share:(id)sender {
    UIViewController *caller = (UIViewController *)self.nextResponder.nextResponder;
    UIViewController *vc = [caller.storyboard instantiateViewControllerWithIdentifier:@"ShareViewController"];
    appDelegate.shareVenue = YES;
    [caller.navigationController pushViewController:vc animated:YES];
}

- (IBAction)analytics:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Nahhhh ...." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (IBAction)staff:(id)sender {
    UIViewController *caller = (UIViewController *)self.nextResponder.nextResponder;
    UIViewController *vc = [caller.storyboard instantiateViewControllerWithIdentifier:@"Staff"];
    [caller.navigationController pushViewController:vc animated:YES];
    return;
}

- (id)initWithFrame:(CGRect)frame {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;

    frame = CGRectMake(0, screenHeight - 80, self.frame.size.width, self.frame.size.height);
    self = [super initWithFrame:frame];
        
    
    if (self) {
        isUp = NO;
    }
    return self;
}

- (IBAction)swipeDown:(id)sender {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;

    [self hideAnimated:self.frame.origin.y animationDuration:0.5 targetSize:screenHeight - 160 contentView:self];
    isUp = NO;
}

- (IBAction)swipeUp:(id)sender {
    [self showAnimated:50 animationDelay:0.2 animationDuration:0.5];
    isUp = YES;
}

- (IBAction)tap:(id)sender {
    if (isUp) [self swipeDown:sender];
    else [self swipeUp:sender];
}

- (IBAction)tappedGoing:(id)sender {
    int oldValue = [self.goingLabel.text intValue];
    int newValue = oldValue + 1;
    [self.goingLabel setFont:[UIFont fontWithName:self.goingLabel.font.fontName size:self.goingLabel.font.pointSize]];
    [self.goingLabel setText:[@(newValue) stringValue]];
    [self.goingLabel setTextAlignment:NSTextAlignmentCenter];
    [self.tapGoing setEnabled:NO];
    [self.thinkingView setEnabled:NO];
    [self.goingView setEnabled:NO];
}

- (IBAction)tappedThinking:(id)sender {
    int oldValue = [self.thinkingLabel.text intValue];
    int newValue = oldValue + 1;
    [self.thinkingLabel setFont:[UIFont fontWithName:self.thinkingLabel.font.fontName size:self.thinkingLabel.font.pointSize]];
    [self.thinkingLabel setText:[@(newValue) stringValue]];
    [self.thinkingView setEnabled:NO];
    [self.thinkingLabel setTextAlignment:NSTextAlignmentCenter];
}

- (IBAction)tappedCheckedIn:(id)sender {
    UIViewController *caller = (UIViewController *)self.nextResponder.nextResponder;

    UIStoryboard *storyb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UIViewController *vc = [storyb instantiateViewControllerWithIdentifier:@"CheckInViewController"];

    [caller.navigationController pushViewController:vc animated:YES];
}

- (IBAction)publishTapped:(id)sender {
    [self.summaryContentTextField resignFirstResponder];
    [self.summaryContentTextField setEditable:NO];
    [self.summaryContentTextField setBackgroundColor:[UIColor clearColor]];
    [self.summaryHeadlineTextField resignFirstResponder];
    [self.summaryHeadlineTextField setEnabled:NO];
    [self.summaryHeadlineTextField setBackgroundColor:[UIColor clearColor]];

    [self.publishButton setHidden:YES];

    self.summaryContentTextField.layer.borderWidth = 0.0f;
    self.summaryHeadlineTextField.layer.borderWidth = 0.0f;
    self.summaryHeadlineTextField.layer.cornerRadius = 0.0f;
    self.summaryContentTextField.layer.cornerRadius = 0.0f;

    [[[PostRequest alloc] init] exec:@"venues/set"
                              params:[NSString stringWithFormat:
                                      @"venue_id=%@&tonight=%@",
                                      appDelegate.activeVenue[@"id"],
                                      self.summaryContentTextField.text] delegate:self
                            callback:@selector(doNothing:)
                                type:@"string"];
}

- (void)doNothing:(id)sender {
}

- (IBAction)postUpdateTapped:(id)sender {
    [self.summaryContentTextField setBackgroundColor:[UIColor whiteColor]];
    [self.summaryHeadlineTextField setBackgroundColor:[UIColor whiteColor]];
    [self.publishButton setHidden:NO];
    self.summaryContentTextField.editable = YES;
    [self.summaryHeadlineTextField setEnabled:YES];
    [self.summaryContentTextField becomeFirstResponder];
    self.summaryHeadlineTextField.layer.borderColor = [[UIColor grayColor] CGColor];
    self.summaryContentTextField.layer.borderColor = [[UIColor grayColor] CGColor];
    self.summaryContentTextField.layer.borderWidth = 1.0f;
    self.summaryHeadlineTextField.layer.borderWidth = 1.0f;
    self.summaryHeadlineTextField.layer.cornerRadius = 5.0f;
    self.summaryContentTextField.layer.cornerRadius = 5.0f;
    self.summaryHeadlineTextField.layer.masksToBounds = YES;
    self.summaryContentTextField.layer.masksToBounds = YES;
}

- (void)hideAnimated:(NSInteger)originalSize animationDuration:(double)animationDuration targetSize:(NSInteger)targetSize contentView:(UIView *)contentView {
    self.frame = CGRectMake(self.bounds.origin.x,
                            originalSize,
                            self.bounds.size.width,
                            self.bounds.size.height);

    [UIView animateWithDuration:animationDuration
                     animations:^{
        self.frame = CGRectMake(self.bounds.origin.x,
                                targetSize,
                                self.bounds.size.width,
                                self.bounds.size.height);
    }   completion:^(BOOL finished) {
        contentView.frame = CGRectMake(self.bounds.origin.x,
                                       targetSize,
                                       self.bounds.size.width,
                                       self.bounds.size.height);
    }];
}

- (void)showAnimated:(NSInteger)targetSize animationDelay:(double)animationDelay animationDuration:(double)animationDuration {
    [UIView animateWithDuration:animationDuration delay:animationDelay options:(UIViewAnimationOptions)UIViewAnimationCurveEaseOut
                     animations:^{
        self.frame = CGRectMake(self.bounds.origin.x,
                                targetSize,
                                self.bounds.size.width,
                                self.bounds.size.height);
    }

                     completion:^(BOOL finished) {
        self.frame = CGRectMake(self.bounds.origin.x,
                                targetSize,
                                self.bounds.size.width,
                                self.bounds.size.height);
    }];
}

- (void)setTabBarHidden:(BOOL)hide animated:(BOOL)animated {
    if ([self.subviews count] < 2) return;

    UIView *contentView;

    contentView = self;

    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;

    if (hide) {
        NSInteger targetSize = screenHeight - 160;
        double animationDuration = 0.5;
        double animationDelay = 0.2;

        [self showAnimated:targetSize animationDelay:animationDelay animationDuration:animationDuration];
    } else {
        NSInteger targetSize = screenHeight - 160;
        NSInteger originalSize = screenHeight - 70;

        [self hideAnimated:originalSize animationDuration:0.5 targetSize:targetSize contentView:contentView];
    }
}

- (IBAction)tapPromotion:(id)sender {
    VenueViewController *parentVC = (VenueViewController *)self.nextResponder.nextResponder;
    [parentVC goToPromotionView];
}

- (IBAction)tapPullerMenu:(id)sender {
    if (isUp) [self swipeDown:sender];
    else [self swipeUp:sender];
}

- (void)didAppear {
    
    self.promotionImage.hidden = YES;
    self.promotionHeadline.hidden = YES;
    self.promotionContents.hidden = YES;
    self.promotionCount.hidden = YES;
    self.claimVenueButton.hidden = YES;
    self.summaryContentTextField.hidden = YES;
    self.summaryHeadlineTextField.hidden = YES;
    self.postUpdateButton.hidden = YES;
    self.publishButton.hidden = YES;
    
    
    if([appDelegate.activeVenue[@"verified"] intValue] == 1)
    {
        self.promotionImage.hidden = NO;
        self.promotionHeadline.hidden = NO;
        self.promotionContents.hidden = NO;
        self.promotionCount.hidden = NO;
        self.claimVenueButton.hidden = YES;
        self.summaryContentTextField.hidden = NO;
        self.summaryHeadlineTextField.hidden = NO;
        self.postUpdateButton.hidden = YES;
        self.publishButton.hidden = YES;
    }else if([appDelegate.activeVenue[@"official"] intValue] == 0)
    {
        self.claimVenueButton.hidden = NO;
        
    }else if([appDelegate.activeVenue[@"official"] intValue] == 1)
    {
        self.intentionHeightConstraints.constant = -10;
    }

    
    if (appDelegate.venueStatus == Manager && [appDelegate.activeVenue[@"verified"] intValue] == 1) {
        self.postUpdateButton.hidden = NO;
        self.analyticsButton.hidden = NO;

        self.staffButton.hidden = NO;
        self.analyticsImage.hidden = NO;
        self.analyticsLabel.hidden = NO;

        self.staffImage.hidden = NO;
        self.staffLabel.hidden = NO;
    } else if(appDelegate.venueStatus == Staff && [appDelegate.activeVenue[@"verified"] intValue] == 1){
        self.analyticsButton.hidden = NO;
        self.analyticsImage.hidden = NO;
        self.analyticsLabel.hidden = NO;
        self.analyticsShareConstraints.constant = -40;
        self.staffButton.hidden = YES;
        self.staffImage.hidden = YES;
        self.staffLabel.hidden = YES;
    }else{
        self.analyticsButton.hidden = YES;
        self.staffButton.hidden = YES;
        self.analyticsImage.hidden = YES;
        self.analyticsLabel.hidden = YES;
        self.staffImage.hidden = YES;
        self.staffLabel.hidden = YES;
    }
}

- (IBAction)tappedClaimVenue:(id)sender {
    NSLog(@"%@",appDelegate.activeVenue[@"id"]);
    [[[PostRequest alloc]init]exec:@"venue_managers/set" params:[NSString stringWithFormat:@"venue_id=%@",appDelegate.activeVenue[@"id"]] delegate:self callback:@selector(doNothing:)];
    
}
@end

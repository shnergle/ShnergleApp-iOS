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

@implementation OverlayText

- (IBAction)share:(id)sender {
    UIViewController *caller = (UIViewController *)self.nextResponder.nextResponder;
    if (appDelegate.venueStatus == Manager) {
        UIViewController *vc = [caller.storyboard instantiateViewControllerWithIdentifier:@"Staff"];
        [caller.navigationController pushViewController:vc animated:YES];
        return;
    } else if (appDelegate.venueStatus == Staff) {
        UIViewController *vc = [caller.storyboard instantiateViewControllerWithIdentifier:@"viewconid"];
        [caller.navigationController pushViewController:vc animated:YES];
        return;
    }

    UIViewController *vc = [caller.storyboard instantiateViewControllerWithIdentifier:@"ShareViewController"];
    [caller.navigationController pushViewController:vc animated:YES];
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
    [self.goingLabel setText:[NSString stringWithFormat:@"%d", newValue]];
    [self.goingLabel setTextAlignment:NSTextAlignmentCenter];
    [self.tapGoing setEnabled:NO];
    [self.thinkingView setEnabled:NO];
    [self.goingView setEnabled:NO];
}

- (IBAction)tappedThinking:(id)sender {
    int oldValue = [self.thinkingLabel.text intValue];
    int newValue = oldValue + 1;
    [self.thinkingLabel setFont:[UIFont fontWithName:self.thinkingLabel.font.fontName size:self.thinkingLabel.font.pointSize]];
    [self.thinkingLabel setText:[NSString stringWithFormat:@"%d", newValue]];
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
                                  @"facebook_id=%@&venue_id=%@&tonight=%@",
                                  appDelegate.facebookId,
                                  appDelegate.activeVenue[@"id"],
                                  self.summaryContentTextField.text] delegate:self
                                    callback:@selector(doNothing:)
                                    type:@"string"];
}

-(void)doNothing:(id)sender
{
    NSLog(@"Update sent to server.. Swwoooosh!");
}


- (IBAction)postUpdateTapped:(id)sender {
    [self.summaryContentTextField setBackgroundColor:[UIColor whiteColor]];
    [self.summaryHeadlineTextField setBackgroundColor:[UIColor whiteColor]];
    [_publishButton setHidden:NO];
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
    if (appDelegate.venueStatus == Manager) {
        [_shareButton setBackgroundImage:[UIImage imageNamed:@"stafficon.png"] forState:UIControlStateNormal];
        _postUpdateButton.hidden = NO;
    }
}

@end

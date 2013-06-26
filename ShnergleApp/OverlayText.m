//
//  OverlayText.m
//  ShnergleApp
//
//  Created by Stian Johansen on 3/28/13.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "OverlayText.h"
#import "VenueViewController.h"
#import "AppDelegate.h"
#import "CheckInViewController.h"

@implementation OverlayText

- (IBAction)share:(id)sender {
    UIViewController *caller = (UIViewController *)self.nextResponder.nextResponder;
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
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

/* Only override drawRect: if you perform custom drawing.
   // An empty implementation adversely affects performance during animation.
   - (void)drawRect:(CGRect)rect
   {
   //self.frame = CGRectMake(self.frame.origin.x, 250, self.frame.size.width, self.frame.size.height);
   }*/


- (IBAction)swipeDown:(id)sender {
    //[self setTabBarHidden:false animated:true];
    /*if the box is already swiped down, ignore
       if(self.frame.origin.y > 200){

       }else if(self.frame.origin.y < 200){
       self.frame = CGRectMake(self.frame.origin.x, 200, self.frame.size.width, self.frame.size.height);
       }else{
       self.frame = CGRectMake(self.frame.origin.x, 390, self.frame.size.width, self.frame.size.height);
       }
     */
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;

    [self hideAnimated:self.frame.origin.y animationDuration:0.5 targetSize:screenHeight - 160 contentView:self];
    isUp = NO;
}

- (IBAction)swipeUp:(id)sender {
    //[self setTabBarHidden:true animated:true];
    [self showAnimated:50 animationDelay:0.2 animationDuration:0.5];
    isUp = YES;
}

- (IBAction)tap:(id)sender {
    if (isUp) [self swipeDown:sender];
    else [self swipeUp:sender];
}

- (IBAction)tappedGoing:(id)sender {
    NSLog(@"tappedGoing");
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
    NSLog(@"tapped Thinking");
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
    [self.tonightContent resignFirstResponder];
    [self.tonightContent setEditable:NO];
    [self.tonightContent setBackgroundColor:[UIColor clearColor]];
    [self.tonightHeadline resignFirstResponder];
    [self.tonightHeadline setEnabled:NO];
    [self.tonightHeadline setBackgroundColor:[UIColor clearColor]];

    [self.publishButton setHidden:YES];
    
    self.tonightContent.layer.borderWidth = 0.0f;
    self.tonightHeadline.layer.borderWidth = 0.0f;
    self.tonightHeadline.layer.cornerRadius = 0.0f;
    self.tonightContent.layer.cornerRadius = 0.0f;
    
}

- (IBAction)postUpdateTapped:(id)sender {
    [self.tonightContent setBackgroundColor:[UIColor whiteColor]];
    [self.tonightHeadline setBackgroundColor:[UIColor whiteColor]];
    [_publishButton setHidden:NO];
    self.tonightContent.editable = YES;
    [self.tonightHeadline setEnabled:YES];
    [self.tonightContent becomeFirstResponder];
#warning "Formatting for input fields borders must be reset when exiting edit mode"
    self.tonightHeadline.layer.borderColor = [[UIColor grayColor] CGColor];
    self.tonightContent.layer.borderColor = [[UIColor grayColor] CGColor];
    self.tonightContent.layer.borderWidth = 1.0f;
    self.tonightHeadline.layer.borderWidth = 1.0f;
    self.tonightHeadline.layer.cornerRadius = 5.0f;
    self.tonightContent.layer.cornerRadius = 5.0f;
    self.tonightHeadline.layer.masksToBounds = YES;
    self.tonightContent.layer.masksToBounds = YES;
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
        //contentView.frame = self.bounds;

        self.frame = CGRectMake(self.bounds.origin.x,
                                targetSize,
                                self.bounds.size.width,
                                self.bounds.size.height /*TABBAR_HEIGHT*/);
    }

                     completion:^(BOOL finished) {
        self.frame = CGRectMake(self.bounds.origin.x,
                                targetSize,
                                self.bounds.size.width,
                                self.bounds.size.height /*TABBAR_HEIGHT*/);
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
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if (appDelegate.venueStatus == Manager) {
        [_shareButton setBackgroundImage:[UIImage imageNamed:@"stafficon.png"] forState:UIControlStateNormal];
        _postUpdateButton.hidden = NO;
    }
}
/*
- (UIColor *)darkerColourForColour:(UIColor *)c
{
    float r, g, b, a;
    if ([c getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MAX(r - 0.1, 0.0)
                               green:MAX(g - 0.1, 0.0)
                                blue:MAX(b - 0.1, 0.0)
                               alpha:0.2];
    return nil;
}
*/
@end

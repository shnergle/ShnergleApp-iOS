//
//  OverlayText.m
//  ShnergleApp
//
//  Created by Stian Johansen on 3/28/13.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "OverlayText.h"
#import "Request.h"
#import "VenueViewController.h"
#import <Toast+UIView.h>
#import <QuartzCore/QuartzCore.h>
#import <CMMapLauncher/CMMapLauncher.h>
#import <FlurrySDK/Flurry.h>

@implementation OverlayText

- (IBAction)tappedNavigation:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"How do you want to navigate?" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    for (int i = CMMapAppAppleMaps; i <= CMMapAppWaze; i++) {
        if ([CMMapLauncher isMapAppInstalled:i]) [alert addButtonWithTitle:[self mapAppToString:i]];
    }
    [alert show];
    [Flurry logEvent:@"Tapped navigation icon on overlay"];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) [CMMapLauncher launchMapApp:[self stringToMapApp:[alertView buttonTitleAtIndex:buttonIndex]] forDirectionsTo:[CMMapPoint mapPointWithName:appDelegate.activeVenue[@"name"] coordinate:CLLocationCoordinate2DMake([appDelegate.activeVenue[@"lat"] doubleValue], [appDelegate.activeVenue[@"lon"] doubleValue])]];
}

- (NSString *)mapAppToString:(CMMapApp)mapApp {
    switch (mapApp) {
        case CMMapAppAppleMaps:
            return @"Apple Maps";
        case CMMapAppCitymapper:
            return @"Citymapper";
        case CMMapAppGoogleMaps:
            return @"Google Maps";
        case CMMapAppNavigon:
            return @"Navigon";
        case CMMapAppTheTransitApp:
            return @"The Transit App";
        case CMMapAppWaze:
            return @"Waze";
        default:
            return @"";
    }
}

- (CMMapApp)stringToMapApp:(NSString *)string {
    if (!string) return 0;
    if ([string isEqualToString:@"Apple Maps"]) return CMMapAppAppleMaps;
    if ([string isEqualToString:@"Citymapper"]) return CMMapAppCitymapper;
    if ([string isEqualToString:@"Google Maps"]) return CMMapAppGoogleMaps;
    if ([string isEqualToString:@"Navigon"]) return CMMapAppNavigon;
    if ([string isEqualToString:@"The Transit App"]) return CMMapAppTheTransitApp;
    if ([string isEqualToString:@"Waze"]) return CMMapAppWaze;
    return 0;
}

- (IBAction)share:(id)sender {
    if (![Request getImage:@{@"entity": @"image", @"entity_id": @"toShare"}]) return;
    UIViewController *caller = (UIViewController *)self.nextResponder.nextResponder;
    UIViewController *vc = [caller.storyboard instantiateViewControllerWithIdentifier:@"ShareViewController"];
    appDelegate.shareVenue = YES;
    appDelegate.shnergleThis = NO;
    [caller.navigationController pushViewController:vc animated:YES];
}

- (IBAction)analytics:(id)sender {
    if (appDelegate.employee) {
        UIViewController *caller = (UIViewController *)self.nextResponder.nextResponder;
        UIViewController *vc = [caller.storyboard instantiateViewControllerWithIdentifier:@"Analytics"];
        [caller.navigationController pushViewController:vc animated:YES];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Visitor analytics for venue managers and staff will be implemented soon; please check the app store regularly for updates" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    [Flurry logEvent:@"Tapped analytics"];
}

- (IBAction)staff:(id)sender {
    UIViewController *caller = (UIViewController *)self.nextResponder.nextResponder;
    UIViewController *vc = [caller.storyboard instantiateViewControllerWithIdentifier:@"Staff"];
    [caller.navigationController pushViewController:vc animated:YES];
}

- (id)initWithFrame:(CGRect)frame {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;

    frame = CGRectMake(0, screenHeight - 80, self.frame.size.width, self.frame.size.height);
    self = [super initWithFrame:frame];
    return self;
}

- (IBAction)swipeDown:(id)sender {
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;

    [self hideAnimated:self.frame.origin.y animationDuration:0.5 targetSize:screenHeight - 96 contentView:self];
}

- (IBAction)swipeUp:(id)sender {
    [self showAnimated:139 animationDelay:0.2 animationDuration:0.5];
    [Flurry logEvent:@"Venue slider up"];
}

- (IBAction)publishTapped:(id)sender {
    [self.summaryContentTextField resignFirstResponder];
    self.summaryContentTextField.editable = NO;
    self.summaryContentTextField.backgroundColor = [UIColor clearColor];
    [self.summaryHeadlineTextField resignFirstResponder];
    self.summaryHeadlineTextField.enabled = NO;
    self.summaryHeadlineTextField.backgroundColor = [UIColor clearColor];
    self.phoneTextField.editable = NO;
    self.phoneTextField.backgroundColor = [UIColor clearColor];
    self.emailTextField.editable = NO;
    self.emailTextField.backgroundColor = [UIColor clearColor];
    self.websiteTextField.editable = NO;
    self.websiteTextField.backgroundColor = [UIColor clearColor];


    self.publishButton.hidden = YES;
    self.Done.hidden = YES;
    self.Change.hidden = NO;

    self.summaryContentTextField.layer.borderWidth = 0.0f;
    self.summaryHeadlineTextField.layer.borderWidth = 0.0f;
    self.summaryHeadlineTextField.layer.cornerRadius = 0.0f;
    self.summaryContentTextField.layer.cornerRadius = 0.0f;
    self.phoneTextField.layer.borderWidth = 0.0f;
    self.websiteTextField.layer.borderWidth = 0.0f;
    self.emailTextField.layer.borderWidth = 0.0f;

    NSDictionary *params = @{@"venue_id": appDelegate.activeVenue[@"id"],
                             @"tonight": self.summaryContentTextField.text,
                             @"headline": self.summaryHeadlineTextField.text,
                             @"phone": self.phoneTextField.text,
                             @"website": self.websiteTextField.text,
                             @"email": self.emailTextField.text};
    [Request post:@"venues/set" params:params callback:nil];
}

- (IBAction)postUpdateTapped:(id)sender {
    self.summaryContentTextField.backgroundColor = [UIColor whiteColor];
    self.summaryHeadlineTextField.backgroundColor = [UIColor whiteColor];
    self.publishButton.hidden = NO;
    self.Done.hidden = NO;
    self.Change.hidden = YES;
    self.summaryContentTextField.editable = YES;
    self.summaryHeadlineTextField.enabled = YES;
    self.phoneTextField.editable = YES;
    self.phoneTextField.backgroundColor = [UIColor whiteColor];
    self.phoneTextField.layer.borderColor = [UIColor grayColor].CGColor;
    self.phoneTextField.layer.borderWidth = 1;
    self.phoneTextField.layer.cornerRadius = 5;
    self.websiteTextField.editable = YES;
    self.websiteTextField.backgroundColor = [UIColor whiteColor];
    self.websiteTextField.layer.borderColor = [UIColor grayColor].CGColor;
    self.websiteTextField.layer.borderWidth = 1;
    self.websiteTextField.layer.cornerRadius = 5;
    self.emailTextField.editable = YES;
    self.emailTextField.backgroundColor = [UIColor whiteColor];
    self.emailTextField.layer.borderColor = [UIColor grayColor].CGColor;
    self.emailTextField.layer.borderWidth = 1;
    self.emailTextField.layer.cornerRadius = 5;
    [self.summaryContentTextField becomeFirstResponder];
    self.summaryHeadlineTextField.layer.borderColor = [UIColor grayColor].CGColor;
    self.summaryContentTextField.layer.borderColor = [UIColor grayColor].CGColor;
    self.summaryContentTextField.layer.borderWidth = 1;
    self.summaryHeadlineTextField.layer.borderWidth = 1;
    self.summaryHeadlineTextField.layer.cornerRadius = 5;
    self.summaryContentTextField.layer.cornerRadius = 5;
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

- (IBAction)tapPromotion:(id)sender {
    VenueViewController *parentVC = (VenueViewController *)self.nextResponder.nextResponder;
    [parentVC goToPromotionView];
}

- (void)setContactDetails {
    self.phoneTextField.text = appDelegate.activeVenue[@"phone"];
    self.emailTextField.text = appDelegate.activeVenue[@"email"];
    self.websiteTextField.text = appDelegate.activeVenue[@"website"];
}

- (void)venueLayoutConfig {
    self.promotionImage.hidden = YES;
    self.promotionHeadline.hidden = YES;
    self.promotionContents.hidden = YES;
    self.promotionCount.hidden = YES;
    self.claimVenueButton.hidden = YES;
    self.summaryContentTextField.hidden = YES;
    self.summaryHeadlineTextField.hidden = YES;
    self.postUpdateButton.hidden = YES;
    self.publishButton.hidden = YES;
    self.emailTextField.hidden = YES;
    self.phoneTextField.hidden = YES;
    self.websiteTextField.hidden = YES;

    if ([appDelegate.activeVenue[@"verified"] integerValue] == 1) {
        self.promotionImage.hidden = NO;
        self.promotionHeadline.hidden = NO;
        self.promotionContents.hidden = NO;
        self.promotionCount.hidden = NO;
        self.claimVenueButton.hidden = YES;
        self.summaryContentTextField.hidden = NO;
        self.summaryHeadlineTextField.hidden = NO;
        self.postUpdateButton.hidden = YES;

        self.emailTextField.hidden = NO;
        self.phoneTextField.hidden = NO;
        self.websiteTextField.hidden = NO;
        [self setContactDetails];

        self.publishButton.hidden = YES;
    } else if ([appDelegate.activeVenue[@"official"] integerValue] == 0) {
        self.claimVenueButton.hidden = NO;
    }

    if (appDelegate.venueStatus == Manager && [appDelegate.activeVenue[@"verified"] integerValue] == 1) {
        self.postUpdateButton.hidden = NO;
        self.analyticsButton.hidden = NO;
        self.Change.hidden = NO;
        self.staffButton.hidden = NO;
        self.analyticsImage.hidden = NO;
        self.analyticsLabel.hidden = NO;
        self.staffImage.hidden = NO;
        self.staffLabel.hidden = NO;
    } else if (appDelegate.venueStatus == Staff && [appDelegate.activeVenue[@"verified"] integerValue] == 1) {
        self.analyticsButton.hidden = NO;
        self.analyticsImage.hidden = NO;
        self.analyticsLabel.hidden = NO;
        self.analyticsLeftConstraints.constant = 65;
        self.staffButton.hidden = YES;
        self.staffImage.hidden = YES;
        self.staffLabel.hidden = YES;
    } else {
        self.analyticsButton.hidden = YES;
        self.staffButton.hidden = YES;
        self.analyticsImage.hidden = YES;
        self.analyticsLabel.hidden = YES;
        self.staffImage.hidden = YES;
        self.staffLabel.hidden = YES;
        self.Change.hidden = YES;
    }
}

- (void)didAppear {
    [self venueLayoutConfig];
    if (appDelegate.venueDetailsContent) [self registerVenue];
    if ([[self.summaryContentTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] ] isEqual:@""] && [[self.summaryHeadlineTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqual:@""] && appDelegate.venueStatus == Manager) {
        self.summaryContentTextField.text = @"";
        self.summaryHeadlineTextField.text = @"Write Something...";
    }
}

- (IBAction)tappedClaimVenue:(id)sender {
    appDelegate.claiming = YES;
    UIViewController *vc = [((VenueViewController *)self.nextResponder.nextResponder).storyboard instantiateViewControllerWithIdentifier : @"VenueDetailsViewIdentifier"];
    [((UIViewController *)self.nextResponder.nextResponder).navigationController pushViewController : vc animated : YES];
}

- (void)registerVenue {
    NSMutableDictionary *params = [@{@"email_verified": @0, @"venue_id": appDelegate.activeVenue[@"id"]} mutableCopy];

    if (appDelegate.venueDetailsContent[@(8)]) {
        params[@"phone"] = appDelegate.venueDetailsContent[@(8)];
    }
    if (appDelegate.venueDetailsContent[@(9)]) {
        params[@"email"] = appDelegate.venueDetailsContent[@(9)];
    }
    if (appDelegate.venueDetailsContent[@(10)]) {
        params[@"website"] = appDelegate.venueDetailsContent[@(10)];
    }

    [Request post:@"venues/set" params:params callback:^(id response) {
        [Request post:@"venue_managers/set" params:@{@"venue_id": appDelegate.activeVenue[@"id"]} callback:^(id response) {
            [((VenueViewController *)self.nextResponder.nextResponder) reloadOverlay];
        }];
    }];
    
    appDelegate.venueDetailsContent = nil;
}

@end

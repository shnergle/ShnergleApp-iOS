//
//  ShareViewController.m
//  ShnergleApp
//
//  Created by Adam Hani Schakaki on 04/06/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "ShareViewController.h"
#import "Request.h"
#import <Toast/Toast+UIView.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "CustomSlidingViewController.h"
#import "ThankYouViewController.h"

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.image.image = [Request getImage:@{@"entity": @"image", @"entity_id": @"toShare"}];

    if (appDelegate.twitter != nil) {
        self.twSwitch.enabled = YES;
        self.twSwitch.on = appDelegate.lastTwitter;
    } else {
        self.twSwitch.enabled = NO;
        self.twSwitch.on = NO;
    }

    self.fbSwitch.on = appDelegate.lastFb;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBarHidden = NO;
    [self setRightBarButton:@"Upload" actionSelector:@selector(share)];
    if (appDelegate.shnergleThis) self.navigationItem.title = @"Check In";
    else self.navigationItem.title = @"Share";
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)share {
    if (!appDelegate.shnergleThis && !self.fbSwitch.on && !self.twSwitch.on) return;
    [self.view makeToastActivity];
    [NSThread detachNewThreadSelector:@selector(uploadToServer) toTarget:self withObject:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.view hideToastActivity];
}

- (void)uploadToServer {
    self.navigationItem.rightBarButtonItem.enabled = NO;
    if (appDelegate.shnergleThis) {
        [Request post:@"posts/set" params:@{@"venue_id": appDelegate.activeVenue[@"id"], @"caption": (self.textFieldname.text && [self.textFieldname.text isEqualToString:@"Write something..."]) ? @"" : self.textFieldname.text, @"image":self.image.image} callback:^(id response) {
            post_id = [response stringValue];
            [self shareSocial];
        }];
    } else {
        post_id = appDelegate.shareActivePostId;
        [self shareSocial];
    }
}

- (void)shareSocial {
    [self shareOnTwitter];
    if (self.fbSwitch.on && [[FBSession activeSession].permissions indexOfObject:@"publish_actions"] == NSNotFound)
        [[FBSession activeSession] requestNewPublishPermissions:@[@"publish_actions"] defaultAudience:FBSessionDefaultAudienceEveryone completionHandler:^(FBSession *session, NSError *error) {
            [self shareOnFacebook];
        }];
    else {
        [self shareOnFacebook];
    }
}

- (void)shareOnTwitter {
    appDelegate.lastTwitter = self.twSwitch.on;
    if (self.twSwitch.on) {
        NSString *venueName;
        if (![appDelegate.activeVenue[@"twitter"] isKindOfClass:[NSNull class]] && ![@"" isEqualToString : appDelegate.activeVenue[@"twitter"]]) {
            venueName = [(appDelegate.shnergleThis ? @"@" : @"From @") stringByAppendingString:appDelegate.activeVenue[@"twitter"]];
        } else {
            venueName = [(appDelegate.shnergleThis ? @"@ " : @"From ") stringByAppendingString:appDelegate.activeVenue[@"name"]];
        }
        [self postImage:self.image.image withStatus:[NSString stringWithFormat:@"%@ %@ #ShnergleIt", (self.textFieldname.text && [self.textFieldname.text isEqualToString:@"Write something..."]) ? ((![appDelegate.activeVenue[@"twitter"] isKindOfClass:[NSNull class]] && ![@"" isEqualToString : appDelegate.activeVenue[@"twitter"]]) ? @"." : @"") : self.textFieldname.text, venueName]];
        if (appDelegate.shareVenue) {
            [Request post:@"venue_shares/set" params:@{@"venue_id" : appDelegate.activeVenue[@"id"], @"media_id": @2} callback:nil];
        } else {
            [Request post:@"post_shares/set" params:@{@"post_id": post_id, @"media_id": @2} callback:nil];
        }
    }
}

- (void)shareOnFacebook {
    appDelegate.lastFb = self.fbSwitch.on;
    if (!self.fbSwitch.on) {
        [self redeem];
        return;
    }

    NSMutableDictionary<FBGraphObject> *action = [FBGraphObject graphObject];

    action[@"source"] = self.image.image;
    NSMutableString *friends = [NSMutableString stringWithString:@""];
    if ([selectedFriends count] > 0) {
        [friends appendFormat:@" with %@", selectedFriends[0][@"name"]];
        for (int i = 1; i < [selectedFriends count] - 1; i++) {
            [friends appendFormat:@", %@", selectedFriends[i][@"name"]];
        }
        if ([selectedFriends count] > 1) {
            [friends appendFormat:@" and %@", [selectedFriends lastObject][@"name"]];
        }
        [friends appendString:@"."];
    }
    NSString *venueName = [(appDelegate.shnergleThis ? @"@ " : @"From ") stringByAppendingString:appDelegate.activeVenue[@"name"]];
    action[@"message"] = [NSString stringWithFormat:@"%@ %@%@ #ShnergleIt", (self.textFieldname.text && [self.textFieldname.text isEqualToString:@"Write something..."]) ? @"" : self.textFieldname.text, venueName, friends];
    action[@"fb:explicitly_shared"] = @"true";
    [[[FBRequest alloc] initWithSession:[FBSession activeSession] graphPath:@"me/photos" parameters:action HTTPMethod:@"POST"] startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        [self redeem];
    }];
    if (appDelegate.shareVenue) {
        [Request post:@"venue_shares/set" params:@{@"venue_id": appDelegate.activeVenue[@"id"], @"media_id": @1} callback:nil];
    } else {
        [Request post:@"post_shares/set" params:@{@"post_id": post_id, @"media_id": @1} callback:nil];
    }
}

- (void)postImage:(UIImage *)image withStatus:(NSString *)status {
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];

    ACAccountType *twitterType =
        [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];

    SLRequestHandler requestHandler =
        ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
    };

    ACAccountStoreRequestAccessCompletionHandler accountStoreHandler =
        ^(BOOL granted, NSError *error) {
        if (granted) {
            NSArray *accounts = [accountStore accountsWithAccountType:twitterType];
            NSURL *url = [NSURL URLWithString:@"https://api.twitter.com"
                          @"/1.1/statuses/update_with_media.json"];
            NSDictionary *params = @{@"status": status};
            SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                    requestMethod:SLRequestMethodPOST
                                                              URL:url
                                                       parameters:params];
            NSData *imageData = UIImageJPEGRepresentation(image, 1.f);
            [request addMultipartData:imageData
                             withName:@"media[]"
                                 type:@"image/jpeg"
                             filename:@"image.jpg"];
            ACAccount *rightAccount;
            for (ACAccount *account in accounts) {
                if ([account.username isEqualToString:appDelegate.twitter]) {
                    rightAccount = account;
                    break;
                }
            }
            [request setAccount:rightAccount];
            [request performRequestWithHandler:requestHandler];
        }
    };

    [accountStore requestAccessToAccountsWithType:twitterType
                                          options:NULL
                                       completion:accountStoreHandler];
}

- (void)redeem {
    [Request post:@"users/set" params:@{@"last_facebook": appDelegate.lastFb ? @"true" : @"false", @"last_twitter": appDelegate.lastTwitter ? @"true" : @"false"} callback:nil];
    if (appDelegate.redeeming != nil) {
        [Request post:@"promotion_redemptions/set" params:@{@"promotion_id": appDelegate.redeeming} callback:^(id response) {
            NSString *msg;
            NSString *passcode = @"";
            if ([@"time" isEqualToString : response]) {
                msg = @"Bad Luck, you ran out of time to redeem the promotion.";
            } else if ([@"number" isEqualToString : response]) {
                msg = @"Bad Luck, you just missed the last promotion; someone beat you to it!";
            } else {
                msg = @"The passcode for the promotion is:";
                passcode = response;
            }
            
            [self thankYou:msg :passcode];
        }];
    } else {
        [self thankYou:@"" :@""];
    }
}

- (void)toFirstAroundMe {
    for (id viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[CustomSlidingViewController class]]) {
            [self.navigationController popToViewController:viewController animated:YES];
            return;
        }
    }
}

- (void)thankYou:(NSString *)msg :(NSString *)passcode {
    int pointsAwarded = 0;
    if (appDelegate.shnergleThis) pointsAwarded += 4;
    if (self.twSwitch.on) pointsAwarded += 5;
    if (self.fbSwitch.on) pointsAwarded += 5;
    ThankYouViewController *vc = (ThankYouViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"thankyouverymuch"];
    [vc setupFields:[NSString stringWithFormat:@"%d",pointsAwarded] : msg :passcode];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)selectFriendsButtonAction:(id)sender {
    FBFriendPickerViewController *friendPickerController =
        [[FBFriendPickerViewController alloc] init];
    friendPickerController.title = @"Select Friends";
    friendPickerController.delegate = self;

    [friendPickerController loadData];

    [self presentViewController:friendPickerController
                       animated:YES
                     completion:nil];
}

- (void)facebookViewControllerCancelWasPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)facebookViewControllerDoneWasPressed:(id)sender {
    FBFriendPickerViewController *fpc = (FBFriendPickerViewController *)sender;
    selectedFriends = fpc.selection;
    switch ([selectedFriends count]) {
        case 0:
            self.friendLabel.text = @"";
            break;
        case 1:
            self.friendLabel.text = [NSString stringWithFormat:@"With %@", [selectedFriends[0] name]];
            break;
        case 2:
            self.friendLabel.text = [NSString stringWithFormat:@"With %@ and %@", [selectedFriends[0] name], [selectedFriends[1] name]];
            break;
        case 3:
            self.friendLabel.text = [NSString stringWithFormat:@"With %@, %@ and %@", [selectedFriends[0] name], [selectedFriends[1] name], [selectedFriends[2] name]];
            break;
        default:
            self.friendLabel.text = [NSString stringWithFormat:@"With %@, %@ and %lu other", [selectedFriends[0] name], [selectedFriends[1] name], ((unsigned long)[selectedFriends count] - 2)];
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSUInteger newLength = [textView.text length] + [text length] - range.length;
    NSString *venueName;
    if (![appDelegate.activeVenue[@"twitter"] isKindOfClass:[NSNull class]] && ![@"" isEqualToString : appDelegate.activeVenue[@"twitter"]]) {
        venueName = [(appDelegate.shnergleThis ? @"@" : @"From @") stringByAppendingString:appDelegate.activeVenue[@"twitter"]];
    } else {
        venueName = [(appDelegate.shnergleThis ? @"@ " : @"From ") stringByAppendingString:appDelegate.activeVenue[@"name"]];
    }
    NSInteger maxLength = 140 - 50 - [venueName length];
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    if(newLength > maxLength){
        return NO;
    }else{
        self.counter.text = [NSString stringWithFormat:@"%lu characters left", (unsigned long)(maxLength - newLength)];
        return YES;
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"Write something..."]) {
        textView.text = nil;
        textView.textColor = [UIColor blackColor];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text == nil || [textView.text isEqualToString:@""]) {
        textView.text = @"Write something...";
        textView.textColor = [UIColor lightGrayColor];
    }
}


@end

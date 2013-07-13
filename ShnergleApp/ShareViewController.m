//
//  ShareViewController.m
//  ShnergleApp
//
//  Created by Adam Hani Schakaki on 04/06/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "ShareViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "PostRequest.h"
#import <Toast/Toast+UIView.h>

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.textFieldname.placeholder = @"Write something..";
    self.textFieldname.placeholderColor = [UIColor lightGrayColor];

    if (appDelegate.shareImage) self.image.image = appDelegate.shareImage;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setRightBarButton:@"Upload" actionSelector:@selector(share)];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)share {
    [self.view makeToastActivity];
    appDelegate.didShare = @YES;
    [self uploadToServer];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.view hideToastActivity];
}

- (void)uploadToServer {
    if (self.shnergleThis) {
        //Upload to Shnergle
        NSMutableString *postParams = [[NSMutableString alloc]initWithString:[NSString stringWithFormat:@"venue_id=%@", appDelegate.activeVenue[@"id"]]];
        [postParams appendFormat:@"&caption=%@", self.textFieldname.text];
        [[[PostRequest alloc]init]exec:@"posts/set" params:postParams delegate:self callback:@selector(didFinishPost:) type:@"string"];
    } else {
        post_id = appDelegate.shareActivePostId;
        //Share to Facebook
        if ([appDelegate.session.permissions indexOfObject:@"publish_actions"] == NSNotFound)
            [appDelegate.session requestNewPublishPermissions:@[@"publish_actions"] defaultAudience:FBSessionDefaultAudienceEveryone completionHandler:^(FBSession *session, NSError *error) {
                [self shareOnFacebook];
            }];
        else {
            [self shareOnFacebook];
        }
    }
}

- (void)didFinishPost:(NSString *)response {
    [[[PostRequest alloc] init] exec:@"images/set" params:[NSString stringWithFormat:@"entity=post&entity_id=%@", response] image:self.image.image delegate:self callback:@selector(uploadedToServer:) type:@"string"];

    post_id = response;

    //Share to Facebook
    if ([appDelegate.session.permissions indexOfObject:@"publish_actions"] == NSNotFound)
        [appDelegate.session requestNewPublishPermissions:@[@"publish_actions"] defaultAudience:FBSessionDefaultAudienceEveryone completionHandler:^(FBSession *session, NSError *error) {
            [self shareOnFacebook];
        }];
    else {
        [self shareOnFacebook];
    }
}

- (void)uploadedToServer:(NSString *)response {
    if ([response isEqual:@"true"]) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload failed!" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)shareOnFacebook {
    if (!self.fbSwitch.on) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }

    NSMutableDictionary<FBGraphObject> *action = [FBGraphObject graphObject];

    action[@"source"] = self.image.image;
    NSMutableString *friends = [NSMutableString stringWithFormat:@""];
    if ([selectedFriends count] > 0) {
        [friends appendString:@" with"];
        //[friends appendFormat:@" @[%@", selectedFriends[0][@"name"]];
        [friends appendFormat:@" @[100000519003410:adam.schakaki]"];
        for (int i = 1; i < [selectedFriends count] - 1; i++) {
            [friends appendFormat:@", %@", selectedFriends[i][@"name"]];
        }
        if ([selectedFriends count] > 1) {
            [friends appendString:@" and"];
        }
        [friends appendFormat:@" %@", selectedFriends[[selectedFriends count] - 1][@"name"]];
        [friends appendString:@"."];
    }
    action[@"message"] = [NSString stringWithFormat:@"%@ @%@%@", self.textFieldname.text, appDelegate.activeVenue[@"name"], friends];
    action[@"fb:explicitly_shared"] = @"true";
    //action[@"tags"] = selectedFriends;
    //action[@"place"] = @"http://samples.ogp.me/259837270824167";
    //action[@"tags"] = @[@"549445495",@"701732"];
    [[[FBRequest alloc] initWithSession:appDelegate.session graphPath:@"me/photos" parameters:action HTTPMethod:@"POST"] startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        /*NSMutableDictionary<FBGraphObject> *action = [FBGraphObject graphObject];
           action[@"venue"] = @"http://samples.ogp.me/259837270824167";
           if (action[@"tags"] != nil) action[@"tags"] = selectedFriends;
           if (action[@"message"] != nil) action[@"message"] = self.textFieldname.text;
           action[@"image"] = [NSString stringWithFormat:@"https://www.facebook.com/photo.php?fbid=%@", result[@"id"]];
           action[@"fb:explicitly_shared"] = @"true";
           [[[FBRequest alloc] initForPostWithSession:appDelegate.session graphPath:@"me/shnergle:share" graphObject:action] startWithCompletionHandler:^(FBRequestConnection *connection,
                                                                                                                                                       id result,
                                                                                                                                                       NSError *error) {

                [self.navigationController setNavigationBarHidden:YES animated:YES];
                //UIViewController *aroundMe = [self.storyboard instantiateViewControllerWithIdentifier:@"AroundMe"];
                //[self.navigationController pushViewController:aroundMe animated:YES];

            }];
         */


        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    if (appDelegate.shareVenue) {
        [[[PostRequest alloc]init]exec:@"venue_shares/set" params:[NSString stringWithFormat:@"venue_id=%@&media_id=1", appDelegate.activeVenue[@"id"]] delegate:self callback:@selector(doNothing:) type:@"string"];
    } else {
        [[[PostRequest alloc]init]exec:@"post_shares/set" params:[NSString stringWithFormat:@"post_id=%@&media_id=1", post_id] delegate:self callback:@selector(doNothing:) type:@"string"];
    }
}

- (void)doNothing:(id)response {
}

- (IBAction)selectFriendsButtonAction:(id)sender {
    FBFriendPickerViewController *friendPickerController =
        [[FBFriendPickerViewController alloc] init];
    friendPickerController.title = @"Select Friends";
    friendPickerController.delegate = self;
    friendPickerController.session = appDelegate.session;

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
            self.friendLabel.text = [NSString stringWithFormat:@"With %@, %@ and %d other", [selectedFriends[0] name], [selectedFriends[1] name], [selectedFriends count] - 2];
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end

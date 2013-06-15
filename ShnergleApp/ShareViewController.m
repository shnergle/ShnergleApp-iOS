//
//  ShareViewController.m
//  ShnergleApp
//
//  Created by Adam Hani Schakaki on 04/06/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "ShareViewController.h"
#import <FacebookSDK/FBFriendPickerViewController.h>
#import "AppDelegate.h"

@implementation ShareViewController


//@synthesize textFieldname;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.textFieldname.placeholder = @"Write something..";
    _textFieldname.placeholderColor = [UIColor lightGrayColor];

    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if (appDelegate.shareImage) _image.image = appDelegate.shareImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setRightBarButton:@"Upload" actionSelector:@selector(share)];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)share {
    self.navigationItem.rightBarButtonItem.enabled = NO;
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if ([appDelegate.session.permissions indexOfObject:@"publish_actions"] == NSNotFound)
        [appDelegate.session requestNewPublishPermissions:@[@"publish_actions"] defaultAudience:FBSessionDefaultAudienceEveryone completionHandler:^(FBSession *session, NSError *error) {
            [self shareOnFacebook];
        }];
    else [self shareOnFacebook];
}

- (void)shareOnFacebook {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSMutableDictionary<FBGraphObject> *action = [FBGraphObject graphObject];
    action[@"source"] = _image.image;
    action[@"message"] = @"caption";
    [[[FBRequest alloc] initWithSession:appDelegate.session graphPath:@"me/photos" parameters:action HTTPMethod:@"POST"] startWithCompletionHandler:^(FBRequestConnection *connection,
                                                                                                                                                   id result,
                                                                                                                                                   NSError *error) {
        NSLog(@"FBSHARE - PHOTO - connection: %@", connection);
        NSLog(@"FBSHARE - PHOTO - result: %@", result);
        NSLog(@"FBSHARE - PHOTO - error: %@", error);
        NSMutableDictionary<FBGraphObject> *action = [FBGraphObject graphObject];
        action[@"venue"] = @"http://samples.ogp.me/259837270824167";
        if (action[@"tags"] != nil) action[@"tags"] = selectedFriends;
        if (action[@"message"] != nil) action[@"message"] = _textFieldname.text;
        action[@"image"] = [NSString stringWithFormat:@"https://graph.facebook.com/%@", result[@"id"]];
        action[@"fb:explicitly_shared"] = @"true";
        [[[FBRequest alloc] initForPostWithSession:appDelegate.session graphPath:@"me/shnergle:share" graphObject:action] startWithCompletionHandler:^(FBRequestConnection *connection,
                                                                                                                                                       id result,
                                                                                                                                                       NSError *error) {
            NSLog(@"FBSHARE - POST - connection: %@", connection);
            NSLog(@"FBSHARE - POST - result: %@", result);
            NSLog(@"FBSHARE - POST - error: %@", error);
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            UIViewController *aroundMe = [self.storyboard instantiateViewControllerWithIdentifier:@"AroundMe"];
            [self.navigationController pushViewController:aroundMe animated:YES];
        }];

    }];
}

- (IBAction)selectFriendsButtonAction:(id)sender {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    // Initialize the friend picker
    FBFriendPickerViewController *friendPickerController =
        [[FBFriendPickerViewController alloc] init];

    // Configure the picker ...
    friendPickerController.title = @"Select Friends";
    // Set this view controller as the friend picker delegate
    friendPickerController.delegate = self;
    friendPickerController.session = appDelegate.session;

    // Fetch the data
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
            _friendLabel.text = @"";
            break;
        case 1:
            _friendLabel.text = [NSString stringWithFormat:@"With %@", [selectedFriends[0] name]];
            break;
        case 2:
            _friendLabel.text = [NSString stringWithFormat:@"With %@ and %@", [selectedFriends[0] name], [selectedFriends[1] name]];
            break;
        case 3:
            _friendLabel.text = [NSString stringWithFormat:@"With %@, %@ and %@", [selectedFriends[0] name], [selectedFriends[1] name], [selectedFriends[2] name]];
            break;
        default:
            _friendLabel.text = [NSString stringWithFormat:@"With %@, %@ and %d other", [selectedFriends[0] name], [selectedFriends[1] name], [selectedFriends count] - 2];
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

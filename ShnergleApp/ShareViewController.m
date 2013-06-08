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
    [self setRightBarButton:@"Share" actionSelector:@selector(share)];
}

- (void)share {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if ([appDelegate.session.permissions indexOfObject:@"publish_actions"] == NSNotFound)
        [appDelegate.session requestNewPublishPermissions:@[@"publish_actions"] defaultAudience:FBSessionDefaultAudienceEveryone completionHandler:^(FBSession *session, NSError *error) {
            [self shareOnFacebook];
        }];
    else [self shareOnFacebook];
}

- (void)shareOnFacebook {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSMutableDictionary<FBGraphObject> *data = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                @"http://www.shnergle.com/", @"link",
                                                @"https://developers.facebook.com/attachment/iossdk_logo.png", @"picture",
                                                @"Shnergle", @"name",
                                                @"Get the app!", @"caption",
                                                @"I share now? I share now!", @"description",
                                                nil];
    [[[FBRequest alloc] initForPostWithSession:appDelegate.session graphPath:@"me/feed" graphObject:data] startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        NSLog(@"FBSHARE - connection: %@", connection);
        NSLog(@"FBSHARE - result: %@", result);
        NSLog(@"FBSHARE - error: %@", error);
        [self.navigationController popToRootViewControllerAnimated:YES];
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

@end

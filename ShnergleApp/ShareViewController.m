//
//  ShareViewController.m
//  ShnergleApp
//
//  Created by Adam Hani Schakaki on 04/06/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "ShareViewController.h"
#import <FacebookSDK/FBFriendPickerViewController.h>

#import "PostRequest.h"

@implementation ShareViewController

#warning "implement a way of not re-shnergling"

- (void)viewDidLoad {
    [super viewDidLoad];

    self.textFieldname.placeholder = @"Write something..";
    _textFieldname.placeholderColor = [UIColor lightGrayColor];

    if (appDelegate.shareImage) _image.image = appDelegate.shareImage;

    self.saveLocallySwitch.on = appDelegate.saveLocally;
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
    [self.view makeToastActivity];
    appDelegate.didShare = @YES;
    [self uploadToServer];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.view hideToastActivity];
}

- (void)uploadToServer {
    //Create post
    //upload image using id from post (not now and not here)
    //register in the "shared" db if shared on facebook (not yet)

    NSMutableString *postParams = [[NSMutableString alloc]initWithString:[NSString stringWithFormat:@"venue_id=%@", appDelegate.activeVenue[@"id"]]];
    [postParams appendFormat:@"&caption=%@", _textFieldname.text];
    //Set lat/lon if specified in the image metadata
    [postParams appendFormat:@"&facebook_id=%@", appDelegate.facebookId];
    if (appDelegate.shareImageLat != nil && appDelegate.shareImageLon != nil) {
        [postParams appendFormat:@"&lat=%@", appDelegate.shareImageLat];
        [postParams appendFormat:@"&lon=%@", appDelegate.shareImageLon];
    }
    NSLog(@"%@", postParams);
    [[[PostRequest alloc]init]exec:@"posts/set" params:postParams delegate:self callback:@selector(didFinishPost:) type:@"string"];
}

- (void)didFinishPost:(NSString *)response {
    NSLog(@"%@", response);

    [[[PostRequest alloc] init] exec:@"images/set" params:[NSString stringWithFormat:@"entity=post&entity_id=%@&facebook_id=%@", response, appDelegate.facebookId] image:_image.image delegate:self callback:@selector(uploadedToServer:) type:@"string"];
}

- (void)uploadedToServer:(NSString *)response {
    NSLog(@"%@", response);
    if ([response isEqual:@"true"]) {
        self.navigationItem.rightBarButtonItem.enabled = NO;

        NSLog(@"89");
        if ([appDelegate.session.permissions indexOfObject:@"publish_actions"] == NSNotFound)
            [appDelegate.session requestNewPublishPermissions:@[@"publish_actions"] defaultAudience:FBSessionDefaultAudienceEveryone completionHandler:^(FBSession *session, NSError *error) {
                [self shareOnFacebook];
            }];
        else {
            [self shareOnFacebook];
            NSLog(@"shared");
        }
        if (self.saveLocallySwitch.on) {
            UIImageWriteToSavedPhotosAlbum(_image.image, nil, nil, nil);
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload failed!" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)shareOnFacebook {
    if (!_fbSwitch.on) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }

    NSMutableDictionary<FBGraphObject> *action = [FBGraphObject graphObject];

    /*
       Temp solution, 17 June:
       share the image, put venue details ([name] and facebook url, if exists in caption)
     */
    action[@"source"] = _image.image;
    action[@"message"] = [NSString stringWithFormat:@"%@ @%@", _textFieldname.text, appDelegate.activeVenue[@"name"]];
    action[@"fb:explicitly_shared"] = @"true";
    //action[@"tags"] = selectedFriends;
    //action[@"place"] = @"http://samples.ogp.me/259837270824167";
    //action[@"tags"] = @[@"549445495",@"701732"];
    [[[FBRequest alloc] initWithSession:appDelegate.session graphPath:@"me/photos" parameters:action HTTPMethod:@"POST"] startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        NSLog(@"FBSHARE - PHOTO - connection: %@", connection);
        NSLog(@"FBSHARE - PHOTO - result: %@", result);
        NSLog(@"FBSHARE - PHOTO - error: %@", error);
        /*NSMutableDictionary<FBGraphObject> *action = [FBGraphObject graphObject];
           action[@"venue"] = @"http://samples.ogp.me/259837270824167";
           if (action[@"tags"] != nil) action[@"tags"] = selectedFriends;
           if (action[@"message"] != nil) action[@"message"] = _textFieldname.text;
           action[@"image"] = [NSString stringWithFormat:@"https://www.facebook.com/photo.php?fbid=%@", result[@"id"]];
           action[@"fb:explicitly_shared"] = @"true";
           [[[FBRequest alloc] initForPostWithSession:appDelegate.session graphPath:@"me/shnergle:share" graphObject:action] startWithCompletionHandler:^(FBRequestConnection *connection,
                                                                                                                                                       id result,
                                                                                                                                                       NSError *error) {
                NSLog(@"FBSHARE - POST - connection: %@", connection);
                NSLog(@"FBSHARE - POST - result: %@", result);
                NSLog(@"FBSHARE - POST - error: %@", error);

                [self.navigationController setNavigationBarHidden:YES animated:YES];
                //UIViewController *aroundMe = [self.storyboard instantiateViewControllerWithIdentifier:@"AroundMe"];
                //[self.navigationController pushViewController:aroundMe animated:YES];

            }];
         */

        NSLog(@"finished facebook share");
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}

- (IBAction)selectFriendsButtonAction:(id)sender {
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

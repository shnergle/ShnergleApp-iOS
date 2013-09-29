//
//  TutorialViewController.m
//  ShnergleApp
//
//  Created by Adam Hani Schakaki on 29/09/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "TutorialViewController.h"

@implementation TutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _overlayTitle.text = @"Tutorial";

    ICETutorialLabelStyle *subStyle = [[ICETutorialLabelStyle alloc] init];
    [subStyle setFont:TUTORIAL_SUB_TITLE_FONT];
    [subStyle setTextColor:TUTORIAL_LABEL_TEXT_COLOR];
    [subStyle setLinesNumber:TUTORIAL_SUB_TITLE_LINES_NUMBER];
    [subStyle setOffset:TUTORIAL_SUB_TITLE_OFFSET];
    [self setCommonPageSubTitleStyle:subStyle];
    ICETutorialLabelStyle *descStyle = [[ICETutorialLabelStyle alloc] init];
    [descStyle setFont:TUTORIAL_DESC_FONT];
    [descStyle setTextColor:TUTORIAL_LABEL_TEXT_COLOR];
    [descStyle setLinesNumber:TUTORIAL_DESC_LINES_NUMBER];
    [descStyle setOffset:TUTORIAL_DESC_OFFSET];
    [self setCommonPageDescriptionStyle:descStyle];

	[self setPages:@[[[ICETutorialPage alloc] initWithSubTitle:@"Title" description:@"Description" pictureName:@"background"],
                     [[ICETutorialPage alloc] initWithSubTitle:@"Title2" description:@"Description2" pictureName:@"background"]]];
}

- (void)viewDidAppear:(BOOL)animated {
    [self startScrolling];
}

@end

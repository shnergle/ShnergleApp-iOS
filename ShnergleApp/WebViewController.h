//
//  WebViewController.h
//  ShnergleApp
//
//  Created by Adam Hani Schakaki on 20/07/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "CustomBackViewController.h"

@interface WebViewController : CustomBackViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

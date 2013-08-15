//
//  NSObject+MissingMethods.m
//  ShnergleApp
//
//  Created by Adam Hani Schakaki on 02/08/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "NSObject+MissingMethods.h"

@implementation NSObject (MissingMethods)

- (void)didReceiveMemoryWarning:(id)param {
}

- (id)stringValue {
    return self;
}

- (NSString *)stringByAddingPercentEncodingWithAllowedCharacters:(NSCharacterSet *)allowedCharacters {
    return CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)((NSString *)self), NULL, CFSTR("!*'();:@&=+@,/?#[]"), kCFStringEncodingUTF8));
}

@end

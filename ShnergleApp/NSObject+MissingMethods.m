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

- (id)stringByAddingPercentEncodingWithAllowedCharacters:(NSCharacterSet *)allowedCharacters {
    if ([self isKindOfClass:[NSString class]]) return self;
    NSArray *characters = @[@"!", @"*", @"'", @"(", @")", @";", @":", @"@", @"&", @"=", @"+", @"@", @",", @"/", @"?", @"#", @"[", @"]"];
    NSArray *replacements = @[@"%21", @"%23", @"%24", @"%26", @"%27", @"%28", @"%29", @"%2A", @"%2B", @"%2C", @"%2F", @"%3A", @"%3B", @"%3D", @"%3F", @"%40", @"%5B", @"%5D"];
    NSString *string = (NSString *)self;
    for (int i = 0; i < [characters count]; i++) {
        string = [string stringByReplacingOccurrencesOfString:characters[i] withString:replacements[i]];
    }
    return string;
}

@end

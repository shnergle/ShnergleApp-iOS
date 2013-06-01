//
//  PostRequest.h
//  Consumer App
//
//  Created by Adam Hani Schakaki on 01/06/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostRequest : NSObject {
    NSMutableData *response;
    id responseObject;
    SEL responseCallback;
}

- (void)exec:(NSString *)path params:(NSString *)params delegate:(id)object callback:(SEL)cb;

@end

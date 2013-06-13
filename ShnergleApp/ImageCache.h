//
//  ImageCache.h
//  ShnergleApp
//
//  Created by Adam Hani Schakaki on 02/06/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageCache : NSObject {
    id responseObject;
    SEL responseCallback;
    NSCache *cache;
    NSString *key;
}

- (void)get:(NSString *)type id:(NSString *)type_id delegate:(id)object callback:(SEL)cb;

@end

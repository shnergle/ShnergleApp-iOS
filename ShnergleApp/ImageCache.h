//
//  ImageCache.h
//  ShnergleApp
//
//  Created by Adam Hani Schakaki on 02/06/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CrowdItem.h"

@interface ImageCache : NSObject {
    id responseObject;
    SEL responseCallback;
    NSString *key;
    CrowdItem *item;
    NSIndexPath *indexPath;
}

- (void)get:(NSString *)type identifier:(NSString *)type_id delegate:(id)object callback:(SEL)cb;

+ (UIImage *)get:(NSString *)type identifier:(NSString *)type_id;

- (void)get:(NSString *)type identifier:(NSString *)type_id delegate:(id)object callback:(SEL)cb item:(CrowdItem *)tItem;

- (void)get:(NSString *)type identifier:(NSString *)type_id delegate:(id)object callback:(SEL)cb indexPath:(NSIndexPath *)index;

@end

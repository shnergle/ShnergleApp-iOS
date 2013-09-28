//
//  Request.m
//  ShnergleApp
//
//  Created by Adam Hani Schakaki on 01/06/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "Request.h"
#import <TMCache/TMCache.h>

#define appSecret @"FCuf65iuOUDCjlbiyyer678Coutyc64v655478VGvgh76"
#define serverURL @"http://shnergle-api.azurewebsites.net/v1/%@"

@interface ConnectionErrorAlert : NSObject <UIAlertViewDelegate>

@property BOOL alertIssued;

@end

@implementation ConnectionErrorAlert : NSObject

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    self.alertIssued = NO;
}

@end

static ConnectionErrorAlert *connectionErrorAlert;

@implementation Request

+ (void)initialize {
    connectionErrorAlert = [[ConnectionErrorAlert alloc] init];
    [[TMCache sharedCache] removeAllObjects];
}

+ (UIImage *)getImage:(NSDictionary *)params {
    return [[TMCache sharedCache] objectForKey:[self key:params]];
}

+ (void)setImage:(NSDictionary *)params image:(UIImage *)image {
    if (!image) return;
    [[TMCache sharedCache] setObject:image forKey:[self key:params]];
}

+ (void)removeImage:(NSDictionary *)params {
    [[TMCache sharedCache] removeObjectForKey:[self key:params]];
}

+ (NSString *)key:(NSDictionary *)params {
    return [NSString stringWithFormat:@"%@/%@", params[@"entity"], params[@"entity_id"]];
}

+ (void)post:(NSString *)path params:(NSDictionary *)params callback:(void(^)(id))callback {
    if ([[path pathComponents][0] isEqualToString:@"images"] && [self getImage:params]) {
        if (!callback) return;
        return callback([self getImage:params]);
    }
    NSMutableDictionary *dParams = [@{@"app_secret": appSecret, @"facebook_id": appDelegate.facebookId} mutableCopy];
    [dParams addEntriesFromDictionary:params];
    NSString *urlString = [NSString stringWithFormat:serverURL, path];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    if (dParams[@"image"] != nil) {
        static NSString *boundary = @"This-string-cannot-be-part-of-the-content";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        [urlRequest addValue:contentType forHTTPHeaderField:@"Content-Type"];
        NSMutableData *body = [NSMutableData data];
        for (NSString *key in dParams) {
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            if ([key isEqualToString:@"image"]) {
                [body appendData:[@"Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n" dataUsingEncoding : NSUTF8StringEncoding]];
                [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding : NSUTF8StringEncoding]];
                [body appendData:[NSData dataWithData:UIImageJPEGRepresentation(dParams[@"image"], 0.5)]];
            } else {
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"%@", dParams[key]] dataUsingEncoding:NSUTF8StringEncoding]];
            }
        }
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [urlRequest setHTTPBody:body];
    } else {
        NSMutableArray *paramsArray = [NSMutableArray array];
        for (NSString *key in dParams) {
            id value = dParams[key];
            if ([value respondsToSelector:@selector(stringByAddingPercentEncodingWithAllowedCharacters:)]) [value stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]];
            [paramsArray addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
        }
        [urlRequest setHTTPBody:[[paramsArray componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            NSLog(@"ConnectionError: %@", connectionError);
            if (connectionError.code != -1001 && !connectionErrorAlert.alertIssued) {
                connectionErrorAlert.alertIssued = YES;
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection failed!" message:nil delegate:connectionErrorAlert cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                });
            }
            return;
        }
        if (!callback) return;
        dispatch_async(dispatch_get_main_queue(), ^{
            id responseArg;
            if ([[path pathComponents][0] isEqualToString:@"images"]) {
                @try {
                    responseArg = [[UIImage alloc] initWithData:data];
                    if (!responseArg) [NSException raise:nil format:nil];
                } @catch (NSException *e) {
                    responseArg = [UIImage imageNamed:@"No_activity"];
                }
                [self setImage:params image:responseArg];
            } else {
                responseArg = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                if ([responseArg isKindOfClass:[NSDictionary class]] && responseArg[@"traceback"]) {
                    responseArg = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"An error occured while trying to load!" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];
                    });
                }
            }
            NSLog(@"Response: %@", responseArg);
            callback(responseArg);
        });
    }];
}

+ (int)time:(BOOL)nextSix {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:[NSDate date]];
    if (!nextSix && components.hour < 6) components.day--;
    else if (nextSix && components.hour > 5) components.day++;
    components.hour = 6;
    components.minute = components.second = 0;
    return [[calendar dateFromComponents:components] timeIntervalSince1970];
}

@end

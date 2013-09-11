//
//  PostRequest.m
//  ShnergleApp
//
//  Created by Adam Hani Schakaki on 01/06/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "Request.h"
#import <Crashlytics/Crashlytics.h>
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

+ (void)post:(NSString *)path params:(NSDictionary *)params delegate:(id)object callback:(SEL)cb {
    return [self post:path params:params image:nil delegate:object callback:cb userData:nil];
}

+ (void)post:(NSString *)path params:(NSDictionary *)params image:(UIImage *)image delegate:(id)object callback:(SEL)cb {
    return [self post:path params:params image:image delegate:object callback:cb userData:nil];
}

+ (void)post:(NSString *)path params:(NSDictionary *)params delegate:(id)object callback:(SEL)cb userData:(id)userData {
    return [self post:path params:params image:nil delegate:object callback:cb userData:userData];
}

+ (void)post:(NSString *)path params:(NSDictionary *)params image:(UIImage *)image delegate:(id)object callback:(SEL)cb userData:(id)userData {
    if ([[path pathComponents][0] isEqualToString:@"images"] && [self getImage:params]) {
        return [self despatch:[self getImage:params] to:object callback:cb userData:userData];
    }
    NSString *urlString = [NSString stringWithFormat:serverURL, path];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    if (image) {
        static NSString *boundary = @"This-string-cannot-be-part-of-the-content";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        [urlRequest addValue:contentType forHTTPHeaderField:@"Content-Type"];
        NSMutableData *body = [NSMutableData data];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"app_secret"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[appSecret stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"facebook_id"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[appDelegate.facebookId stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]] dataUsingEncoding:NSUTF8StringEncoding]];
        if (params) {
            for (NSString *key in params) {
                [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[params[key] stringValue] dataUsingEncoding:NSUTF8StringEncoding]];
            }
        }
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n" dataUsingEncoding : NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding : NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:UIImageJPEGRepresentation(image, 0.5)]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [urlRequest setHTTPBody:body];
    } else {
        NSMutableString *paramsString = [NSMutableString stringWithFormat:@"app_secret=%@&facebook_id=%@", [appSecret stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]], [appDelegate.facebookId stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]]];
        if (params) {
            for (NSString *key in params) {
                [paramsString appendFormat:@"&%@=%@", key, [[params[key] stringValue] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]]];
            }
        }
        [urlRequest setHTTPBody:[paramsString dataUsingEncoding:NSUTF8StringEncoding]];
    }
    if ([[path pathComponents][0] isEqualToString:@"images"]) [urlRequest setTimeoutInterval:4];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            [Crashlytics setObjectValue:connectionError forKey:@"lastConnectionError"];
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
        if ([[path pathComponents][0] isEqualToString:@"images"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *responseArg;
                @try {
                    NSString *firstChar = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] substringToIndex:1];
                    if ([@"{" isEqualToString:firstChar] || [@"null" isEqualToString:firstChar] || [@"" isEqualToString:firstChar]) @throw [NSException exceptionWithName:nil reason:nil userInfo:nil];
                    responseArg = [[UIImage alloc] initWithData:data];
                    [self setImage:params image:responseArg];
                } @catch (NSException *e) {
                    responseArg = [UIImage imageNamed:@"No_activity.png"];
                    [self setImage:params image:responseArg];
                }
                [self logData:data andResponse:responseArg];
                [self despatch:responseArg to:object callback:cb userData:userData];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                id responseArg = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                if ([responseArg isKindOfClass:[NSDictionary class]] && responseArg[@"traceback"]) {
                    responseArg = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"An error occured while trying to load!" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];
                    });
                }
                [self logData:data andResponse:responseArg];
                [self despatch:responseArg to:object callback:cb userData:userData];
            });
        }
    }];
}

+ (void)logData:(NSData *)data andResponse:(id)response {
    [Crashlytics setObjectValue:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] forKey:@"lastResponseString"];
    [Crashlytics setObjectValue:response forKey:@"lastResponseParsed"];
    NSLog(@"ResponseString: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    NSLog(@"ResponseParsed: %@", response);
}

+ (void)despatch:(id)argument to:(id)object callback:(SEL)cb userData:(id)userData {
    NSMethodSignature *methodSig = [[object class] instanceMethodSignatureForSelector:cb];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
    [invocation setSelector:cb];
    [invocation setArgument:&argument atIndex:2];
    if (userData) [invocation setArgument:&userData atIndex:3];
    [invocation setTarget:object];
    [invocation retainArguments];
    [invocation invoke];
}

@end

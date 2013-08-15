//
//  PostRequest.m
//  ShnergleApp
//
//  Created by Adam Hani Schakaki on 01/06/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "PostRequest.h"
#import <Crashlytics/Crashlytics.h>

@implementation PostRequest

- (BOOL)exec:(NSString *)path params:(NSDictionary *)params delegate:(id)object callback:(SEL)cb {
    return [self exec:path params:params delegate:object callback:cb type:@"json"];
}

- (BOOL)exec:(NSString *)path params:(NSDictionary *)params delegate:(id)object callback:(SEL)cb type:(NSString *)type {
    NSString *urlString = [NSString stringWithFormat:@"http://shnergle-api.azurewebsites.net/v1/%@", path];
    NSMutableString *paramsString = [NSMutableString stringWithFormat:@"app_secret=%@&facebook_id=%@", [appDelegate.appSecret stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]], [appDelegate.facebookId stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]]];
    if (params) {
        for (NSString *key in params) {
            [paramsString appendFormat:@"&%@=%@", key, [[params[key] stringValue] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]]];
        }
    }
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[paramsString dataUsingEncoding:NSUTF8StringEncoding]];
    if ([@"image" isEqualToString:type]) [urlRequest setTimeoutInterval:4];
    response = [[NSMutableData alloc] init];
    responseObject = object;
    responseCallback = cb;
    responseType = type;
    return !![[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
}

- (BOOL)exec:(NSString *)path params:(NSDictionary *)params image:(UIImage *)image delegate:(id)object callback:(SEL)cb {
    return [self exec:path params:params image:(UIImage *)image delegate:object callback:cb type:@"json"];
}

- (BOOL)exec:(NSString *)path params:(NSDictionary *)params image:(UIImage *)image delegate:(id)object callback:(SEL)cb type:(NSString *)type {
    NSString *urlString = [NSString stringWithFormat:@"http://shnergle-api.azurewebsites.net/v1/%@", path];
    NSString *boundary = @"This-string-cannot-be-part-of-the-content";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest addValue:contentType forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPMethod:@"POST"];
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"app_secret"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[appDelegate.appSecret stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"facebook_id"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[appDelegate.facebookId stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]] dataUsingEncoding:NSUTF8StringEncoding]];
    if (params) {
        for (NSString *key in params) {
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[params[key] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]] dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n" dataUsingEncoding : NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding : NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:UIImageJPEGRepresentation(image, 0.7)]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [urlRequest setHTTPBody:body];
    response = [[NSMutableData alloc] init];
    responseObject = object;
    responseCallback = cb;
    responseType = type;
    return !![[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [response appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    id responseArg;
    if ([@"image" isEqualToString : responseType]) @try {responseArg = [UIImage imageWithData:response]; } @catch (NSException *e) {
        }
    else if ([@"string" isEqualToString : responseType]) responseArg = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    else responseArg = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
    [Crashlytics setObjectValue:[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding] forKey:@"lastResponseString"];
    [Crashlytics setObjectValue:responseArg forKey:@"lastResponseParsed"];
    NSMethodSignature *methodSig = [[responseObject class] instanceMethodSignatureForSelector:responseCallback];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
    [invocation setSelector:responseCallback];
    [invocation setArgument:&responseArg atIndex:2];
    [invocation setTarget:responseObject];
    NSLog(@"%@", [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
    NSLog(@"%@", responseArg);
    [invocation retainArguments];
    [invocation invoke];
}

@end

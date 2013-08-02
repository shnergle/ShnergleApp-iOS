//
//  PostRequest.m
//  ShnergleApp
//
//  Created by Adam Hani Schakaki on 01/06/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "PostRequest.h"

@implementation PostRequest

- (BOOL)exec:(NSString *)path params:(NSString *)params delegate:(id)object callback:(SEL)cb {
    return [self exec:path params:params delegate:object callback:cb type:@"json"];
}

- (BOOL)exec:(NSString *)path params:(NSString *)params delegate:(id)object callback:(SEL)cb type:(NSString *)type {
    NSString *urlString = [NSString stringWithFormat:@"http://shnergle-api.azurewebsites.net/v1/%@", path];
    NSString *paramsString = [NSString stringWithFormat:@"app_secret=%@&facebook_id=%@&%@", appDelegate.appSecret, appDelegate.facebookId, params];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[paramsString dataUsingEncoding:NSUTF8StringEncoding]];
    if ([@"image" isEqualToString : type]) [urlRequest setTimeoutInterval:4];
    response = [[NSMutableData alloc] init];
    responseObject = object;
    responseCallback = cb;
    responseType = type;
    return !![[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
}

- (BOOL)exec:(NSString *)path params:(NSString *)params image:(UIImage *)image delegate:(id)object callback:(SEL)cb {
    return [self exec:path params:params image:(UIImage *)image delegate:object callback:cb type:@"json"];
}

- (BOOL)exec:(NSString *)path params:(NSString *)params image:(UIImage *)image delegate:(id)object callback:(SEL)cb type:(NSString *)type {
    NSString *urlString = [NSString stringWithFormat:@"http://shnergle-api.azurewebsites.net/v1/%@", path];
    NSString *paramsString = [NSString stringWithFormat:@"app_secret=%@&facebook_id=%@&%@", appDelegate.appSecret, appDelegate.facebookId, params];
    NSString *boundary = @"This-string-cannot-be-part-of-the-content";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest addValue:contentType forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPMethod:@"POST"];
    NSMutableData *body = [NSMutableData data];
    for (NSString *field in [paramsString componentsSeparatedByString : @"&"]) {
        NSArray *splitField = [field componentsSeparatedByString:@"="];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", splitField[0]] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[splitField[1] dataUsingEncoding:NSUTF8StringEncoding]];
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
    NSMethodSignature *methodSig = [[responseObject class] instanceMethodSignatureForSelector:responseCallback];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
    [invocation setSelector:responseCallback];
    [invocation setArgument:&responseArg atIndex:2];
    [invocation setTarget:responseObject];
    NSLog(@"%@",responseArg);
    [invocation retainArguments];
    [invocation invoke];
}

@end

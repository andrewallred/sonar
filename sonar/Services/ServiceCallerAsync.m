//
//  ServiceCallerAsync.m
//  sonar
//
//  Created by Allred, Andrew on 12/1/20.
//  Copyright © 2020 Allred, Andrew. All rights reserved.
//

#import "ServiceCallerAsync.h"

@implementation ServiceCallerAsync

+(void) getDataForUrl:(NSString *)urlString completionHandler:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler
{
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];
    request.URL = [NSURL URLWithString:urlString];
    request.HTTPMethod = @"GET";
        
    NSURLSession* urlSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [urlSession dataTaskWithRequest:request completionHandler:completionHandler];
    
    [dataTask resume];
}

+(void) postDataToUrl:(NSString *)urlString data:(NSData*)data completionHandler:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler
{
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];
    request.URL = [NSURL URLWithString:urlString];
    request.HTTPBody = data;
    request.HTTPMethod = @"POST";
        
    NSURLSession* urlSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [urlSession dataTaskWithRequest:request completionHandler:completionHandler];
    
    [dataTask resume];
}

+(NSString*) encodeParameter:(NSString *)unencodedString {
    return [unencodedString stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
}

@end

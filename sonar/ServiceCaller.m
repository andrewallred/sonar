//
//  ServiceCaller.m
//  sonar
//
//  Created by Allred, Andrew on 11/29/20.
//  Copyright © 2020 Allred, Andrew. All rights reserved.
//

#import "ServiceCaller.h"

@implementation ServiceCaller

+(NSString*) loadStringByUrl:(NSString *)urlString
{
    NSData* data = [self loadDataByUrl:urlString Accept:nil];
    if (data == nil)
    {
        return nil;
    }
    
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return str;
}

+(NSMutableDictionary *) loadJsonByUrl:(NSString *)urlString withTimeoutInterval:(NSTimeInterval)timeout
{
    NSLog(@"loadJsonByUrl: %@", urlString);
    NSError *error = nil;
    NSData* data = [self loadDataByUrl:urlString Accept:@"application/json" withTimeoutInterval:timeout];
    if (data == nil)
    {
        return nil;
    }
    
    NSMutableDictionary *objects = [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error] mutableCopy];
    
    if (error != nil) {
        NSLog(@"Error: %@", [error localizedDescription]);
        return nil;
    }
    
    return objects;
}

+(NSData*) loadDataByUrl:(NSString *)urlString
{
    return [self loadDataByUrl:urlString Accept:@"application/json"];
}

+(NSData*) loadDataByUrl:(NSString *)urlString Accept:(NSString*)accept
{
    return [self loadDataByUrl:urlString Accept:accept withTimeoutInterval:120];
}

+(NSData*) loadDataByUrl:(NSString *)urlString Accept:(NSString*)accept withTimeoutInterval:(NSTimeInterval)timeout
{
    NSError *error = nil;
    NSURLResponse *response = nil;
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:timeout];
    if (accept != nil)
    {
        [request setValue:accept forHTTPHeaderField:@"Accept"];
    }
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];
    
    if (error != nil) {
        NSLog(@"Error: %@", [error localizedDescription]);
        return nil;
    }
    
    return data;
}


@end

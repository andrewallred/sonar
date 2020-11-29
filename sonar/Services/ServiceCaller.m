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
    return [self loadDataByUrl:urlString Accept:nil];
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

+(NSString *) encodeParameter: (NSString *)unencodedString
{
    // Code provided by: https://ioscodeexamples.blogspot.com/2013/07/ios-url-encoding.html#ixzz2gORgtcbX
    CFStringRef safeString = CFURLCreateStringByAddingPercentEscapes(NULL,
                                            (__bridge  CFStringRef)unencodedString,
                                            NULL,
                                            CFSTR("/%&=?$#+-~@<>|\\*,.()[]{}^!"),
                                            kCFStringEncodingUTF8);
    // KA Note: CFStringRef's are toll-free bridged with NSString's - no need to create a new one
    // The notation "__bridging_transfer" tells the compiler to transfer the +1 ownership from Core Foundation to ARC
    // CFBridgingRelease() also could have been used to do the same thing
    return (__bridge_transfer NSString *)safeString; //[NSString stringWithFormat:@"%@", safeString];
}

@end

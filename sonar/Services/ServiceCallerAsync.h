//
//  ServiceCallerAsync.h
//  sonar
//
//  Created by Allred, Andrew on 12/1/20.
//  Copyright © 2020 Allred, Andrew. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ServiceCallerAsync : NSObject

+(void) getDataForUrl:(NSString *)urlString completionHandler:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler;
+(void) postDataToUrl:(NSString *)urlString data:(NSData*)data completionHandler:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler;

+(NSString *) encodeParameter: (NSString *)unencodedString;

@end

NS_ASSUME_NONNULL_END

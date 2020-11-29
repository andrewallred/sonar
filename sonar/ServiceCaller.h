//
//  ServiceCaller.h
//  sonar
//
//  Created by Allred, Andrew on 11/29/20.
//  Copyright © 2020 Allred, Andrew. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ServiceCaller : NSObject

+(NSString*) loadStringByUrl:(NSString *)urlString;
+(NSMutableDictionary *) loadJsonByUrl:(NSString *)urlString withTimeoutInterval:(NSTimeInterval)timeout;
+(NSData*) loadDataByUrl:(NSString *)urlString;
+(NSData*) loadDataByUrl:(NSString *)urlString Accept:(NSString*)accept;
+(NSData*) loadDataByUrl:(NSString *)urlString Accept:(NSString*)accept withTimeoutInterval:(NSTimeInterval)timeout;

@end

NS_ASSUME_NONNULL_END

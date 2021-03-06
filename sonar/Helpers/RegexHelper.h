//
//  RegexHelper.h
//  sonar
//
//  Created by Allred, Andrew on 11/29/20.
//  Copyright © 2020 Allred, Andrew. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RegexHelper : NSObject

+ (NSArray*) regexMatchesForString: (NSString*) inputString regex: (NSString*) regexString;

@end

NS_ASSUME_NONNULL_END

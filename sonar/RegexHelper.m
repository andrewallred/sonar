//
//  RegexHelper.m
//  sonar
//
//  Created by Allred, Andrew on 11/29/20.
//  Copyright © 2020 Allred, Andrew. All rights reserved.
//

#import "RegexHelper.h"

@implementation RegexHelper

+ (NSArray*) regexMatchesForString: (NSString*) inputString regex: (NSString*) regexString {
    
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexString
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    //    NSUInteger numberOfMatches = [regex numberOfMatchesInString:inputString
    //    options:0
    //      range:NSMakeRange(0, [inputString length])];
    
    NSArray *matches = [regex matchesInString:inputString
                                      options:0
                                        range:NSMakeRange(0, [inputString length])];
    
    return matches;
}

@end

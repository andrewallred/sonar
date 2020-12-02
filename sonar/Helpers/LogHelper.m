//
//  LogHelper.m
//  sonar
//
//  Created by Allred, Andrew on 12/1/20.
//  Copyright © 2020 Allred, Andrew. All rights reserved.
//

#import "LogHelper.h"

@implementation LogHelper

+(void) logError:(NSError*) error {
    if (error != nil) {
        NSLog(@"Error: %@", [error description]);
    }
}

@end

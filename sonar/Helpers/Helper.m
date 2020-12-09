//
//  Helper.m
//  sonar
//
//  Created by Allred, Andrew on 12/8/20.
//  Copyright © 2020 Allred, Andrew. All rights reserved.
//

#import "Helper.h"

@implementation Helper

+(BOOL) isNull:(id)o {
    return [o isEqual:[NSNull null]];
}

+(long) idToLong:(id)o {
    if ([self isNull: o]) {
        return 0;
    } else {
        return [o longValue];
    }
}

@end

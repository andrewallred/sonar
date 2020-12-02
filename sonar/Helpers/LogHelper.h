//
//  LogHelper.h
//  sonar
//
//  Created by Allred, Andrew on 12/1/20.
//  Copyright © 2020 Allred, Andrew. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LogHelper : NSObject

+(void) logError:(NSError*) error;

@end

NS_ASSUME_NONNULL_END

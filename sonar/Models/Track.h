//
//  Track.h
//  sonar
//
//  Created by Allred, Andrew on 11/29/20.
//  Copyright © 2020 Allred, Andrew. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Track : NSObject

@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* streamingUrl;
@property (nonatomic) int number;

@end

NS_ASSUME_NONNULL_END

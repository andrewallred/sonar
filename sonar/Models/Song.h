//
//  Song.h
//  sonar
//
//  Created by Allred, Andrew on 11/29/20.
//  Copyright © 2020 Allred, Andrew. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Song : NSObject

@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* audioUrl;

@end

NS_ASSUME_NONNULL_END

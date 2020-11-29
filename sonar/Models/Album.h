//
//  Album.h
//  sonar
//
//  Created by Allred, Andrew on 11/29/20.
//  Copyright © 2020 Allred, Andrew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Song.h"

NS_ASSUME_NONNULL_BEGIN

@interface Album : NSObject

@property (nonatomic, strong) NSString* ImageUrl;
@property (nonatomic, strong) NSString* Name;
@property (nonatomic, strong) NSString* Url;
@property (nonatomic, strong) NSMutableArray<Song*>* Songs;

@end

NS_ASSUME_NONNULL_END

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

@property (nonatomic, strong) NSString* imageUrl;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* url;
@property (nonatomic, strong) NSMutableArray<Song*>* songs;

@end

NS_ASSUME_NONNULL_END

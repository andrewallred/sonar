//
//  LocalDataHelper.h
//  sonar
//
//  Created by Allred, Andrew on 11/30/20.
//  Copyright © 2020 Allred, Andrew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Artist.h"

NS_ASSUME_NONNULL_BEGIN

@interface LocalDataHelper : NSObject

+(NSMutableArray<NSDictionary*>*) getRecentlySearchedArtists;
+(void) addArtistToSearchedArtists:(Artist*) artist;

@end

NS_ASSUME_NONNULL_END

//
//  BandcampMobileService.h
//  sonar
//
//  Created by Allred, Andrew on 11/30/20.
//  Copyright © 2020 Allred, Andrew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Artist.h"
#import "Album.h"

NS_ASSUME_NONNULL_BEGIN

@interface BandcampMobileService : NSObject

+(Artist*) loadBandDetails:(long)bandId;
+(Album*) loadAlbumDetails:(long)albumId withBandId:(long) bandId;

@end

NS_ASSUME_NONNULL_END

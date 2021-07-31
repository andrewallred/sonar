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

+(void) loadBandDetails:(long)bandId completionHandler:(void (^)(Artist* artist, NSError * _Nullable error))completionHandler;
+(void) loadAlbumDetails:(Album*)album completionHandler:(void (^)(Album* album, NSError * _Nullable error))completionHandler;

@end

NS_ASSUME_NONNULL_END

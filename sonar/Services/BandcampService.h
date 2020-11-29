//
//  BandcampService.h
//  sonar
//
//  Created by Allred, Andrew on 11/29/20.
//  Copyright © 2020 Allred, Andrew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Artist.h"

NS_ASSUME_NONNULL_BEGIN

@interface BandcampService : NSObject

+(NSDictionary*) loadSearchResults:(NSString *)urlString;
+(Artist*) loadArtist: (NSString*) url;
+(Album*) loadAlbum: (NSString*) url;

@end

NS_ASSUME_NONNULL_END

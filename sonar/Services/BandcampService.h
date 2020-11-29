//
//  BandcampService.h
//  sonar
//
//  Created by Allred, Andrew on 11/29/20.
//  Copyright © 2020 Allred, Andrew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArtistPage.h"

NS_ASSUME_NONNULL_BEGIN

@interface BandcampService : NSObject

+(NSDictionary*) loadSearchResults:(NSString *)urlString;

+(ArtistPage*) loadArtistPage: (NSString*) url;

@end

NS_ASSUME_NONNULL_END

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

+(void) loadSearchResults:(NSString *)searchTerm completionHandler:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler;

+(void) loadAlbumFromHtml:(NSString *)url completionHandler:(void (^)(Album* album, NSError * _Nullable error))completionHandler;

@end

NS_ASSUME_NONNULL_END

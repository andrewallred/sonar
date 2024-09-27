//
//  BandcampService.m
//  sonar
//
//  Created by Allred, Andrew on 11/29/20.
//  Copyright © 2020 Allred, Andrew. All rights reserved.
//

#import "BandcampService.h"
#import "ServiceCallerAsync.h"
#import "RegexHelper.h"
#import "Artist.h"
#import "Album.h"

@implementation BandcampService

+(void) loadSearchResults:(NSString *)searchTerm completionHandler:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler {
    
    searchTerm = [ServiceCallerAsync encodeParameter:searchTerm];
    
    NSLog(@"search term %@", searchTerm);

    NSString *url = [NSString stringWithFormat:@"https://bandcamp.com/api/fuzzysearch/2/app_autocomplete?q=%@", searchTerm];
    
    [ServiceCallerAsync getDataForUrl:url completionHandler:completionHandler];
}

+(void) loadAlbumFromHtml:(NSString *)url completionHandler:(void (^)(Album* album, NSError * _Nullable error))completionHandler {
    
    //@"https://lazymagnet.bandcamp.com/album/make-it-fun-again-2020"
    
    // NOTE : this method is currently only used for rights info, and is not presently parsing any other data
    
    [ServiceCallerAsync getDataForUrl:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        Album* album = [[Album alloc] init];
        album.tracks = [[NSMutableArray<Track*> alloc] init];
        
        // TODO review the assumption that the data is UTF8
        NSString* html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        // TODO terrible hack, will revisit
        NSArray* knownRights = [NSArray arrayWithObjects:@"all rights reserved",@"CC BY-NC-ND 3.0",@"CC BY-NC-SA 3.0",@"CC BY-NC 3.0",@"CC BY-ND 3.0",@"CC BY-SA 3.0",@"CC BY 3.0",nil];

        for (int i = 0; i < [knownRights count]; i++) {
            if ([html containsString:knownRights[i]]) {
                album.rightsInfo = knownRights[i];
                break;
            }
        }
        
        completionHandler(album, error);
    }];
    

//    NSArray* coverMatches = [RegexHelper regexMatchesForString: page regex:@"<a class=\"popupImage\" href=\"[a-zA-Z0-9_:\\/.-]*"];
//    for (NSString *match in coverMatches) {
//        NSString* imageUrl = match;
//        // TODO album.imageUrl = [imageUrl stringByReplacingOccurrencesOfString:@"<a class=\"popupImage\" href=\"" withString:@""];
//        break;
//    }
    
    
}

@end

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

    NSString *url = [NSString stringWithFormat:@"https://bandcamp.com/api/fuzzysearch/1/autocomplete?q=%@", searchTerm];
    
    [ServiceCallerAsync getDataForUrl:url completionHandler:completionHandler];
}

@end

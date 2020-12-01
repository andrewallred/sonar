//
//  BandcampService.m
//  sonar
//
//  Created by Allred, Andrew on 11/29/20.
//  Copyright © 2020 Allred, Andrew. All rights reserved.
//

#import "BandcampService.h"
#import "ServiceCaller.h"
#import "RegexHelper.h"
#import "Artist.h"
#import "Album.h"

@implementation BandcampService

+(NSDictionary*) loadSearchResults:(NSString *)searchTerm {
    
    NSLog(@"search term %@", searchTerm);

    NSString *url = [NSString stringWithFormat:@"https://bandcamp.com/api/fuzzysearch/1/autocomplete?q=%@",
                     [ServiceCaller encodeParameter:searchTerm]];

    NSData* data = [ServiceCaller loadDataByUrl:url];

    NSDictionary *searchResults = [NSJSONSerialization
                             JSONObjectWithData:data
                             options:NSJSONReadingMutableLeaves
                             error:nil];
    
    return searchResults;
}

@end

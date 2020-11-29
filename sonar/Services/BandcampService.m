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

+(Artist*) loadArtistPage: (NSString*) url {
    
    Artist* artist = [[Artist alloc] init];
    artist.Albums = [[NSMutableArray<Album*> alloc] init];
    
    NSString *page = [ServiceCaller loadStringByUrl:url];
    
    NSArray* albumSectionMatches = [RegexHelper regexMatchesForString: page regex:@"<a href=\"\\/album\\/[a-zA-Z0-9_\\/\"-<> \\t\\n\\r=]*<\\/a>"];
    
    NSString* albumUrl;
    for (NSString *albumSectionMatch in albumSectionMatches) {
        
        NSArray* albumUrlMatches = [RegexHelper regexMatchesForString: albumSectionMatch regex:@"<a href=\"\\/album\\/[a-zA-Z0-9_-]*\">"];
        
        for (NSString *urlMatch in albumUrlMatches) {
            
            NSString* albumUrl = urlMatch;
            albumUrl = [albumUrl stringByReplacingOccurrencesOfString:@"/music" withString:@""];
            albumUrl = [albumUrl stringByReplacingOccurrencesOfString:@"<a href=\"" withString:url];
            albumUrl = [albumUrl stringByReplacingOccurrencesOfString:@"\">" withString:@""];
            
            Album* album = [[Album alloc] init];
            album.Url = albumUrl;
            
            [artist.Albums addObject:album];
            
        }
        
    }
    
    return artist;
}

@end

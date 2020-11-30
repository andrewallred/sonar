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

+(Artist*) loadArtist: (NSString*) url {
    
    Artist* artist = [[Artist alloc] init];
    artist.albums = [[NSMutableArray<Album*> alloc] init];
    
    NSString *page = [ServiceCaller loadStringByUrl:url];
    
    NSArray* albumSectionMatches = [RegexHelper regexMatchesForString: page regex:@"<a href=\"\\/album\\/[a-zA-Z0-9_\\/\"-<> \\t\\n\\r=]*<\\/a>"];
    
    for (NSString *albumSectionMatch in albumSectionMatches) {
        
        NSArray* albumUrlMatches = [RegexHelper regexMatchesForString: albumSectionMatch regex:@"<a href=\"\\/album\\/[a-zA-Z0-9_-]*\">"];
        
        for (NSString *urlMatch in albumUrlMatches) {
            
            NSString* albumUrl = [NSString stringWithFormat:@"%@%@", url, urlMatch];
            
            albumUrl = [albumUrl stringByReplacingOccurrencesOfString:@"/music" withString:@""];
            albumUrl = [albumUrl stringByReplacingOccurrencesOfString:@"<a href=\"" withString:@""];
            albumUrl = [albumUrl stringByReplacingOccurrencesOfString:@"\">" withString:@""];
            
            Album* album = [[Album alloc] init];
            album.url = albumUrl;
            
            [artist.albums addObject:album];
            
        }
        
    }
    
    return artist;
}

+(Album*) loadAlbum:(NSString*) url {
    
    Album* album = [[Album alloc] init];
    album.songs = [[NSMutableArray<Song*> alloc] init];
    
    //@"https://lazymagnet.bandcamp.com/album/make-it-fun-again-2020"
    NSString *page = [ServiceCaller loadStringByUrl:url];
    
    NSArray* songMatches = [RegexHelper regexMatchesForString: page regex:@"&quot;https:\\/\\/t4\\.bcbits\\.com[a-zA-Z0-9_\\/-]*\\?[a-zA-Z0-9_\\/-=&]*&quot;"];
    
    NSString* audioUrl;
    for (NSString *match in songMatches) {
        
        audioUrl = match;
        audioUrl = [audioUrl stringByReplacingOccurrencesOfString:@"&quot;" withString:@""];
        audioUrl = [audioUrl stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
        
        Song* song = [[Song alloc] init];
        song.audioUrl = audioUrl;
        [album.songs addObject:song];
    }
    
    NSArray* coverMatches = [RegexHelper regexMatchesForString: page regex:@"<a class=\"popupImage\" href=\"[a-zA-Z0-9_:\\/.-]*"];
    for (NSString *match in coverMatches) {
        NSString* imageUrl = match;
        album.imageUrl = [imageUrl stringByReplacingOccurrencesOfString:@"<a class=\"popupImage\" href=\"" withString:@""];
        break;
    }
    
    return album;
}

@end

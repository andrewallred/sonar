//
//  BandcampMobileService.m
//  sonar
//
//  Created by Allred, Andrew on 11/30/20.
//  Copyright © 2020 Allred, Andrew. All rights reserved.
//

#import "BandcampMobileService.h"
#import "ServiceCallerAsync.h"
#import "LogHelper.h"
#import "Helper.h"

@implementation BandcampMobileService

+(void) loadBandDetails:(long)bandId completionHandler:(void (^)(Artist* artist, NSError * _Nullable error))completionHandler {
    
    NSString* postString = [NSString stringWithFormat:@"{\"band_id\":\"%ld\"}", bandId];
    NSData* postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    
    [ServiceCallerAsync postDataToUrl:@"https://bandcamp.com/api/mobile/22/band_details" data:postData completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error !=  nil) {
            
            completionHandler(nil, error);
            return;
            
        }
        
        NSDictionary *bandJson = [NSJSONSerialization
                                 JSONObjectWithData:data
                                 options:NSJSONReadingMutableLeaves
                                 error:&error];
        
        Artist* artist = [self dictionaryToArtist:bandJson];
        
        completionHandler(artist, error);
        
    }];
    
}

+(Artist*) dictionaryToArtist:(NSDictionary *) dictionary {
    
    Artist* artist = [[Artist alloc] init];
    
    artist.bandId = [Helper idToLong:dictionary[@"id"]];
    artist.location = dictionary[@"location"];
    artist.name = dictionary[@"name"];
    artist.biography = dictionary[@"biography"];
    artist.bandcampUrl = dictionary[@"bandcamp_url"];
    artist.bioImageId = [Helper idToLong:dictionary[@"bio_image_id"]];
    artist.imageUrl = [NSString stringWithFormat:@"https://f4.bcbits.com/img/00%ld_16.jpg", artist.bioImageId];
    
    artist.discography = [[NSMutableArray<Album*> alloc] init];
    for (int i = 0; i < [dictionary[@"discography"] count]; i++) {
        Album* album = [[Album alloc] init];
        album.artId = [Helper idToLong:dictionary[@"discography"][i][@"art_id"]];
        album.imageUrl = [NSString stringWithFormat:@"https://f4.bcbits.com/img/a0%ld_8.jpg", album.artId];
        album.bandId = [Helper idToLong:dictionary[@"discography"][i][@"band_id"]];
        album.itemId = [Helper idToLong:dictionary[@"discography"][i][@"item_id"]];
        album.releaseDate = dictionary[@"discography"][i][@"release_date"];
        album.title = dictionary[@"discography"][i][@"title"];
        album.isAlbum = [dictionary[@"discography"][i][@"item_type"] isEqualToString:@"album"];
        
        [artist.discography addObject:album];
    }
    
    return artist;
}

+(void) loadAlbumDetails:(Album*)album completionHandler:(void (^)(Album* album, NSError * _Nullable error))completionHandler {
    
    NSString* type = @"t";
    if (album.isAlbum) {
        type = @"a";
    }
    NSString* url = [NSString stringWithFormat: @"https://bandcamp.com/api/mobile/22/tralbum_details?band_id=%ld&tralbum_id=%ld&tralbum_type=%@", album.bandId, album.itemId, type];
    
    [ServiceCallerAsync getDataForUrl:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSDictionary *albumJson = [NSJSONSerialization
                                 JSONObjectWithData:data
                                 options:NSJSONReadingMutableLeaves
                                 error:&error];
        
        Album* album = [self dictionaryToAlbum:albumJson];
        
        completionHandler(album, error);

    }];
    
}

+(Album*) dictionaryToAlbum:(NSDictionary *) dictionary {
    
    Album* album = [[Album alloc] init];
    
    album.artId = [Helper idToLong:dictionary[@"art_id"]];
    album.imageUrl = [NSString stringWithFormat:@"https://f4.bcbits.com/img/a0%ld_16.jpg", album.artId];
    album.title = dictionary[@"album_title"];
    if ([[NSNull null] isEqual:album.title]) {
        album.title = dictionary[@"title"];
    }
    album.itemId = [Helper idToLong:dictionary[@"id"]];
    album.bandName = dictionary[@"tralbum_artist"];
    album.albumUrl = dictionary[@"bandcamp_url"];
    album.albumId = [Helper idToLong:dictionary[@"album_id"]];
    
    album.tracks = [[NSMutableArray<Track*> alloc] init];
    for (int i = 0; i < [dictionary[@"tracks"] count]; i++) {
        Track* track = [[Track alloc] init];
        // TODO should fix this
        if (![dictionary[@"tracks"][i][@"streaming_url"] isEqual:[NSNull null]]) {
            track.streamingUrl = dictionary[@"tracks"][i][@"streaming_url"][@"mp3-128"];
        }
        track.title = dictionary[@"tracks"][i][@"title"];
        track.number = i;
        
        [album.tracks addObject:track];
    }
    
    return album;
}

@end

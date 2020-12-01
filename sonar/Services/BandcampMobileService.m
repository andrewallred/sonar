//
//  BandcampMobileService.m
//  sonar
//
//  Created by Allred, Andrew on 11/30/20.
//  Copyright © 2020 Allred, Andrew. All rights reserved.
//

#import "BandcampMobileService.h"
#import "ServiceCaller.h"

@implementation BandcampMobileService

+(Artist*) loadBandDetails:(long)bandId {
    
    NSString* postData = [NSString stringWithFormat:@"{\"band_id\":\"%ld\"}", bandId];
    
    NSDictionary* details = [ServiceCaller postToService:@"https://bandcamp.com/api/mobile/22/band_details" withData:postData];
    
    return [self dictionaryToArtist:details];
    
}

+(Artist*) dictionaryToArtist:(NSDictionary *) dictionary {
    
    Artist* artist = [[Artist alloc] init];
    
    artist.bandId = [dictionary[@"id"] longValue];
    artist.location = dictionary[@"location"];
    artist.name = dictionary[@"name"];
    artist.biography = dictionary[@"biography"];
    artist.bandcampUrl = dictionary[@"bandcamp_url"];
    artist.bioImageId = [dictionary[@"bio_image_id"] longValue];
    
    artist.discography = [[NSMutableArray<Album*> alloc] init];
    for (int i = 0; i < [dictionary[@"discography"] count]; i++) {
        Album* album = [[Album alloc] init];
        album.artId = [dictionary[@"discography"][i][@"art_id"] longValue];
        album.imageUrl = [NSString stringWithFormat:@"https://f4.bcbits.com/img/a0%ld_8.jpg", album.artId];
        album.bandId = [dictionary[@"discography"][i][@"band_id"] longValue];
        album.itemId = [dictionary[@"discography"][i][@"item_id"] longValue];
        album.releaseDate = dictionary[@"discography"][i][@"release_date"];
        album.title = dictionary[@"discography"][i][@"title"];
        
        [artist.discography addObject:album];
    }
    
    return artist;
}

+(Album*) loadAlbumDetails:(long)albumId withBandId:(long) bandId {
    
    NSString* url = [NSString stringWithFormat: @"https://bandcamp.com/api/mobile/22/tralbum_details?band_id=%ld&tralbum_id=%ld&tralbum_type=a", bandId, albumId];
    
    NSDictionary* details = [ServiceCaller loadJsonByUrl:url withTimeoutInterval:120];
    
    return [self dictionaryToAlbum:details];
    
}

+(Album*) dictionaryToAlbum:(NSDictionary *) dictionary {
    
    Album* album = [[Album alloc] init];
    
    album.artId = [dictionary[@"art_id"] longValue];
    album.imageUrl = [NSString stringWithFormat:@"https://f4.bcbits.com/img/a0%ld_16.jpg", album.artId];
    album.title = dictionary[@"album_title"];
    album.itemId = [dictionary[@"id"] longValue];
    
    album.tracks = [[NSMutableArray<Track*> alloc] init];
    for (int i = 0; i < [dictionary[@"tracks"] count]; i++) {
        Track* track = [[Track alloc] init];
        // TODO should fix this
        track.streamingUrl = dictionary[@"tracks"][i][@"streaming_url"][@"mp3-128"];
        track.title = dictionary[@"tracks"][i][@"title"];
        
        [album.tracks addObject:track];
    }
    
    return album;
}

@end

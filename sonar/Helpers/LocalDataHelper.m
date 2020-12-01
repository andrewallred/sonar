//
//  LocalDataHelper.m
//  sonar
//
//  Created by Allred, Andrew on 11/30/20.
//  Copyright © 2020 Allred, Andrew. All rights reserved.
//

#import "LocalDataHelper.h"

@implementation LocalDataHelper

+(NSMutableArray<NSDictionary*>*) getRecentlySearchedArtists {
    
    NSData* data = [[NSUserDefaults standardUserDefaults] dataForKey:@"searchedArtists"];
    //NSMutableArray<NSDictionary*>* searchedArtists = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSMutableArray<NSDictionary*> class] fromData:data error:nil];
    
    NSMutableArray<NSDictionary*>* searchedArtists = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    return searchedArtists;
    
}

+(void) addArtistToSearchedArtists:(Artist*) artist {
    
    NSMutableArray<NSDictionary*>* searchedArtists = [self getRecentlySearchedArtists];
    if (searchedArtists == nil) {
        searchedArtists = [[NSMutableArray<NSDictionary*> alloc] init];
    }
    
    bool foundArtist = NO;
    for (int i = 0; i < [searchedArtists count]; i++) {
        Artist* savedArtist = [[Artist alloc] initWithDictionary:searchedArtists[i]];
        if (savedArtist.bandId == artist.bandId) {
            foundArtist = YES;
            break;;
        }
    }
    
    if (!foundArtist) {
        
        [searchedArtists addObject:artist.dictionary];
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:searchedArtists requiringSecureCoding:NO error:nil];

        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"searchedArtists"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
}

@end

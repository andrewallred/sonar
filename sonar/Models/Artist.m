//
//  ArtistPage.m
//  sonar
//
//  Created by Allred, Andrew on 11/29/20.
//  Copyright © 2020 Allred, Andrew. All rights reserved.
//

#import "Artist.h"
#import "Helper.h"

@implementation Artist

-(id) initWithDictionary:(NSDictionary*) dictionary {
    
    if ((self = [super init]) != nil) {
        self.bandId = [Helper idToLong:dictionary[@"id"]];
        self.name = dictionary[@"name"];
        self.imageUrl = dictionary[@"img"];
        
        self.dictionary = dictionary;
    }
    
    return self;
}

@end

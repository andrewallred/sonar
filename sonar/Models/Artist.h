//
//  ArtistPage.h
//  sonar
//
//  Created by Allred, Andrew on 11/29/20.
//  Copyright © 2020 Allred, Andrew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Album.h"

NS_ASSUME_NONNULL_BEGIN

@interface Artist : NSObject

@property (nonatomic) long bandId;
@property (nonatomic) long bioImageId;
@property (nonatomic, strong) NSString* imageUrl;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* location;
@property (nonatomic, strong) NSString* biography;
@property (nonatomic, strong) NSString* bandcampUrl;
@property (nonatomic, strong) NSMutableArray<Album*>* discography;

@property (nonatomic, strong) NSDictionary* dictionary;

-(id) initWithDictionary:(NSDictionary*) dictionary;

@end

NS_ASSUME_NONNULL_END

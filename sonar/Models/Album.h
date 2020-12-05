//
//  Album.h
//  sonar
//
//  Created by Allred, Andrew on 11/29/20.
//  Copyright © 2020 Allred, Andrew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Track.h"

NS_ASSUME_NONNULL_BEGIN

@interface Album : NSObject

@property (nonatomic) long itemId;

// 361178786
// https://f4.bcbits.com/img/a0361178786_16.jpg
@property (nonatomic) long albumId;
@property (nonatomic) long artId;
@property (nonatomic) long bandId;
@property (nonatomic, strong) NSString* bandName;
@property (nonatomic, strong) NSString* albumUrl;
@property (nonatomic, strong) NSString* imageUrl;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* url;
@property (nonatomic, strong) NSString* rightsInfo;
@property (nonatomic, strong) NSString* releaseDate;
@property (nonatomic, strong) NSMutableArray<Track*>* tracks;

@end

NS_ASSUME_NONNULL_END

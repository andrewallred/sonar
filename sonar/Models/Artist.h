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

@property (nonatomic, strong) NSMutableArray<Album*>* Albums;

@end

NS_ASSUME_NONNULL_END

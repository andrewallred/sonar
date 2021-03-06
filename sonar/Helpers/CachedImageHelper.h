//
//  CachedImageHelper.h
//  sonar
//
//  Created by Allred, Andrew on 11/30/20.
//  Copyright © 2020 Allred, Andrew. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <UIKit/UIKit.h>
#import "Album.h"

NS_ASSUME_NONNULL_BEGIN

@interface CachedImageHelper : NSObject

+(void) getImageForUrl:(NSString*) url completionHandler:(void (^)(UIImage* image))completionHandler;
+(void) getAndDisplayImageForUrlAsync:(NSString*) url withImageView:(UIImageView*) imageView withParent:(nullable UIView*) parent;
+(void) getAndDisplayAlbumImageForUrlAsync:(Album*) album withImageView:(UIImageView*) imageView withParent:(nullable UITableViewCell*) cell;

@end

NS_ASSUME_NONNULL_END

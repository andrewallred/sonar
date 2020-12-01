//
//  CachedImageHelper.m
//  sonar
//
//  Created by Allred, Andrew on 11/30/20.
//  Copyright © 2020 Allred, Andrew. All rights reserved.
//

#import "CachedImageHelper.h"
#import "ServiceCaller.h"

@implementation CachedImageHelper

NSCache<NSString*, UIImage*>* imageCache;

+(UIImage*) getImageForUrl:(NSString*) url {
    
    if (imageCache == nil) {
        imageCache = [[NSCache<NSString*, UIImage*> alloc] init];
    }
    
    UIImage* cachedImage = [imageCache objectForKey:url];
    if (cachedImage == nil) {
        NSData* imageData = [ServiceCaller loadDataByUrl:url];
        cachedImage = [UIImage imageWithData:imageData];
        if (cachedImage != nil) {
            [imageCache setObject:cachedImage forKey:url];
        }
    }
    
    return cachedImage;
    
}

@end

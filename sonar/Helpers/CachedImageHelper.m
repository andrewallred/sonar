//
//  CachedImageHelper.m
//  sonar
//
//  Created by Allred, Andrew on 11/30/20.
//  Copyright © 2020 Allred, Andrew. All rights reserved.
//

#import "CachedImageHelper.h"
#import "ServiceCaller.h"
#import "ServiceCallerAsync.h"

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

+(void) getAndDisplayImageForUrlAsync:(NSString*) url withImageView:(UIImageView*) imageView withParent:(UIView*) parent {
    
    [ServiceCallerAsync getDataForUrl:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (imageCache == nil) {
            imageCache = [[NSCache<NSString*, UIImage*> alloc] init];
        }
        
        UIImage* cachedImage = [imageCache objectForKey:url];
        if (cachedImage == nil) {
            cachedImage = [UIImage imageWithData:data];
            if (cachedImage != nil) {
                [imageCache setObject:cachedImage forKey:url];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            imageView.image = cachedImage;
            [imageView setNeedsLayout];
            [parent setNeedsLayout];
            NSLog(@"image loaded");
        });
        
    }];
    
}

@end

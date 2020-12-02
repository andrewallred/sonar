//
//  CachedImageHelper.h
//  sonar
//
//  Created by Allred, Andrew on 11/30/20.
//  Copyright © 2020 Allred, Andrew. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CachedImageHelper : NSObject

+(UIImage*) getImageForUrl:(NSString*) url;
+(void) getAndDisplayImageForUrlAsync:(NSString*) url withImageView:(UIImageView*) imageView withParent:(UIView*) parent;

@end

NS_ASSUME_NONNULL_END

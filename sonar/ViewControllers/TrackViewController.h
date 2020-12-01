//
//  TrackViewController.h
//  sonar
//
//  Created by Allred, Andrew on 11/30/20.
//  Copyright © 2020 Allred, Andrew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Album.h"
#import "Track.h"

NS_ASSUME_NONNULL_BEGIN

@interface TrackViewController : UIViewController

@property (weak, nonatomic) Album* album;
@property (weak, nonatomic) Track* currentTrack;

@end

NS_ASSUME_NONNULL_END

//
//  ArtistViewController.h
//  sonar
//
//  Created by Allred, Andrew on 11/29/20.
//  Copyright © 2020 Allred, Andrew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BandcampService.h"

NS_ASSUME_NONNULL_BEGIN

@interface ArtistViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *albumsCollectionView;
@property (weak, nonatomic) IBOutlet UIImageView *artistImageView;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;

@property (nonatomic) long bandId;
@property (strong, atomic) Artist* artist;

@end

NS_ASSUME_NONNULL_END

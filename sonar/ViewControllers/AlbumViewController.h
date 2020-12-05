//
//  AlbumViewController.h
//  sonar
//
//  Created by Allred, Andrew on 11/29/20.
//  Copyright © 2020 Allred, Andrew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Album.h"

NS_ASSUME_NONNULL_BEGIN

@interface AlbumViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *songsTableView;
@property (weak, nonatomic) IBOutlet UIImageView *albumImageView;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *albumLabel;
@property (weak, nonatomic) IBOutlet UILabel *releasedLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightsLabel;

@property (nonatomic, strong) Album* album;

@property (strong, atomic) NSMutableArray<Track*>* Track;

@end

NS_ASSUME_NONNULL_END

//
//  AlbumViewController.m
//  sonar
//
//  Created by Allred, Andrew on 11/29/20.
//  Copyright © 2020 Allred, Andrew. All rights reserved.
//

#import "AlbumViewController.h"
#import "BandcampService.h"
#include <AVFoundation/AVFoundation.h>
#include <AVKit/AVKit.h>
#import "ServiceCaller.h"

@interface AlbumViewController ()

@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) Album* album;
@property (strong, nonatomic) NSCache<NSString*, UIImage*>* imageCache;

@end

@implementation AlbumViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.songsTableView.delegate = self;
    self.songsTableView.dataSource = self;
    
    self.album = [BandcampService loadAlbum:self.albumUrl];
    
    [self.songsTableView reloadData];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Song* song = self.album.songs[indexPath.row];
    
    cell.textLabel.text = song.audioUrl;
    
//    NSString* imageUrl = resultItem[@"img"];
//    UIImage* cachedImage = [imageCache objectForKey:imageUrl];
//    if (cachedImage == nil) {
//        NSData* imageData = [ServiceCaller loadDataByUrl:imageUrl];
//        cachedImage = [UIImage imageWithData:imageData];
//        [imageCache setObject:cachedImage forKey:imageUrl];
//    }
    
//    cell.imageView.image = cachedImage;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.album.songs count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger selectedRow = [indexPath row];
    
    Song* song = self.album.songs[selectedRow];
    
    [self playAudio:song onAlbum:self.album];
}

- (void) playAudio: (Song*) song onAlbum:(Album*) album {
    NSURL *url = [NSURL URLWithString:song.audioUrl];
    
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:avAsset];
    self.player = [AVPlayer playerWithPlayerItem:playerItem];
    
    AVPlayerViewController *playerViewController = [[AVPlayerViewController alloc] init];
    playerViewController.player = self.player;
    
    // show the view controller
    [self addChildViewController:playerViewController];
    [self.view addSubview:playerViewController.view];
    playerViewController.view.frame = self.view.frame;
    
    if (album.imageUrl != nil) {
        
        UIImage* cachedImage = [self.imageCache objectForKey:album.imageUrl];
        if (cachedImage == nil) {
            NSData* imageData = [ServiceCaller loadDataByUrl:album.imageUrl];
            cachedImage = [UIImage imageWithData:imageData];
            [self.imageCache setObject:cachedImage forKey:album.imageUrl];
        }
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:cachedImage];
        
        [playerViewController.contentOverlayView addSubview:imageView];
        
    }
    
    [self.player play];
}

@end

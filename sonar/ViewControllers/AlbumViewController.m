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
@property (strong, nonatomic) Album* Album;
@property (strong, nonatomic) NSCache<NSString*, UIImage*>* ImageCache;

@end

@implementation AlbumViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.SongsTableView.delegate = self;
    self.SongsTableView.dataSource = self;
    
    self.Album = [BandcampService loadAlbum:self.AlbumUrl];
    
    [self.SongsTableView reloadData];
    
}





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Song* song = self.Album.Songs[indexPath.row];
    
    cell.textLabel.text = song.AudioUrl;
    
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
    return [self.Album.Songs count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger selectedRow = [indexPath row];
    
    Song* song = self.Album.Songs[selectedRow];
    
    [self playAudio:song onAlbum:self.Album];
}

- (void) playAudio: (Song*) song onAlbum:(Album*) album {
    NSURL *url = [NSURL URLWithString:song.AudioUrl];
    
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:avAsset];
    self.player = [AVPlayer playerWithPlayerItem:playerItem];
    
    AVPlayerViewController *playerViewController = [[AVPlayerViewController alloc] init];
    playerViewController.player = self.player;
    
    // show the view controller
    [self addChildViewController:playerViewController];
    [self.view addSubview:playerViewController.view];
    playerViewController.view.frame = self.view.frame;
    
    if (album.ImageUrl != nil) {
        
        UIImage* cachedImage = [self.ImageCache objectForKey:album.ImageUrl];
        if (cachedImage == nil) {
            NSData* imageData = [ServiceCaller loadDataByUrl:album.ImageUrl];
            cachedImage = [UIImage imageWithData:imageData];
            [self.ImageCache setObject:cachedImage forKey:album.ImageUrl];
        }
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:cachedImage];
        
        [playerViewController.contentOverlayView addSubview:imageView];
        
    }
    
    [self.player play];
}

@end

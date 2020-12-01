//
//  AlbumViewController.m
//  sonar
//
//  Created by Allred, Andrew on 11/29/20.
//  Copyright © 2020 Allred, Andrew. All rights reserved.
//

#import "AlbumViewController.h"
#import "BandcampService.h"
#import "BandcampMobileService.h"
#include <AVFoundation/AVFoundation.h>
#include <AVKit/AVKit.h>
#import "ServiceCaller.h"
#import "Album.h"

@interface AlbumViewController ()

@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) NSCache<NSString*, UIImage*>* imageCache;

@end

@implementation AlbumViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.songsTableView.delegate = self;
    self.songsTableView.dataSource = self;
    
    self.album = [BandcampMobileService loadAlbumDetails:self.album.itemId withBandId:self.album.bandId];
    
    [self.songsTableView reloadData];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Track* track = self.album.tracks[indexPath.row];
    
    cell.textLabel.text = track.title;
    
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
    return [self.album.tracks count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger selectedRow = [indexPath row];
    
    Track* track = self.album.tracks[selectedRow];
    
    [self playAudio:track onAlbum:self.album];
}

- (void) playAudio: (Track*) track onAlbum:(Album*) album {
    NSURL *url = [NSURL URLWithString:track.streamingUrl];
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

-(void)playerDidFinishPlaying:(NSNotification *) notification {
    NSLog(@"Track finished");
}

@end

//
//  TrackViewController.m
//  sonar
//
//  Created by Allred, Andrew on 11/30/20.
//  Copyright © 2020 Allred, Andrew. All rights reserved.
//

#import "TrackViewController.h"
#include <AVFoundation/AVFoundation.h>
#include <AVKit/AVKit.h>
#import "CachedImageHelper.h"

@interface TrackViewController ()

@property (strong, nonatomic) AVQueuePlayer *playerQueue;
@property (strong, nonatomic) UIImage* albumImage;

@end

@implementation TrackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated {
    
    [self playAudio:self.currentTrack onAlbum:self.album];
    
}

- (void) playAudio: (Track*) track onAlbum:(Album*) album {
    
    self.currentTrack = track;
    
    
    NSURL* url = [NSURL URLWithString:track.streamingUrl];
    
    AVURLAsset* avAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    
    AVPlayerItem* playerItem = [AVPlayerItem playerItemWithAsset:avAsset];
    [self addMetadataToPlayerItem:playerItem Track:track Album:album];
    
    self.playerQueue = [[AVQueuePlayer alloc] initWithItems:@[playerItem]];
    
    AVPlayerItem* lastPlayerItem = playerItem;
    
    for (int i = track.number + 1; i < [album.tracks count]; i++) {
        
        if (album.tracks[i].streamingUrl != nil && ![album.tracks[i].streamingUrl isEqual:[NSNull null]]) {
            
            url = [NSURL URLWithString:album.tracks[i].streamingUrl];
            
            AVURLAsset* avAsset = [AVURLAsset URLAssetWithURL:url options:nil];
            
            AVPlayerItem* playerItem = [AVPlayerItem playerItemWithAsset:avAsset];
            [self addMetadataToPlayerItem:playerItem Track:album.tracks[i] Album:album];
            
            [self.playerQueue insertItem:playerItem afterItem:lastPlayerItem];
            
            lastPlayerItem = playerItem;

        }
                
    }
    
    AVPlayerViewController *playerViewController = [[AVPlayerViewController alloc] init];
    playerViewController.player = self.playerQueue;
    
    // show the view controller
    [self addChildViewController:playerViewController];
    [self.view addSubview:playerViewController.view];
    playerViewController.view.frame = self.view.frame;
    
    if (album.imageUrl != nil) {
        
        NSString* imageUrl = self.album.imageUrl;
        
        [CachedImageHelper getImageForUrl:imageUrl completionHandler:^(UIImage * _Nonnull image) {
            
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            [playerViewController.contentOverlayView addSubview:imageView];
            
            // might not be ideal, will review
            CGRect screenBound = [[UIScreen mainScreen] bounds];
            CGSize screenSize = screenBound.size;
            
            imageView.center = CGPointMake(screenSize.width  / 2,
                                           screenSize.height / 2);
            
        }];
        
    }
    
    [self.playerQueue play];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerQueue.currentItem];
}

-(void) addMetadataToPlayerItem:(AVPlayerItem*) playerItem Track:(Track*) track Album:(Album*) album {
    
    AVMutableMetadataItem *titleMetadataItem = [[AVMutableMetadataItem alloc] init];
    titleMetadataItem.locale = [NSLocale currentLocale];
    titleMetadataItem.key = AVMetadataCommonKeyTitle;
    titleMetadataItem.keySpace = AVMetadataKeySpaceCommon;
    titleMetadataItem.value = track.title;
    
    AVMutableMetadataItem *albumMetadataItem = [[AVMutableMetadataItem alloc] init];
    albumMetadataItem.locale = [NSLocale currentLocale];
    albumMetadataItem.key = AVMetadataCommonKeyAlbumName;
    albumMetadataItem.keySpace = AVMetadataKeySpaceCommon;
    albumMetadataItem.value = album.title;

    AVMutableMetadataItem *artistMetadataItem = [[AVMutableMetadataItem alloc] init];
    artistMetadataItem.locale = [NSLocale currentLocale];
    artistMetadataItem.key = AVMetadataCommonKeyArtist;
    artistMetadataItem.keySpace = AVMetadataKeySpaceCommon;
    artistMetadataItem.value = album.bandName;
    
    if (titleMetadataItem == nil) {
        titleMetadataItem.value = @"";
    }
    if (albumMetadataItem == nil) {
        albumMetadataItem.value = @"";
    }
    if (artistMetadataItem == nil) {
        artistMetadataItem.value = @"";
    }
    
    NSArray *metadataArray = [[NSArray alloc] initWithObjects:titleMetadataItem,albumMetadataItem,artistMetadataItem, nil];
    
    playerItem.externalMetadata = metadataArray;
    
}

-(void)playerDidFinishPlaying:(NSNotification *) notification {
    NSLog(@"Track finished");
    
    if (self.currentTrack.number + 1 == [self.album.tracks count]) {
        
        [self.playerQueue replaceCurrentItemWithPlayerItem:nil];
        
        NSLog(@"Album finished");
        [self dismissViewControllerAnimated:YES completion:^{
            NSLog(@"Returned to album view");
        }];
        
    }
}

@end

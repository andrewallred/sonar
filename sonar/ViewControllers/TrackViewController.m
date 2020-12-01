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

@interface TrackViewController ()

@property (strong, nonatomic) AVPlayer *player;
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
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:self.albumImage];
        [playerViewController.contentOverlayView addSubview:imageView];
        
    }
    
    [self.player play];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

-(void)playerDidFinishPlaying:(NSNotification *) notification {
    NSLog(@"Track finished");
    
    if (self.currentTrack.number + 1 < [self.album.tracks count]) {
        [self playAudio:self.album.tracks[self.currentTrack.number + 1] onAlbum:self.album];
    }
}

@end

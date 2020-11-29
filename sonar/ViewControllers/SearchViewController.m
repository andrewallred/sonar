//
//  ViewController.m
//  sonar
//
//  Created by Allred, Andrew on 11/29/20.
//  Copyright © 2020 Allred, Andrew. All rights reserved.
//

#import "SearchViewController.h"
#include <AVFoundation/AVFoundation.h>
#include <AVKit/AVKit.h>
#import "RegexHelper.h"
#import "BandcampService.h"
#import "ServiceCaller.h"

@interface SearchViewController ()

@property (strong, nonatomic) AVPlayer *player;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.searchTableView.delegate = self;
    self.searchTableView.dataSource = self;
    
    self.searchResults = [[NSMutableSet alloc] init];
    
}

NSCache<NSString*, UIImage*> *imageCache;
- (IBAction)searchEditingDidEnd:(id)sender {
    
    imageCache = [[NSCache<NSString*, UIImage*> alloc] init];
    
    NSLog(@"search term %@", _searchTextField.text);
    
    NSDictionary *searchResults = [BandcampService loadSearchResults:_searchTextField.text];
    
    [self.searchResults removeAllObjects];
    
    for (int i = 0; i < [searchResults[@"auto"][@"results"] count]; i++) {
        
        NSDictionary* searchResult = searchResults[@"auto"][@"results"][i];
        if ([searchResult[@"type"] isEqualToString:@"b"]) {
            [self.searchResults addObject:searchResult];
        }
        
    }
    
    [self.searchTableView reloadData];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger selectedRow = [indexPath row];
    
    NSDictionary* o = [self.searchResults allObjects][selectedRow];
    
    NSString* url = o[@"url"];

    url = [NSString stringWithFormat:@"%@/music", url];

    //[self loadArtistPage:url];
    Artist* artist = [BandcampService loadArtist:url];
    
    if ([artist.Albums count] > 0) {
        Album* album = [BandcampService loadAlbum:artist.Albums[0].Url];
        
        if ([album.Songs count] > 0) {
            [self playAudio:album.Songs[0] onAlbum:album];
        }
    }
    
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
        
        UIImage* cachedImage = [imageCache objectForKey:album.ImageUrl];
        if (cachedImage == nil) {
            NSData* imageData = [ServiceCaller loadDataByUrl:album.ImageUrl];
            cachedImage = [UIImage imageWithData:imageData];
            [imageCache setObject:cachedImage forKey:album.ImageUrl];
        }
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:cachedImage];
        
        [playerViewController.contentOverlayView addSubview:imageView];
        
    }
    
    [self.player play];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary* resultItem = [self.searchResults allObjects][indexPath.row];
    
    cell.textLabel.text = resultItem[@"name"];
    
    NSString* imageUrl = resultItem[@"img"];
    UIImage* cachedImage = [imageCache objectForKey:imageUrl];
    if (cachedImage == nil) {
        NSData* imageData = [ServiceCaller loadDataByUrl:imageUrl];
        cachedImage = [UIImage imageWithData:imageData];
        [imageCache setObject:cachedImage forKey:imageUrl];
    }
    
    cell.imageView.image = cachedImage;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.searchResults count];
}


@end

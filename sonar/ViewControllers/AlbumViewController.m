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
#import "ServiceCaller.h"
#import "Album.h"
#import "CachedImageHelper.h"
#import "TrackViewController.h"

@interface AlbumViewController ()

@property (strong, nonatomic) UIImage* albumImage;
@property (weak, nonatomic) Track* selectedTrack;

@end

@implementation AlbumViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.songsTableView.delegate = self;
    self.songsTableView.dataSource = self;
    self.songsTableView.backgroundColor = [UIColor clearColor];
    
    self.album = [BandcampMobileService loadAlbumDetails:self.album.itemId withBandId:self.album.bandId];
    
    self.artistLabel.text = self.album.bandName;
    self.albumLabel.text = self.album.title;
    self.releasedLabel.text = self.album.releaseDate;
    
    self.albumImage = [CachedImageHelper getImageForUrl:self.album.imageUrl];
    self.albumImageView.image = self.albumImage;
    
    [self.songsTableView reloadData];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Track* track = self.album.tracks[indexPath.row];
    
    cell.textLabel.text = track.title;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.album.tracks count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger selectedRow = [indexPath row];
    
    self.selectedTrack = self.album.tracks[selectedRow];
    
    // TODO
    [self performSegueWithIdentifier:@"TrackSegue" sender:self];
    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    UIViewController *destinationViewController = segue.destinationViewController;
    if ([destinationViewController isKindOfClass:[TrackViewController class]])
    {
        ((TrackViewController *)destinationViewController).album = self.album;
        ((TrackViewController *)destinationViewController).currentTrack = self.selectedTrack;
    }
}

@end

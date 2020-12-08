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
#import "Album.h"
#import "CachedImageHelper.h"
#import "TrackViewController.h"
#import "LogHelper.h"

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
    
    self.artistLabel.text = @"";
    self.albumLabel.text = @"";
    self.releasedLabel.text = @"";
    self.rightsLabel.text = @"";
    
    [BandcampMobileService loadAlbumDetails:self.album.itemId withBandId:self.album.bandId completionHandler:^(Album * _Nonnull album, NSError * _Nullable error) {
        
        if (error != nil) {
            
            [LogHelper logError:error];
            [self displayError];
            return;
            
        } else if (album == nil || album.albumId == 0) {
            
            NSLog(@"No album id found, displaying error message.");
            [self displayError];
            return;
        }
        
        self.album = album;
        
        [BandcampService loadAlbumFromHtml:album.albumUrl completionHandler:^(Album * _Nonnull album, NSError * _Nullable error) {
            
            self.album.rightsInfo = album.rightsInfo;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.rightsLabel.alpha = 0;
                self.rightsLabel.text = self.album.rightsInfo;
                [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn
                                 animations:^{ self.rightsLabel.alpha = 1;}
                                 completion:nil];
            });
            
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.artistLabel.text = self.album.bandName;
            self.albumLabel.text = self.album.title;
            self.releasedLabel.text = self.album.releaseDate;
            
            [CachedImageHelper getAndDisplayImageForUrlAsync:self.album.imageUrl withImageView:self.albumImageView withParent:nil];
            
            [self.songsTableView reloadData];
            
        });
        
    }];
    
}

-(void) displayError {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.artistLabel.text = @"Error...";
        self.albumImageView.image = [UIImage imageNamed:@"image-not-found"];
        
        [self.songsTableView reloadData];
        
    });
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.imageView.image = nil;
    
    Track* track = self.album.tracks[indexPath.row];
    
    cell.textLabel.text = track.title;
    
    if (track.streamingUrl == nil) {
        cell.textLabel.textColor = [UIColor lightGrayColor];
    }
    
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
    
    if (self.selectedTrack.streamingUrl != nil) {        
        [self performSegueWithIdentifier:@"TrackSegue" sender:self];
    }
    
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

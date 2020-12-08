//
//  ArtistViewController.m
//  sonar
//
//  Created by Allred, Andrew on 11/29/20.
//  Copyright © 2020 Allred, Andrew. All rights reserved.
//

#import "ArtistViewController.h"
#import "AlbumViewController.h"
#import "CachedImageHelper.h"
#import "BandcampMobileService.h"
#import "LogHelper.h"

@interface ArtistViewController ()

@property (strong, nonatomic) UIImage* artistImage;

@end

@implementation ArtistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.albumsTableView.delegate = self;
    self.albumsTableView.dataSource = self;
    self.albumsTableView.backgroundColor = [UIColor clearColor];
    
    self.artistLabel.text = @"";
    
    [BandcampMobileService loadBandDetails:self.bandId completionHandler:^(Artist * _Nonnull artist, NSError * _Nullable error) {
        
        if (error != nil || artist == nil) {
            
            [LogHelper logError:error];
            [self displayError];
            return;
            
        }
        
        self.artist = artist;
        
        [CachedImageHelper getAndDisplayImageForUrlAsync:self.artist.imageUrl withImageView:self.artistImageView withParent:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.artistLabel.text = self.artist.name;
            [self.albumsTableView reloadData];
            
        });
        
    }];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.imageView.image = nil;
    
    Album* album = self.artist.discography[indexPath.row];
    
    cell.textLabel.text = album.title;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.artist.discography count];
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Album* album = self.artist.discography[indexPath.row];
    
    [CachedImageHelper getAndDisplayImageForUrlAsync:album.imageUrl withImageView:cell.imageView withParent:cell];
    
}

Album* selectedAlbum;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger selectedRow = [indexPath row];
    
    selectedAlbum = self.artist.discography[selectedRow];
    
    [self performSegueWithIdentifier:@"AlbumSegue" sender:self];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    UIViewController *destinationViewController = segue.destinationViewController;
    if ([destinationViewController isKindOfClass:[AlbumViewController class]])
    {
        ((AlbumViewController *)destinationViewController).album = selectedAlbum;
    }
}

-(void) displayError {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.artistLabel.text = @"Error...";
        self.artistImageView.image = [UIImage imageNamed:@"image-not-found"];
        
        [self.albumsTableView reloadData];
        
    });
    
}

@end

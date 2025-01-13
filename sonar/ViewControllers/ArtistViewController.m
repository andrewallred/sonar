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
#import "../UIClasses/ImageCollectionViewCell.h"

@interface ArtistViewController ()

@property (strong, nonatomic) UIImage* artistImage;

@end

@implementation ArtistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set up the collection view layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    CGFloat width = self.albumsCollectionView.frame.size.width / 4;  // For 3 items per row
    NSLog(@"Width %i", width);
    layout.itemSize = CGSizeMake(width, width);
    layout.minimumInteritemSpacing = 10;    // Set spacing between items
    
    self.albumsCollectionView.collectionViewLayout = layout;
    
    self.albumsCollectionView.dataSource = self;
    self.albumsCollectionView.delegate = self;
    
    [self.albumsCollectionView registerClass:[ImageCollectionViewCell class] forCellWithReuseIdentifier:@"ImageCell"];
    
    self.albumsCollectionView.userInteractionEnabled = YES;
    
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
            [self.albumsCollectionView reloadData];
            
        });
        
    }];
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];
    
    NSLog(@"Cell at %li", (long)indexPath.row);
    
    Album* album = self.artist.discography[indexPath.row];
    
    cell.titleLabel.text = album.title;
    
    // Get image for the current index
    [CachedImageHelper getAndDisplayImageForUrlAsync:album.imageUrl withImageView:cell.imageView withParent:cell];
    
    return cell;
}

Album* selectedAlbum;
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
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
        
        [self.albumsCollectionView reloadData];
        
    });
    
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section { 
    return [self.artist.discography count];
}








@end

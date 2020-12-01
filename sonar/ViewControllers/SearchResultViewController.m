//
//  SearchResultViewController.m
//  sonar
//
//  Created by Allred, Andrew on 11/29/20.
//  Copyright © 2020 Allred, Andrew. All rights reserved.
//

#import "SearchResultViewController.h"
#import "AlbumViewController.h"
#import "CachedImageHelper.h"
#import "BandcampMobileService.h"

@interface SearchResultViewController ()

@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.albumsTableView.delegate = self;
    self.albumsTableView.dataSource = self;
    
    self.artist = [BandcampMobileService loadBandDetails:self.bandId];
    
    [self.albumsTableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Album* album = self.artist.discography[indexPath.row];
    
    cell.textLabel.text = album.title;
    
    NSString* imageUrl = album.imageUrl;
    cell.imageView.image = cell.imageView.image = [CachedImageHelper getImageForUrl:imageUrl];;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.artist.discography count];
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

@end

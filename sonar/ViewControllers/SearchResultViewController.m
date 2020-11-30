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

@interface SearchResultViewController ()

@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.albumsTableView.delegate = self;
    self.albumsTableView.dataSource = self;
    
    self.artist = [BandcampService loadArtist:_searchResultUrl];
    
    [self.albumsTableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Album* album = self.artist.albums[indexPath.row];
    
    cell.textLabel.text = album.name;
    
    NSString* imageUrl = album.imageUrl;
    cell.imageView.image = cell.imageView.image = [CachedImageHelper getImageForUrl:imageUrl];;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.artist.albums count];
}

NSString* albumUrl;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger selectedRow = [indexPath row];
    
    Album* album = self.artist.albums[selectedRow];
    albumUrl = album.url;
    
    [self performSegueWithIdentifier:@"AlbumSegue" sender:self];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    UIViewController *destinationViewController = segue.destinationViewController;
    if ([destinationViewController isKindOfClass:[AlbumViewController class]])
    {
        ((AlbumViewController *)destinationViewController).albumUrl = albumUrl;
    }
}

@end

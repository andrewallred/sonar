//
//  SearchResultViewController.m
//  sonar
//
//  Created by Allred, Andrew on 11/29/20.
//  Copyright © 2020 Allred, Andrew. All rights reserved.
//

#import "SearchResultViewController.h"
#import "AlbumViewController.h"

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

NSCache<NSString*, UIImage*> *imageCache2;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Album* album = self.artist.albums[indexPath.row];
    
    cell.textLabel.text = album.url;
    
    NSString* imageUrl = album.imageUrl;
    UIImage* cachedImage = [imageCache2 objectForKey:imageUrl];
    if (cachedImage == nil) {
        NSData* imageData = [ServiceCaller loadDataByUrl:imageUrl];
        cachedImage = [UIImage imageWithData:imageData];
        [imageCache2 setObject:cachedImage forKey:imageUrl];
    }
    
    cell.imageView.image = cachedImage;
    
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

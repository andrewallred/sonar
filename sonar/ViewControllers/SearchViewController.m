//
//  ViewController.m
//  sonar
//
//  Created by Allred, Andrew on 11/29/20.
//  Copyright © 2020 Allred, Andrew. All rights reserved.
//

#import "SearchViewController.h"
#import "RegexHelper.h"
#import "BandcampService.h"
#import "ArtistViewController.h"
#import "CachedImageHelper.h"
#import "LocalDataHelper.h"
#import "LogHelper.h"
#import "../UIClasses/ImageCollectionViewCell.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Set up the collection view layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    CGFloat width = self.view.bounds.size.width / 5;  // For 3 items per row
    layout.itemSize = CGSizeMake(width, width);
    layout.minimumInteritemSpacing = 10;    // Set spacing between items
    
    self.searchCollectionView.collectionViewLayout = layout;
    
    self.searchCollectionView.dataSource = self;
    self.searchCollectionView.delegate = self;
    
    [self.searchCollectionView registerClass:[ImageCollectionViewCell class] forCellWithReuseIdentifier:@"ImageCell"];
    
    self.searchCollectionView.userInteractionEnabled = YES;
    
    if (self.artists == nil) {
        self.artists = [[NSMutableArray<Artist*> alloc] init];
    }
    
    [self loadSavedSearches];
    
}

-(void) loadSavedSearches {
    
    NSArray<NSDictionary*>* savedSearches = [LocalDataHelper getRecentlySearchedArtists];
    
    [self.artists removeAllObjects];
    
    for (int i = 0; i < [savedSearches count]; i++) {
        Artist* artist = [[Artist alloc] initWithDictionary:savedSearches[i]];
        [self.artists addObject:artist];
    }
    
    [self reloadData];
    
}

- (IBAction)searchEditingDidBegin:(id)sender {
    _searchTextField.text = @"";
    
    [self.artists removeAllObjects];
    
    [self reloadData];
}

- (IBAction)searchEditingDidEnd:(id)sender {
    
    NSLog(@"search term %@", _searchTextField.text);
    
    if ([_searchTextField.text isEqualToString:@""]) {
        
        [self loadSavedSearches];
        
    } else {
        
        [BandcampService loadSearchResults:_searchTextField.text completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            NSLog(@"Search results found!");
            
            if (error != nil) {
                
                [LogHelper logError:error];
                // TODO alert the user?
                return;
                
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSError* error;
                
                NSDictionary *searchResults = [NSJSONSerialization
                                               JSONObjectWithData:data
                                               options:NSJSONReadingMutableLeaves
                                               error:&error];
                
                [LogHelper logError:error];
                // TODO alert the user?
                
                [self.artists removeAllObjects];
                
                NSLog([searchResults description]);
                
                for (int i = 0; i < [searchResults[@"results"] count]; i++) {
                    
                    NSLog(@"Found result");
                    
                    NSDictionary* searchResult = searchResults[@"results"][i];
                    if ([searchResult[@"type"] isEqualToString:@"b"]) {
                        
                        Artist* artist = [[Artist alloc] initWithDictionary:searchResults[@"results"][i]];
                        [self.artists addObject:artist];
                    }
                    
                }
                
                [self reloadData];
                
            });
            
        }];
        
    }
    
}

long bandId;

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    UIViewController *destinationViewController = segue.destinationViewController;
    if ([destinationViewController isKindOfClass:[ArtistViewController class]])
    {
        ((ArtistViewController *)destinationViewController).bandId = bandId;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"Count %i", self.artists.count);
    return self.artists.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];
    
    NSLog(@"Cell at %i", indexPath.row);
    
    Artist* artist = self.artists[indexPath.row];
    
    cell.titleLabel.text = artist.name;
    
    // Get image for the current index
    [CachedImageHelper getAndDisplayImageForUrlAsync:artist.imageUrl withImageView:cell.imageView withParent:cell];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"Selected %i", indexPath.row);
    
    NSInteger selectedRow = [indexPath row];
    bandId = self.artists[selectedRow].bandId;
    
    [LocalDataHelper addArtistToSearchedArtists:self.artists[selectedRow]];
    
    [self performSegueWithIdentifier:@"SearchResultSegue" sender:self];
    
}

-(void) reloadData {
    
    if (self.searchCollectionView != nil) {
        [self.searchCollectionView reloadData];
    }
    
}


@end

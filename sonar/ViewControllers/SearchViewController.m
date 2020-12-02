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

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.searchTableView.delegate = self;
    self.searchTableView.dataSource = self;
    self.searchTableView.backgroundColor = [UIColor clearColor];
    
    NSArray<NSDictionary*>* savedSearches = [LocalDataHelper getRecentlySearchedArtists];
    
    if (self.artists == nil) {
        self.artists = [[NSMutableArray<Artist*> alloc] init];
    }
    
    for (int i = 0; i < [savedSearches count]; i++) {
        Artist* artist = [[Artist alloc] initWithDictionary:savedSearches[i]];
        [self.artists addObject:artist];
    }
    
    [self.searchTableView reloadData];
    
}

- (IBAction)searchEditingDidEnd:(id)sender {
    
    NSLog(@"search term %@", _searchTextField.text);
    
    [BandcampService loadSearchResults:_searchTextField.text completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
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
            
            for (int i = 0; i < [searchResults[@"auto"][@"results"] count]; i++) {
                
                NSDictionary* searchResult = searchResults[@"auto"][@"results"][i];
                if ([searchResult[@"type"] isEqualToString:@"b"]) {
                    
                    Artist* artist = [[Artist alloc] initWithDictionary:searchResults[@"auto"][@"results"][i]];
                    [self.artists addObject:artist];
                }
                
            }
            
            [self.searchTableView reloadData];
            
        });
        
    }];
    
}

long bandId;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger selectedRow = [indexPath row];
    bandId = self.artists[selectedRow].bandId;
    
    [LocalDataHelper addArtistToSearchedArtists:self.artists[selectedRow]];
    
    [self performSegueWithIdentifier:@"SearchResultSegue" sender:self];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    UIViewController *destinationViewController = segue.destinationViewController;
    if ([destinationViewController isKindOfClass:[ArtistViewController class]])
    {
        ((ArtistViewController *)destinationViewController).bandId = bandId;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.imageView.image = nil;
    
    Artist* artist = self.artists[indexPath.row];
    
    cell.textLabel.text = artist.name;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.artists count];
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {    
    
    Artist* artist = self.artists[indexPath.row];
    
    [CachedImageHelper getAndDisplayImageForUrlAsync:artist.imageUrl withImageView:cell.imageView withParent:cell];
    
}


@end

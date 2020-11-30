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
#import "ServiceCaller.h"
#import "SearchResultViewController.h"
#import "CachedImageHelper.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.searchTableView.delegate = self;
    self.searchTableView.dataSource = self;
    
    self.searchResults = [[NSMutableSet alloc] init];
    
}

- (IBAction)searchEditingDidEnd:(id)sender {
    
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

NSString* searchResultUrl;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger selectedRow = [indexPath row];
    
    NSDictionary* o = [self.searchResults allObjects][selectedRow];
    
    NSString* url = o[@"url"];

    url = [NSString stringWithFormat:@"%@/music", url];
    
    searchResultUrl = url;
    
    [self performSegueWithIdentifier:@"SearchResultSegue" sender:self];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    UIViewController *destinationViewController = segue.destinationViewController;
    if ([destinationViewController isKindOfClass:[SearchResultViewController class]])
    {
        ((SearchResultViewController *)destinationViewController).searchResultUrl = searchResultUrl;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary* resultItem = [self.searchResults allObjects][indexPath.row];
    
    cell.textLabel.text = resultItem[@"name"];
    
    NSString* imageUrl = resultItem[@"img"];
    cell.imageView.image = [CachedImageHelper getImageForUrl:imageUrl];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.searchResults count];
}


@end

//
//  ViewController.m
//  sonar
//
//  Created by Allred, Andrew on 11/29/20.
//  Copyright © 2020 Allred, Andrew. All rights reserved.
//

#import "SearchViewController.h"
#include <AVFoundation/AVFoundation.h>
#import "ServiceCaller.h"
#import "RegexHelper.h"

@interface SearchViewController ()

@property (strong, nonatomic) AVPlayer *player;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.searchTableView.delegate = self;
    self.searchTableView.dataSource = self;
    
    self.searchResults = [[NSMutableSet alloc] init];
    
}

NSCache<NSString*, UIImage*> *imageCache;
- (IBAction)searchEditingDidEnd:(id)sender {
    
    imageCache = [[NSCache<NSString*, UIImage*> alloc] init];
    
    NSLog(@"search term %@", _searchTextField.text);
    
    NSString *url = [NSString stringWithFormat:@"https://bandcamp.com/api/fuzzysearch/1/autocomplete?q=%@",
                     [ServiceCaller encodeParameter:_searchTextField.text]];
    
    NSData* data = [ServiceCaller loadDataByUrl:url];
    
    NSDictionary *objects = [NSJSONSerialization
                             JSONObjectWithData:data
                             options:NSJSONReadingMutableLeaves
                             error:nil];
    
    [self.searchResults removeAllObjects];
    
    for (int i = 0; i < [objects[@"auto"][@"results"] count]; i++) {
        
        NSDictionary* searchResult = objects[@"auto"][@"results"][i];
        if ([searchResult[@"type"] isEqualToString:@"b"]) {
            [self.searchResults addObject:searchResult];
        }
        
    }
    
    [self.searchTableView reloadData];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger selectedRow = [indexPath row];
    
    NSDictionary* o = [self.searchResults allObjects][selectedRow];
    
    NSString* url = o[@"url"];

    url = [NSString stringWithFormat:@"%@/music", url];

    [self loadArtistPage:url];
    
}

- (void) loadArtistPage: (NSString*) url {
    
    NSString *page = [ServiceCaller loadStringByUrl:url];
    
    NSArray* albumMatches = [RegexHelper regexMatchesForString: page regex:@"<a href=\"\\/album\\/[a-zA-Z0-9_\\/\"-<> \\t\\n\\r=]*<\\/a>"];
    
    NSString* albumUrl;
    for (NSTextCheckingResult *match in albumMatches) {
        NSRange matchRange = [match range];
        
        NSString* albumSection = [page substringWithRange:matchRange];
        
        NSArray* urlMatches = [RegexHelper regexMatchesForString: albumSection regex:@"<a href=\"\\/album\\/[a-zA-Z0-9_-]*\">"];
        
        for (NSTextCheckingResult *urlMatch in urlMatches) {
            NSRange urlMatchRange = [urlMatch range];
            albumUrl = [albumSection substringWithRange:urlMatchRange];
        }
        
        if (albumUrl != nil) {
            break;
        }
        
    }
    
    if (albumUrl != nil) {
        url = [url stringByReplacingOccurrencesOfString:@"/music" withString:@""];
        albumUrl = [albumUrl stringByReplacingOccurrencesOfString:@"<a href=\"" withString:url];
        albumUrl = [albumUrl stringByReplacingOccurrencesOfString:@"\">" withString:@""];
        [self loadAlbumPage:albumUrl];
    }
    
}

- (void) loadAlbumPage:(NSString*) url {
    
    //@"https://lazymagnet.bandcamp.com/album/make-it-fun-again-2020"
    NSString *page = [ServiceCaller loadStringByUrl:url];
    
    NSArray* matches = [RegexHelper regexMatchesForString: page regex:@"&quot;https:\\/\\/t4\\.bcbits\\.com[a-zA-Z0-9_\\/-]*\\?[a-zA-Z0-9_\\/-=&]*&quot;"];
    
    NSString* audioUrl;
    for (NSTextCheckingResult *match in matches) {
        NSRange matchRange = [match range];
        
        audioUrl = [page substringWithRange:matchRange];
        audioUrl = [audioUrl stringByReplacingOccurrencesOfString:@"&quot;" withString:@""];
        audioUrl = [audioUrl stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
        
        NSLog(@"%@", [page substringWithRange:matchRange]);
        
        break;
    }
    
    if (audioUrl != nil) {
        [self playAudio:audioUrl];
    }
    
}

- (void) playAudio: (NSString*) urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:avAsset];
    self.player = [AVPlayer playerWithPlayerItem:playerItem];
    [self.player play];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary* resultItem = [self.searchResults allObjects][indexPath.row];
    
    cell.textLabel.text = resultItem[@"name"];
    
    NSString* imageUrl = resultItem[@"img"];
    UIImage* cachedImage = [imageCache objectForKey:imageUrl];
    if (cachedImage == nil) {
        NSData* imageData = [ServiceCaller loadDataByUrl:imageUrl];
        cachedImage = [UIImage imageWithData:imageData];
        [imageCache setObject:cachedImage forKey:imageUrl];
    }
    
    cell.imageView.image = cachedImage;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.searchResults count];
}


@end

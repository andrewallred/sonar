//
//  ViewController.m
//  sonar
//
//  Created by Allred, Andrew on 11/29/20.
//  Copyright © 2020 Allred, Andrew. All rights reserved.
//

#import "SearchViewController.h"
#include <AVFoundation/AVFoundation.h>
#include <AVKit/AVKit.h>
#import "RegexHelper.h"
#import "BandcampService.h"
#import "ServiceCaller.h"

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
        
        coverUrl = nil;
        [self loadAlbumPage:albumUrl];
    }
    
}

NSString* coverUrl;
- (void) loadAlbumPage:(NSString*) url {
    
    //@"https://lazymagnet.bandcamp.com/album/make-it-fun-again-2020"
    NSString *page = [ServiceCaller loadStringByUrl:url];
    
    NSArray* songMatches = [RegexHelper regexMatchesForString: page regex:@"&quot;https:\\/\\/t4\\.bcbits\\.com[a-zA-Z0-9_\\/-]*\\?[a-zA-Z0-9_\\/-=&]*&quot;"];
    
    NSString* audioUrl;
    for (NSTextCheckingResult *match in songMatches) {
        NSRange matchRange = [match range];
        
        audioUrl = [page substringWithRange:matchRange];
        audioUrl = [audioUrl stringByReplacingOccurrencesOfString:@"&quot;" withString:@""];
        audioUrl = [audioUrl stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
        
        NSLog(@"%@", [page substringWithRange:matchRange]);
        
        break;
    }
    
    NSArray* coverMatches = [RegexHelper regexMatchesForString: page regex:@"<a class=\"popupImage\" href=\"[a-zA-Z0-9_:\\/.-]*"];
    for (NSTextCheckingResult *match in coverMatches) {
        NSRange matchRange = [match range];
        
        coverUrl = [page substringWithRange:matchRange];
        coverUrl = [coverUrl stringByReplacingOccurrencesOfString:@"<a class=\"popupImage\" href=\"" withString:@""];

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
    
    AVPlayerViewController *playerViewController = [[AVPlayerViewController alloc] init];
    playerViewController.player = self.player;
    
    // show the view controller
    [self addChildViewController:playerViewController];
    [self.view addSubview:playerViewController.view];
    playerViewController.view.frame = self.view.frame;
    
    
    if (coverUrl != nil) {
        
        UIImage* cachedImage = [imageCache objectForKey:coverUrl];
        if (cachedImage == nil) {
            NSData* imageData = [ServiceCaller loadDataByUrl:coverUrl];
            cachedImage = [UIImage imageWithData:imageData];
            [imageCache setObject:cachedImage forKey:coverUrl];
        }
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:cachedImage];
        
        [playerViewController.contentOverlayView addSubview:imageView];
        
    }
    
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

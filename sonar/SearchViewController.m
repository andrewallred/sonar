//
//  ViewController.m
//  sonar
//
//  Created by Allred, Andrew on 11/29/20.
//  Copyright © 2020 Allred, Andrew. All rights reserved.
//

#import "SearchViewController.h"
#include <AVFoundation/AVFoundation.h>

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

- (IBAction)searchEditingDidEnd:(id)sender {
    
    NSLog(@"search term %@", _searchTextField.text);
    
    NSString *url = [NSString stringWithFormat:@"https://bandcamp.com/api/fuzzysearch/1/autocomplete?q=%@",
                     _searchTextField.text];
    
    NSData* data = [SearchViewController loadDataByUrl:url];
    
    NSDictionary *objects = [NSJSONSerialization
                             JSONObjectWithData:data
                             options:NSJSONReadingMutableLeaves
                             error:nil];
    
    [self.searchResults removeAllObjects];
    
    for (int i = 0; i < [objects[@"auto"][@"results"] count]; i++) {
        [self.searchResults addObject:objects[@"auto"][@"results"][i]];
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
    
    NSString *page = [SearchViewController loadStringByUrl:url];
    
    NSArray* albumMatches = [SearchViewController regexMatchesForString: page regex:@"<a href=\"\\/album\\/[a-zA-Z0-9_\\/\"-<> \\t\\n\\r=]*<\\/a>"];
    
    NSString* albumUrl;
    for (NSTextCheckingResult *match in albumMatches) {
        NSRange matchRange = [match range];
        
        NSString* albumSection = [page substringWithRange:matchRange];
        
        NSArray* urlMatches = [SearchViewController regexMatchesForString: albumSection regex:@"<a href=\"\\/album\\/[a-zA-Z0-9_-]*\">"];
        
        for (NSTextCheckingResult *urlMatch in urlMatches) {
            NSRange urlMatchRange = [urlMatch range];
            albumUrl = [albumSection substringWithRange:urlMatchRange];
        }
        
        if (albumUrl != nil) {
            break;
        }
        
    }
    
    //<a href="/album/loops">
    if (albumUrl != nil) {
        url = [url stringByReplacingOccurrencesOfString:@"/music" withString:@""];
        albumUrl = [albumUrl stringByReplacingOccurrencesOfString:@"<a href=\"" withString:url];
        albumUrl = [albumUrl stringByReplacingOccurrencesOfString:@"\">" withString:@""];
        [self loadAlbumPage:albumUrl];
    }
    
}

+ (NSArray*) regexMatchesForString: (NSString*) inputString regex: (NSString*) regexString {
    
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexString
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    //    NSUInteger numberOfMatches = [regex numberOfMatchesInString:inputString
    //    options:0
    //      range:NSMakeRange(0, [inputString length])];
    
    NSArray *matches = [regex matchesInString:inputString
                                      options:0
                                        range:NSMakeRange(0, [inputString length])];
    
    return matches;
}


+(NSString*) loadStringByUrl:(NSString *)urlString
{
    NSData* data = [self loadDataByUrl:urlString Accept:nil];
    if (data == nil)
    {
        return nil;
    }
    
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return str;
}

- (void) loadAlbumPage:(NSString*) url {
    
    //@"https://lazymagnet.bandcamp.com/album/make-it-fun-again-2020"
    NSString *page = [SearchViewController loadStringByUrl:url];
    
    NSArray* matches = [SearchViewController regexMatchesForString: page regex:@"&quot;https:\\/\\/t4\\.bcbits\\.com[a-zA-Z0-9_\\/-]*\\?[a-zA-Z0-9_\\/-=&]*&quot;"];
    
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
    
    cell.textLabel.text = [self.searchResults allObjects][indexPath.row][@"name"];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.searchResults count];
}


+(NSMutableDictionary *) loadJsonByUrl:(NSString *)urlString withTimeoutInterval:(NSTimeInterval)timeout
{
    NSLog(@"loadJsonByUrl: %@", urlString);
    NSError *error = nil;
    NSData* data = [self loadDataByUrl:urlString Accept:@"application/json" withTimeoutInterval:timeout];
    if (data == nil)
    {
        return nil;
    }
    
    NSMutableDictionary *objects = [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error] mutableCopy];
    
    if (error != nil) {
        NSLog(@"Error: %@", [error localizedDescription]);
        return nil;
    }
    
    return objects;
}

+(NSData*) loadDataByUrl:(NSString *)urlString
{
    return [self loadDataByUrl:urlString Accept:@"application/json"];
}

+(NSData*) loadDataByUrl:(NSString *)urlString Accept:(NSString*)accept
{
    return [self loadDataByUrl:urlString Accept:accept withTimeoutInterval:120];
}

+(NSData*) loadDataByUrl:(NSString *)urlString Accept:(NSString*)accept withTimeoutInterval:(NSTimeInterval)timeout
{
    NSError *error = nil;
    NSURLResponse *response = nil;
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:timeout];
    if (accept != nil)
    {
        [request setValue:accept forHTTPHeaderField:@"Accept"];
    }
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];
    
    if (error != nil) {
        NSLog(@"Error: %@", [error localizedDescription]);
        return nil;
    }
    
    return data;
}


@end

//
//  SearchResultController.h
//  sonar
//
//  Created by Allred, Andrew on 11/29/20.
//  Copyright © 2020 Allred, Andrew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BandcampService.h"
#import "ServiceCaller.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchResultViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *albumsTableView;

@property (nonatomic, strong) NSString* SearchResultUrl;
@property (strong, atomic) Artist* Artist;

@end

NS_ASSUME_NONNULL_END

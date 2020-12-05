//
//  ViewController.h
//  sonar
//
//  Created by Allred, Andrew on 11/29/20.
//  Copyright © 2020 Allred, Andrew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Artist.h"

@interface SearchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;

- (IBAction)searchEditingDidBegin:(id)sender;
- (IBAction)searchEditingDidEnd:(id)sender;

@property (strong, atomic) NSMutableArray<Artist*>* artists;


@end


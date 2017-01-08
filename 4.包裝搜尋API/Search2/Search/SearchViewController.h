//
//  SearchViewController.h
//  Search
//
//  Created by Mac on 13/9/25.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKSearch.h"

@interface SearchViewController : UITableViewController <MKSearchDelegate>

@property (strong, nonatomic) MKSearch *mkSearch;

@end

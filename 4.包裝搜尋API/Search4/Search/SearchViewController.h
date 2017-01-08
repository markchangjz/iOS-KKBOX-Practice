//
//  SearchViewController.h
//  Search
//
//  Created by Mac on 13/9/25.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKSearch.h"

//typedef void(^DownloadDataSuccessCallback)(NSArray *inData);
//typedef void(^DownloadDataFailCallback)(NSError *error);

@interface SearchViewController : UITableViewController

@property (strong, nonatomic) MKSearch *mkSearch;
//@property (copy, nonatomic) DownloadDataSuccessCallback downloadDataSuccessCallback;
//@property (copy, nonatomic) DownloadDataFailCallback downloadDataFailCallback;

@end

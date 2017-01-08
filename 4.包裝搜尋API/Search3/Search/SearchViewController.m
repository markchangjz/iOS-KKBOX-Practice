//
//  SearchViewController.m
//  Search
//
//  Created by Mac on 13/9/25.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "SearchViewController.h"
#import "MKDownloadTask.h"

@interface SearchViewController () <UISearchBarDelegate>
{
    NSArray *tableViewData;
    UISearchBar *searchDataBar;
}

@property (retain, nonatomic) NSArray *tableViewData;

@end

@implementation SearchViewController

- (void)dealloc
{
    [_mkSearch release];
    [tableViewData release];
    [searchDataBar release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.tabBarItem.title = @"1";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!searchDataBar) {
        searchDataBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        searchDataBar.placeholder = @"搜尋";
        searchDataBar.delegate = self;
        [searchDataBar sizeToFit];
    }
    
    self.tableView.tableHeaderView = searchDataBar;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.mkSearch searchKKBOXWithKeyword:searchBar.text delegate:self];
    [searchBar resignFirstResponder];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 滑動 TableView 時把鍵盤關閉
    [searchDataBar resignFirstResponder];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tableViewData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    cell.textLabel.text = [[tableViewData objectAtIndex:indexPath.row] objectForKey:@"text"];
    
    return [cell autorelease];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                        message:[[tableViewData objectAtIndex:indexPath.row] objectForKey:@"keyword"]
                                                       delegate:self
                                              cancelButtonTitle:@"關閉"
                                              otherButtonTitles:nil];
    [alertView show];
}

#pragma mark - MKSearchDelegate

- (void)search:(MKSearch *)search didCompleteSearchingWithParsedData:(NSArray *)inData
{
    self.tableViewData = inData;
    [self.tableView reloadData];
}

- (void)search:(MKSearch *)search didFailWithError:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                        message:[error localizedDescription]
                                                       delegate:self
                                              cancelButtonTitle:@"關閉"
                                              otherButtonTitles:nil];
    [alertView show];
}

#pragma mark - lazy instantiation

- (MKSearch *)mkSearch
{
    if (!_mkSearch) {
        _mkSearch = [[MKSearch alloc] init];
    }
    
    return _mkSearch;
}

@synthesize tableViewData;

@end

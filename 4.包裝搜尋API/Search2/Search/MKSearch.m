//
//  MKSearch.m
//  Search
//
//  Created by Mac on 13/9/25.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "MKSearch.h"
#import "NSString+Trim.h"
#import "NSURLConnection+Delegate.h"

static const NSString *KKSearchURL = @"http://www.kkbox.com.tw/ajax/ac_search.php?query=";

@interface MKSearch()
@property (retain, nonatomic) NSURLConnection *currentConnection;
@end

@implementation MKSearch

- (void)dealloc
{
    [super dealloc];
}

- (void)searchKKBOXWithKeyword:(NSString *)keyword delegate:(id)delegate
{    
    // 將搜尋的 keyword 做 trim 字串處理
    keyword = [keyword trimmedString];
    // 將 keyword 併入 KKBOX 搜尋 URL GET API
    NSString *searchURL = [KKSearchURL stringByAppendingString:keyword];
    // 使用 urlencode
    searchURL = [searchURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:searchURL];
    NSAssert(url, @"We must have a URL");
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSAssert(request, @"We must have a request");
    if (!request) {
        return;
    }
    if (self.currentConnection) {
        [self.currentConnection cancel];
        self.currentConnection = nil;
    }    
    
    MKURLConnection *newConnection = [[[MKURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES] autorelease];
    newConnection.APIDelegate = delegate;
}

- (NSMutableArray *)parseRequestData:(NSData *)inData
{
    NSMutableArray *array = [NSMutableArray array];
    NSString *parseString = [[[NSString alloc] initWithData:inData encoding:NSUTF8StringEncoding] autorelease];
        
    NSArray *rowData = [parseString componentsSeparatedByString:@"\n"];
        
    for (NSString *rowString in rowData) {
        if ([rowString rangeOfString:@"\t"].location != NSNotFound && [rowString rangeOfString:@"&gt;&gt;"].location == NSNotFound) {
            NSArray *splitRowData = [rowString componentsSeparatedByString:@"\t"];
            
            NSDictionary *rowDataDictionary = @{@"keyword": [splitRowData[0] trimmedString], @"text": [splitRowData[1] trimmedString]};
            [array addObject:rowDataDictionary];
        }
    }
    return array;
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(MKURLConnection *)connection didReceiveData:(NSData *)data
{
    [connection.data appendData:data];
}

- (void)connectionDidFinishLoading:(MKURLConnection *)connection
{
    NSArray *parseArrary = [self parseRequestData:connection.data];
    [connection.APIDelegate search:self didCompleteSearchingWithParsedData:parseArrary];
}

- (void)connection:(MKURLConnection *)connection didFailWithError:(NSError *)error
{
    [connection.APIDelegate search:self didFailWithError:error];
}

@end

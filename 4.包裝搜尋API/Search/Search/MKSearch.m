//
//  MKSearch.m
//  Search
//
//  Created by Mac on 13/9/25.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "MKSearch.h"
#import "NSString+Trim.h"

static const NSString *KKSearchURL = @"http://www.kkbox.com.tw/ajax/ac_search.php?query=";

@interface MKSearch()
@property (retain, nonatomic) NSURLConnection *currentConnection;
@end

@implementation MKSearch
{
    NSMutableData *receivedData;
}

- (void)dealloc
{
    [receivedData release];
    [super dealloc];
}

- (void)searchKKBOXWithKeyword:(NSString *)keyword
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
    
    NSURLConnection *newConnection = [NSURLConnection connectionWithRequest:request delegate:self];
    self.currentConnection = newConnection;
    
    if (receivedData) {
        [receivedData release];
    }
    receivedData = [[NSMutableData alloc] init];
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

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSArray *data = [self parseRequestData:receivedData];
    [self.delegate search:self didCompleteSearchingWithParsedData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self.delegate search:self didFailWithError:error];
}

@end

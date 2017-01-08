//
//  MKSearch.m
//  Search
//
//  Created by Mac on 13/9/25.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "MKSearch.h"
#import "NSString+Trim.h"
#import "MKDownloadTask.h"

static const NSString *KKSearchURL = @"http://www.kkbox.com.tw/ajax/ac_search.php?query=";

@interface MKSearch()

@property (retain, nonatomic) NSURLConnection *currentConnection;

@end

@implementation MKSearch
{
    NSOperationQueue *operationQueue;
}

- (void)dealloc
{
    [operationQueue release];    
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        //建立 NSOperationQueue
        operationQueue = [[NSOperationQueue alloc] init];
    }
    return self;
}

- (void)searchKKBOXWithKeyword:(NSString *)keyword successCallback:(void (^)(NSArray *))successCallback failCallback:(void (^)(NSError *))failCallback
{    
    // 將搜尋的 keyword 做 trim 字串處理
    keyword = [keyword trimmedString];
    // 將 keyword 併入 KKBOX 搜尋 URL GET API
    NSString *searchURL = [KKSearchURL stringByAppendingString:keyword];
    // 使用 urlencode
    searchURL = [searchURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:searchURL];

    MKDownloadTask *downloadTask = [[[MKDownloadTask alloc] init] autorelease];
    downloadTask.downloadURL = url;

    // downloadTask.fetchDataCallback
    [downloadTask setFetchDataCallback:^(NSData *inData, NSError *inError) {
        if (inError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                failCallback(inError);
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                successCallback([self parseRequestData:inData]);
            });
        }
    }];
    
    [operationQueue addOperation:downloadTask];
}

- (NSArray *)parseRequestData:(NSData *)inData
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

@end

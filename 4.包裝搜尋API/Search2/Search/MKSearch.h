//
//  MKSearch.h
//  Search
//
//  Created by Mac on 13/9/25.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MKSearch;

@protocol MKSearchDelegate <NSObject>
- (void)search:(MKSearch *)search didCompleteSearchingWithParsedData:(NSArray *)inData;
- (void)search:(MKSearch *)search didFailWithError:(NSError *)error;
@end

@interface MKSearch : NSObject <NSURLConnectionDataDelegate>

- (void)searchKKBOXWithKeyword:(NSString *)keyword delegate:(id)delegate;

@end



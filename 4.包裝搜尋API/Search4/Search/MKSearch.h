//
//  MKSearch.h
//  Search
//
//  Created by Mac on 13/9/25.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MKSearch : NSObject <NSURLConnectionDataDelegate>

- (void)searchKKBOXWithKeyword:(NSString *)keyword
               successCallback:(void(^)(NSArray *inParsedData))successCallback
                  failCallback:(void(^)(NSError *inError))failCallback;

@end



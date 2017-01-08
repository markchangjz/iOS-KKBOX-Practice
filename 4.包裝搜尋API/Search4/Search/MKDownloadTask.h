//
//  DownloadTask.h
//  Search
//
//  Created by Mac on 13/9/27.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^FetchDataCallback)(NSData *inData, NSError *inError);

@class MKDownloadTask;

@interface MKDownloadTask : NSOperation

//main 繼承於 NSOperation, 執行緒啟動時將執行這個函數
- (void)main;

@property (assign, nonatomic) id downloadDelegate;
@property (retain, nonatomic) NSURL *downloadURL;
@property (copy, nonatomic) FetchDataCallback fetchDataCallback;

@end

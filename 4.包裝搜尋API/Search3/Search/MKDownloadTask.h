//
//  DownloadTask.h
//  Search
//
//  Created by Mac on 13/9/27.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MKDownloadTask;

@protocol DownloadTaskDelegate <NSObject>

- (void)downloadTask:(MKDownloadTask *)download didDownloadData:(NSData *)data;
- (void)downloadTask:(MKDownloadTask *)download didFailWithError:(NSError *)error;

@end

@interface MKDownloadTask : NSOperation

//main 繼承於 NSOperation, 執行緒啟動時將執行這個函數
- (void)main;

@property (assign, nonatomic) id <DownloadTaskDelegate> delegate;
@property (assign, nonatomic) id downloadDelegate;
@property (retain, nonatomic) NSURL *downloadURL;

@end

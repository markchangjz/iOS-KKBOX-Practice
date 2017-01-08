//
//  DownloadTask.m
//  Search
//
//  Created by Mac on 13/9/27.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "MKDownloadTask.h"

@implementation MKDownloadTask

- (void)dealloc
{
    [_downloadURL release];
    [super dealloc];
}

- (void)main
{
    NSURLRequest *request = [NSURLRequest requestWithURL:self.downloadURL];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    self.fetchDataCallback(data, error);
}

@end

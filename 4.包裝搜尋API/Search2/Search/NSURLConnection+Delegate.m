//
//  NSURLConnection+Delegate.m
//  Search
//
//  Created by Mac on 13/9/26.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "NSURLConnection+Delegate.h"
#import <objc/runtime.h>

@implementation MKURLConnection
{
    NSMutableData *_data;
}

- (void)dealloc
{
    [_data release];
    [super dealloc];
}

@synthesize APIDelegate;

- (NSMutableData *)data
{
    if (!_data) {
        _data = [[NSMutableData alloc] init];
    }
    return _data;
}

@end
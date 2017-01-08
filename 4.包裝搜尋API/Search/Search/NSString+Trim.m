//
//  NSString+Trim.m
//  Search
//
//  Created by Mac on 13/9/25.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "NSString+Trim.h"

@implementation NSString (Trim)

- (NSString *)trimmedString
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

@end

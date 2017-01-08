//
//  NSString+reverseString.m
//  StrReverse
//
//  Created by Mac on 13/9/18.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "NSString+reverseString.h"

@implementation NSString (reverseString)

- (NSString *)reverseStr
{
    NSString *revStr = @"";
    
    for (int i = self.length - 1; i >= 0 ; i--) {
        NSString *substring = [self substringWithRange:NSMakeRange(i, 1)];
        revStr = [revStr stringByAppendingString:substring];
    }

    return revStr;
}

- (NSString *)reverseString
{
    NSMutableString *s = [NSMutableString string];
    
    for (int i = self.length - 1; i >= 0 ; i--) {
        [s appendFormat:@"%C", [self characterAtIndex:i]];
    }
    
    return s;
}



@end

//
//  MKLyric.m
//  Lyric
//
//  Created by Mac on 13/10/1.
//  Copyright (c) 2013年 KKBOX. All rights reserved.
//

#import "MKLyricsParser.h"

@implementation MKLyricsParser

- (NSArray *)parseLyricWithFile:(NSString *)filePath error:(NSError *__autoreleasing *)inError
{
    NSError *error = nil;
    NSString *string = [[NSString alloc] initWithContentsOfFile:filePath
                                                       encoding:NSUTF8StringEncoding
                                                          error:&error];
    
    NSMutableArray *parsedLyricData = [NSMutableArray array];
    
    for (NSString *line in [string componentsSeparatedByString:@"\n"]) {
        [parsedLyricData addObject:@{@"time": [self _convertTimeStringToSecond:[line substringWithRange:NSMakeRange(1, 8)]],
         @"text": [line substringFromIndex:10]}];
    }
    
    return parsedLyricData;
}

- (NSString *)_readLyric
{
    NSString *filePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"lyric.txt"];
    
    NSError *error = nil;
    NSString *string = [[NSString alloc] initWithContentsOfFile:filePath
                                                       encoding:NSUTF8StringEncoding
                                                          error:&error];
    if (error) {
        NSLog(@"read failed: %@", [error localizedDescription]);
    }
    
    return string;
}

- (NSNumber *)_convertTimeStringToSecond:(NSString *)timeString
{    
    NSArray *timeData = [timeString componentsSeparatedByString:@":"];
    
    NSAssert(timeData.count == 2, @"資料格式有誤");
    if (timeData.count != 2) {
        return nil;
    }
    
    return [NSNumber numberWithFloat:round([timeData[0] intValue] * 60 + [timeData[1] doubleValue])];
}

@end

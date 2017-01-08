//
//  Lyric2Tests.m
//  Lyric2Tests
//
//  Created by Mac on 13/10/3.
//  Copyright (c) 2013年 KKBOX. All rights reserved.
//

#import "Lyric2Tests.h"
#import "MKLyricsParser.h"

@implementation Lyric2Tests

MKLyricsParser *lyricsParser;

- (void)setUp
{
    [super setUp];
    
    lyricsParser = [[MKLyricsParser alloc] init];
}

- (void)testParsedLyricSuccess
{
    NSArray *parsedLyricData = [lyricsParser parseLyricsWithString:@"[00:26.05 00:31.10]<type=2>她愛她     她愛他"];
    
    STAssertNotNil(parsedLyricData, @"parsedLyricData is nil");
    STAssertEquals([parsedLyricData[0][@"lineStart"] doubleValue], 26.05, @"lineStart is incorrect");
    STAssertEquals([parsedLyricData[0][@"lineEnd"] doubleValue], 31.10, @"lineEnd is incorrect");
    STAssertEquals([parsedLyricData[0][@"type"] intValue], 2, @"type is incorrect");
    STAssertEqualObjects((NSString *)parsedLyricData[0][@"lineLyrics"], @"她愛她     她愛他", @"lineLyrics is incorrect");
}

- (void)testParsedLyricFail
{
    NSArray *parsedLyricData = [lyricsParser parseLyricsWithString:@"[01:03 幸福 我要的幸福 在不遠處"];
    
    STAssertEquals(parsedLyricData.count, (NSUInteger)0, @"parsedLyricData has no data");
}

@end

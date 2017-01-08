//
//  LyricsPlayTests.m
//  Lyric2
//
//  Created by Mac on 13/10/17.
//  Copyright (c) 2013年 KKBOX. All rights reserved.
//

#import "LyricsPlayTests.h"
#import "MKLyricsViewController.h"

@implementation LyricsPlayTests

MKLyricsViewController *mkLyricsViewController;

- (void)setUp
{
    [super setUp];
    
    mkLyricsViewController = [[MKLyricsViewController alloc] init];
}

- (void)testPlayAtTime
{
    NSError *error = nil;
    NSString *lyricsFilePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"lyricsForUnitTest.lrc"];
    [mkLyricsViewController loadLyricsWithFilePath:lyricsFilePath error:&error];
    [mkLyricsViewController playAtTime:22.0];
    
    NSArray *lyrics = [mkLyricsViewController valueForKey:@"parsedLyricsData"];
    
    int playingLyricsIndex = 1;
    
    for (int i = 0; i < lyrics.count; i++) {
        if (i == playingLyricsIndex) {
            STAssertTrue([lyrics[i][@"playing"] boolValue], @"lyrics index %d is playing", playingLyricsIndex);
        }
        else {
            STAssertFalse([lyrics[i][@"playing"] boolValue], @"lyrics index %d is not playing", playingLyricsIndex);
        }
    }
}

- (void)testPlayAtTime_ZeroSecond
{
    NSError *error = nil;
    NSString *lyricsFilePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"lyricsForUnitTest.lrc"];
    [mkLyricsViewController loadLyricsWithFilePath:lyricsFilePath error:&error];
    [mkLyricsViewController playAtTime:0.0];
    
    NSArray *lyrics = [mkLyricsViewController valueForKey:@"parsedLyricsData"];

    for (int i = 0; i < lyrics.count; i++) {
        STAssertFalse([lyrics[i][@"playing"] boolValue], @"no lyrics playing");
    }
}

- (void)testPlayAtTime_NegativeSecond
{
    NSError *error = nil;
    NSString *lyricsFilePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"lyricsForUnitTest.lrc"];
    [mkLyricsViewController loadLyricsWithFilePath:lyricsFilePath error:&error];
    [mkLyricsViewController playAtTime:-1.0];
    
    NSArray *lyrics = [mkLyricsViewController valueForKey:@"parsedLyricsData"];
    
    for (int i = 0; i < lyrics.count; i++) {
        STAssertFalse([lyrics[i][@"playing"] boolValue], @"no lyrics playing");
    }
}

- (void)testPlayAtTime_DurationSecond
{
    NSError *error = nil;
    NSString *lyricsFilePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"lyricsForUnitTest.lrc"];
    [mkLyricsViewController loadLyricsWithFilePath:lyricsFilePath error:&error];
    [mkLyricsViewController playAtTime:mkLyricsViewController.duration];
    
    NSArray *lyrics = [mkLyricsViewController valueForKey:@"parsedLyricsData"];
    
    for (int i = 0; i < lyrics.count; i++) {
        STAssertFalse([lyrics[i][@"playing"] boolValue], @"no lyrics playing");
    }
}

@end

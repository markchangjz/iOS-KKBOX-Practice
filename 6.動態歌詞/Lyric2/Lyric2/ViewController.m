//
//  ViewController.m
//  Lyric2
//
//  Created by Mac on 13/10/3.
//  Copyright (c) 2013年 KKBOX. All rights reserved.
//

#import "ViewController.h"
#import "MKLyricsParser.h"
#import "MKLyricScrollView.h"
#import "SYSTEM_INFO.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController () <MKLyricScrollViewDatasource> {
    CATransition *transitionFade;
    CATextLayer *currentTextLayer;
    NSUInteger currentProcessLyricIndex;
    NSArray *parsedLyricData;
}

@property (strong, nonatomic) MKLyricScrollView *mkLyricScrollView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (![self _parseLyricsWithFilePath:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"lyric.txt"]]) {
        CATextLayer *textLayer = [CATextLayer layer];
        textLayer.string = @"讀取歌詞資料錯誤";
        textLayer.alignmentMode = kCAAlignmentCenter;
        textLayer.frame = CGRectMake(10, 190, 300, 100);
        textLayer.wrapped = YES;
        textLayer.fontSize = 20;
        textLayer.contentsScale = [UIScreen mainScreen].scale;
        [self.view.layer addSublayer:textLayer];
        return;
    }
    
    self.mkLyricScrollView = [[MKLyricScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.mkLyricScrollView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    self.mkLyricScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.mkLyricScrollView.dataSoruce = self;
    [self.mkLyricScrollView reloadData];
    [self.view addSubview:self.mkLyricScrollView];
        
    transitionFade = [CATransition animation];
    [transitionFade setDelegate:self];
    
    [self performSelector:@selector(_updateLyricView) withObject:nil afterDelay:[parsedLyricData[0][@"time"] floatValue]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (currentProcessLyricIndex + 1 == parsedLyricData.count) {
        currentTextLayer = self.mkLyricScrollView.lyricTextLayers[currentProcessLyricIndex];
        currentTextLayer.backgroundColor = [UIColor clearColor].CGColor;
    }
    
    if (currentProcessLyricIndex + 1 < parsedLyricData.count) {
        NSTimeInterval nextTimeInterval = [parsedLyricData[currentProcessLyricIndex + 1][@"time"] floatValue] - [parsedLyricData[currentProcessLyricIndex][@"time"] floatValue];
        [self performSelector:@selector(_updateLyricView) withObject:nil afterDelay:nextTimeInterval];
    }
        
    currentProcessLyricIndex++;
}

#pragma mark - private function

- (void)_updateLyricView
{
    if (currentProcessLyricIndex > 0) {
        currentTextLayer = self.mkLyricScrollView.lyricTextLayers[currentProcessLyricIndex - 1];
        currentTextLayer.backgroundColor = [UIColor clearColor].CGColor;
        [self.mkLyricScrollView setContentOffset:CGPointMake(0, [self.mkLyricScrollView.lyricTextLayers[currentProcessLyricIndex] frame].origin.y - paddingY) animated:YES];
    }

    currentTextLayer = self.mkLyricScrollView.lyricTextLayers[currentProcessLyricIndex];
    currentTextLayer.backgroundColor = [UIColor blueColor].CGColor;
    [currentTextLayer addAnimation:transitionFade forKey:@"Fade"];
}

- (BOOL)_parseLyricsWithFilePath:(NSString *)filePath
{
    NSError *error = nil;
    MKLyricsParser *lyricsParser = [[MKLyricsParser alloc] init];
    parsedLyricData = [lyricsParser parseLyricWithFile:filePath error:&error];
    
    if (error) {
        return NO;
    }
    else {
        return YES;
    }
}

#pragma mark - MKLyricScrollViewDatasource

- (NSArray *)parsedLyricsForLyricsScrollView:(MKLyricScrollView *)inView
{
    return parsedLyricData;
}

@end

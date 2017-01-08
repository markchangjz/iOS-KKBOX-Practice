//
//  ViewController.m
//  Lyric
//
//  Created by Mac on 13/10/1.
//  Copyright (c) 2013年 KKBOX. All rights reserved.
//

#import "ViewController.h"
#import "MKLyricsParser.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController () {
    int currentProcessLyricIndex;
}

@property (strong, nonatomic) MKLyricsParser *mkLyric;
@property (strong, nonatomic) NSArray *lyricData;
@property (strong, nonatomic) NSMutableArray *lyricTextLayers;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
        
    currentProcessLyricIndex = 0;
    
    [self _initLyricView];
    
    [self performSelector:@selector(_updateLyricView) withObject:nil afterDelay:[self.lyricData[0][@"time"] intValue]];
}

- (void)_initLyricView
{
    for (int i = 0; i < self.lyricTextLayers.count; i++) {
        CATextLayer *textLayer = self.lyricTextLayers[i];
        
        if (i < self.lyricData.count) {
            textLayer.string = self.lyricData[i][@"text"];
            
            [self.view.layer addSublayer:textLayer];
        }
    }
}

- (void)_updateLyricView
{
    CATransition *transitionFade = [CATransition animation];
    [transitionFade setType:@"fade"];
    [transitionFade setSubtype:@"fromLeft"];
    [transitionFade setDelegate:self];
    
    [self.view.layer addAnimation:transitionFade forKey:@"fade"];
    
    CATextLayer *currentProcessLyricLayer = self.lyricTextLayers[0];
    currentProcessLyricLayer.backgroundColor = [UIColor blueColor].CGColor;
    currentProcessLyricLayer.opacity = 0.8;
    
    CATransition *transitionReveal = [CATransition animation];
    [transitionReveal setType:@"reveal"];
    [transitionReveal setSubtype:@"fromTop"];
    [currentProcessLyricLayer addAnimation:transitionReveal forKey:@"reveal"];
    
    for (int i = 0; i < self.lyricTextLayers.count; i++) {
        CATextLayer *textLayer = self.lyricTextLayers[i];
        
        if (i < self.lyricData.count) {
            if (currentProcessLyricIndex + i < self.lyricData.count) {
                textLayer.string = self.lyricData[currentProcessLyricIndex + i][@"text"];
            }
            else {
                textLayer.string = @"";
            }
            
            [self.view.layer addSublayer:textLayer];
        }
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    CATransition *transitionRipple = [CATransition animation];
    [transitionRipple setDuration:1];
    [transitionRipple setType:@"rippleEffect"];
    [self.view.layer addAnimation:transitionRipple forKey:@"Ripple"];
    
    if (currentProcessLyricIndex < self.lyricData.count) {
        if (currentProcessLyricIndex + 1 == self.lyricData.count) {
            CATextLayer *currentProcessLyricLayer = self.lyricTextLayers[0];
            currentProcessLyricLayer.backgroundColor = [UIColor clearColor].CGColor;
            currentProcessLyricLayer.string = @"";
        }
        else {
            int nextTime = [self.lyricData[currentProcessLyricIndex + 1][@"time"] intValue] - [self.lyricData[currentProcessLyricIndex][@"time"] intValue];
            [self performSelector:@selector(_updateLyricView) withObject:nil afterDelay:nextTime];
        }
    }
    
    currentProcessLyricIndex++;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - lazy instantiation

- (MKLyricsParser *)mkLyric
{
    if (!_mkLyric) {
        _mkLyric = [[MKLyricsParser alloc] init];
    }
    
    return _mkLyric;
}

- (NSArray *)lyricData
{
    if (!_lyricData) {
        _lyricData = [[NSArray alloc] initWithArray:[self.mkLyric parseLyricWithFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"lyric.txt"]
                                                                               error:nil]];
    }
    
    return _lyricData;
}

- (NSMutableArray *)lyricTextLayers
{
    if (!_lyricTextLayers) {
        _lyricTextLayers = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < 9; i++) {
            
            CATextLayer *textLayer = [CATextLayer layer];
            textLayer.frame = CGRectMake(10, i * 50 + 20, 300, 25);
            textLayer.backgroundColor = [UIColor clearColor].CGColor;
            textLayer.wrapped = YES;
            textLayer.fontSize = 20;
            textLayer.contentsScale = [UIScreen mainScreen].scale;
            
            [_lyricTextLayers addObject:textLayer];
        }
    }
    
    return _lyricTextLayers;
}

@end

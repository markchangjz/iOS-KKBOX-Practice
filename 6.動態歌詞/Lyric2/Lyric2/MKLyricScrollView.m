//
//  MKLyricScrollView.m
//  Lyric2
//
//  Created by Mac on 13/10/14.
//  Copyright (c) 2013年 KKBOX. All rights reserved.
//

#import "MKLyricScrollView.h"
#import "SYSTEM_INFO.h"
#import <QuartzCore/QuartzCore.h>

static const CGFloat lyricsSpace = 20.0;

@implementation MKLyricScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

- (void)drawRect:(CGRect)rect
{    

}

- (void)reloadData
{
    //準備lyricsTextLayer
    self.lyricTextLayers = [NSMutableArray array];
    
    CGFloat lyricsTextLayerY = lyricsSpace;
    
    for (int i = 0; i < [self.dataSoruce parsedLyricsForLyricsScrollView:self].count; i++) {
        CATextLayer *lyricsTextLayer = [CATextLayer layer];
        lyricsTextLayer.string = [self.dataSoruce parsedLyricsForLyricsScrollView:self][i][@"text"];
        
        CGSize textSize = [lyricsTextLayer.string sizeWithFont:[UIFont systemFontOfSize:20]
                                             constrainedToSize:CGSizeMake(self.frame.size.width - paddingX * 2, self.frame.size.height)
                                                 lineBreakMode:NSLineBreakByWordWrapping];
        CGFloat lyricsTextLayerHeight = MIN(textSize.height, self.frame.size.height);
        
        lyricsTextLayer.frame = CGRectMake(paddingX, lyricsTextLayerY, self.frame.size.width - paddingX * 2, lyricsTextLayerHeight);
        lyricsTextLayer.backgroundColor = [UIColor clearColor].CGColor;
        lyricsTextLayer.wrapped = YES;
        lyricsTextLayer.fontSize = 20;
        lyricsTextLayer.contentsScale = [UIScreen mainScreen].scale;
        
        lyricsTextLayerY += lyricsTextLayerHeight + lyricsSpace;

        [self.layer addSublayer:lyricsTextLayer];
        [self.lyricTextLayers addObject:lyricsTextLayer];
    }
    
    self.contentSize = CGSizeMake(self.frame.size.width, lyricsTextLayerY + paddingY);
}

@end

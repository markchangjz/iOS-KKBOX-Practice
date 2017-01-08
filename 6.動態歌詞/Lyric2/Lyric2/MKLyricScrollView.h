//
//  MKLyricScrollView.h
//  Lyric2
//
//  Created by Mac on 13/10/14.
//  Copyright (c) 2013年 KKBOX. All rights reserved.
//

#import <UIKit/UIKit.h>

static const CGFloat paddingX = 10.0;
static const CGFloat paddingY = 10.0;

@class MKLyricScrollView;

@protocol MKLyricScrollViewDatasource <NSObject>

- (NSArray *)parsedLyricsForLyricsScrollView:(MKLyricScrollView *)inView;

@end

@interface MKLyricScrollView : UIScrollView

- (void)reloadData;

@property (weak, nonatomic) id <MKLyricScrollViewDatasource> dataSoruce;
@property (strong, nonatomic) NSMutableArray *lyricTextLayers;

@end
//
//  MKCrosswordView.m
//  Crossword
//
//  Created by Mac on 13/9/30.
//  Copyright (c) 2013年 KKBOX. All rights reserved.
//

#import "MKCrosswordView.h"

MKPoint MKMakePoint(int pointX, int pointY)
{
    return (MKPoint) {.x = pointX, .y = pointY};
}

@interface MKCrosswordView ()

@property (strong, nonatomic) NSMutableArray *words;

@end

@implementation MKCrosswordView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)_drawGrid
{
    UIBezierPath *gridPath = [[UIBezierPath alloc] init];
    
    // 畫直線
    for (int x = 20; x <= (girdWidth * 8 + 20); x += girdWidth) {
        [gridPath moveToPoint:CGPointMake(x, 20)];
        [gridPath addLineToPoint:CGPointMake(x, 460)];
    }
    
    // 畫橫線
    for (int y = 20; y <= (gridHeight * 8 + 20); y += gridHeight) {
        [gridPath moveToPoint:CGPointMake(20, y)];
        [gridPath addLineToPoint:CGPointMake(300, y)];
    }
    
    [gridPath stroke];
}

- (void)_drawWord
{
    for (int x = 0; x < 8; x++) {
        for (int y = 0; y < 8; y++) {
            [self.words[x][y] drawInRect:CGRectMake(y * girdWidth + 20, x * gridHeight + 20, girdWidth, gridHeight) withFont:[UIFont boldSystemFontOfSize:20]];
        }
    }
}

- (void)handleTap:(UITapGestureRecognizer *)gesture
{
    if ([gesture locationInView:self].x >= 20 && [gesture locationInView:self].x <= 280 &&
        [gesture locationInView:self].y >= 20 && [gesture locationInView:self].x <= 440) {
    
        int inGridX = ([gesture locationInView:self].x - 20.0) / girdWidth;
        int inGridY = ([gesture locationInView:self].y - 20.0) / gridHeight;

        [self.delegate MKCrosswordView:self
                        tapInGridPoint:MKMakePoint(inGridX, inGridY)
                               andWord:self.words[inGridY][inGridX]];
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [self _drawGrid];
    [self _drawWord];
        
}

- (void)changWord:(NSString *)newWord InGridPoint:(MKPoint)gridPoint
{
    self.words[gridPoint.y][gridPoint.x] = newWord;
    [self setNeedsDisplay];
}

#pragma mark - lazy instantiation

- (NSMutableArray *)words
{
    NSMutableArray * (^MA)(NSArray *) = ^(NSArray *a) {
        return [NSMutableArray arrayWithArray:a];
    };
    
    if (!_words) {
        _words = [[NSMutableArray alloc] initWithObjects:
                  MA(@[@"台", @"灣", @"人", @"需", @"要", @"消", @"波", @"塊"]),
                  MA(@[@"消", @"波", @"塊", @"需", @"要", @"台", @"灣", @"人"]),
                  MA(@[@"台", @"灣", @"人", @"需", @"要", @"消", @"波", @"塊"]),
                  MA(@[@"消", @"波", @"塊", @"需", @"要", @"台", @"灣", @"人"]),
                  MA(@[@"台", @"灣", @"人", @"需", @"要", @"消", @"波", @"塊"]),
                  MA(@[@"消", @"波", @"塊", @"需", @"要", @"台", @"灣", @"人"]),
                  MA(@[@"台", @"灣", @"人", @"需", @"要", @"消", @"波", @"塊"]),
                  MA(@[@"消", @"波", @"塊", @"需", @"要", @"台", @"灣", @"人"]),
                  nil];
    }

    return _words;
}

@end

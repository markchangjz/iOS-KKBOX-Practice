//
//  SnakeView.m
//  Snake
//
//  Created by JzChang on 13/9/20.
//  Copyright (c) 2013年 JzChang. All rights reserved.
//

#import "MKSnakeView.h"

@implementation MKSnakeView

- (void)dealloc
{
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    if (![self.dataSource snakePointsInSnakeView:self]) {
        return;
    }
    
    // 畫水果
    [[UIColor redColor] set];
    MKPoint friutPoint = [self.dataSource fruitPointInSnakeView:self];
    UIBezierPath *drawFruit = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(friutPoint.x * 20, friutPoint.y * 20, 20, 20)];
    [drawFruit fill];
    [drawFruit stroke];
    
    // 畫蛇
    [[UIColor blackColor] set];
    for (NSValue *v in [self.dataSource snakePointsInSnakeView:self]) {
        MKPoint p = [v snakePointValue];

        UIBezierPath *drawSnakeBody = [UIBezierPath bezierPathWithRect:CGRectMake(p.x * 20, p.y * 20, 20, 20)];
        [drawSnakeBody setLineWidth:5.0];
        [drawSnakeBody stroke];
    }
}

@end

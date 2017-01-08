//
//  SnakeModel.h
//  Snake
//
//  Created by JzChang on 13/9/20.
//  Copyright (c) 2013年 JzChang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct {
    NSUInteger x;
    NSUInteger y;
} MKPoint;

MKPoint MKMakePoint(int pointX, int pointY);

typedef enum {
    directionUp,
    directionDown,
    directionLeft,
    directionRight
} MoveDirection;

@interface NSValue (PackageSnakePoint)

+ (NSValue *)valueWithSnakePoint:(MKPoint)snakePoint;
- (MKPoint)snakePointValue;

@end

@interface MKSnakeModel : NSObject

@property (retain, nonatomic) NSMutableArray *snakePoints;
@property (assign, nonatomic) MKPoint fruitPoint;
@property (assign, nonatomic) int AreaWidth;
@property (assign, nonatomic) int AreaHeight;

- (id)initWithMoveDirection:(MoveDirection)initDirection withAreaWidth:(int)width andAreaHeight:(int)height;
- (void)moveSnake;
- (void)changeMoveDirection:(MoveDirection)newDirection;

- (BOOL)isHeadHitSnakeBody;
- (BOOL)isSnakeEatFruit;
- (void)increaseSnakeBody;
- (void)putFruit;

@end

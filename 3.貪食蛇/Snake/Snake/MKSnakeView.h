//
//  SnakeView.h
//  Snake
//
//  Created by JzChang on 13/9/20.
//  Copyright (c) 2013年 JzChang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKSnakeModel.h"

@class MKSnakeView;

@protocol MKSnakeViewDataSource <NSObject>

- (NSArray *)snakePointsInSnakeView:(MKSnakeView *)inSnakeView;
- (MKPoint)fruitPointInSnakeView:(MKSnakeView *)inSnakeView;

@end

@interface MKSnakeView : UIView

@property (assign, nonatomic) id <MKSnakeViewDataSource> dataSource;

@end

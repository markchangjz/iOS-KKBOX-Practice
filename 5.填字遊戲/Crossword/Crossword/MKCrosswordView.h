//
//  MKCrosswordView.h
//  Crossword
//
//  Created by Mac on 13/9/30.
//  Copyright (c) 2013年 KKBOX. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct {
    NSUInteger x;
    NSUInteger y;
} MKPoint;

MKPoint MKMakePoint(int pointX, int pointY);

static const int girdWidth = 35;
static const int gridHeight = 55;

@class MKCrosswordView;

@protocol MKCrosswordViewDelegate <NSObject>

- (void)MKCrosswordView:(MKCrosswordView *)MKCrosswordView tapInGridPoint:(MKPoint)gridPoint andWord:(NSString *)word;

@end

@protocol MKCrosswordViewDatasource <NSObject>

- (NSArray *)word;

@end

@interface MKCrosswordView : UIView

@property (weak, nonatomic) id <MKCrosswordViewDelegate> delegate;

- (void)changWord:(NSString *)newWord InGridPoint:(MKPoint)gridPoint;
- (void)handleTap:(UITapGestureRecognizer *)gesture;

@end

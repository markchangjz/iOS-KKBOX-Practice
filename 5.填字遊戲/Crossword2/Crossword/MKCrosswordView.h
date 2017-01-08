//
//  MKCrosswordView.h
//  Crossword
//
//  Created by Mac on 13/10/2.
//  Copyright (c) 2013年 KKBOX. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MKCrosswordView;

@protocol MKCrosswordViewDatasource <NSObject>

- (NSUInteger)rowCountForCrosswordView:(MKCrosswordView *)inView;
- (NSUInteger)columnCountForCrosswordView:(MKCrosswordView *)inView;
- (NSArray *)crosswordViewWordsData:(MKCrosswordView *)inView;
- (void)crosswordView:(MKCrosswordView *)inView setWord:(NSString *)word atRow:(NSUInteger)row andColumn:(NSUInteger)column;

@end

@interface MKCrosswordView : UIView

@property (weak, nonatomic) id <MKCrosswordViewDatasource> dataSoruce;
@property (readonly) UITextField *selectedCellTextField;

@end

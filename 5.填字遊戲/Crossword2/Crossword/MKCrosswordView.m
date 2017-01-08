//
//  MKCrosswordView.m
//  Crossword
//
//  Created by Mac on 13/10/2.
//  Copyright (c) 2013年 KKBOX. All rights reserved.
//

#import "MKCrosswordView.h"

static const CGFloat paddingX = 20.0;
static const CGFloat paddingY = 20.0;

@interface MKCrosswordView () <UITextFieldDelegate> {
    NSUInteger editCellX, editCellY;
    NSUInteger cellWidth, cellHeight;
}

@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;
@property (strong, nonatomic) UITextField *cellTextField;

@end

@implementation MKCrosswordView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addGestureRecognizer:self.tapGestureRecognizer];
        [self addSubview:self.cellTextField];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    NSInteger rowCount = [self.dataSoruce rowCountForCrosswordView:self];
    NSInteger columnCount = [self.dataSoruce columnCountForCrosswordView:self];
    
    cellWidth = (frame.size.width - (paddingX * 2)) / (columnCount ? columnCount : 1);
    cellHeight = (frame.size.height - (paddingY * 2)) / (rowCount ? rowCount : 1);
    
    self.cellTextField.frame = CGRectMake(editCellX * cellWidth + paddingX, editCellY * cellHeight + paddingY, cellWidth, cellHeight);
}

- (void)drawRect:(CGRect)rect
{
    NSAssert([self _isWordsDataValid], @"資料不合法");
    
    // Drawing code
    [self _drawGrid];
    [self _drawWords];
}

#pragma mark - private function

- (BOOL)_isWordsDataValid
{
    if ([self.dataSoruce crosswordViewWordsData:self].count != [self.dataSoruce rowCountForCrosswordView:self]) {
        return NO;
    }
    
    for (NSArray *row in [self.dataSoruce crosswordViewWordsData:self]) {
        if (row.count != [self.dataSoruce columnCountForCrosswordView:self]) {
            return NO;
        }
    }
    
    return YES;
}

- (void)_drawGrid
{
    int rowCount = [self.dataSoruce rowCountForCrosswordView:self];
    int columnCount = [self.dataSoruce columnCountForCrosswordView:self];
    
    UIBezierPath *gridPath = [[UIBezierPath alloc] init];
    
    // 畫直線
    for (int x = paddingX; x <= (cellWidth * columnCount + paddingX); x += cellWidth) {
        [gridPath moveToPoint:CGPointMake(x, paddingY)];
        [gridPath addLineToPoint:CGPointMake(x, rowCount * cellHeight + paddingY)];
    }
    
    // 畫橫線
    for (int y = paddingY; y <= (cellHeight * rowCount + paddingY); y += cellHeight) {
        [gridPath moveToPoint:CGPointMake(paddingX, y)];
        [gridPath addLineToPoint:CGPointMake(columnCount * cellWidth + paddingX, y)];
    }
    
    [gridPath stroke];
}

- (void)_drawWords
{
    for (int x = 0; x < [self.dataSoruce rowCountForCrosswordView:self]; x++) {
        for (int y = 0; y < [self.dataSoruce columnCountForCrosswordView:self]; y++) {
            [[self.dataSoruce crosswordViewWordsData:self][x][y] drawInRect:CGRectMake(y * cellWidth + paddingX, x * cellHeight + paddingY, cellWidth, cellHeight)
                                                                   withFont:[UIFont boldSystemFontOfSize:20]];
        }
    }
}

- (void)_handleTap:(UITapGestureRecognizer *)gesture
{
    NSUInteger tapInCellX = ([gesture locationInView:self].x - paddingX) / cellWidth;
    NSUInteger tapInCellY = ([gesture locationInView:self].y - paddingY) / cellHeight;
            
    [self changeEditCellTextFieldAtCellX:tapInCellX andCellY:tapInCellY];
}

- (void)changeEditCellTextFieldAtCellX:(NSUInteger)cellX andCellY:(NSUInteger)cellY
{
    if (cellX < [self.dataSoruce columnCountForCrosswordView:self] && cellY < [self.dataSoruce rowCountForCrosswordView:self] && self.cellTextField.hidden == YES) {
        editCellX = cellX;
        editCellY = cellY;
        
        self.cellTextField.hidden = NO;
        self.cellTextField.text = [self.dataSoruce crosswordViewWordsData:self][cellY][cellX];
        self.cellTextField.frame = CGRectMake((cellX * cellWidth) + paddingX, (cellY * cellHeight) + paddingY, cellWidth, cellHeight);
        [self.cellTextField becomeFirstResponder];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.cellTextField.hidden = YES;
    [textField resignFirstResponder];

    [self.dataSoruce crosswordView:self setWord:textField.text atRow:editCellX andColumn:editCellY];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    self.cellTextField.text = @"";
    
    return YES;
}

#pragma mark - lazy instantiation

- (UITapGestureRecognizer *)tapGestureRecognizer
{
    if (!_tapGestureRecognizer) {
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handleTap:)];
    }
    
    return _tapGestureRecognizer;
}

- (UITextField *)cellTextField
{
    if (!_cellTextField) {
        _cellTextField = [[UITextField alloc] initWithFrame:CGRectMake(paddingX, paddingY, cellWidth, cellHeight)];
        [_cellTextField setBackgroundColor:[UIColor blackColor]];
        [_cellTextField setTextColor:[UIColor whiteColor]];
        [_cellTextField setFont:[UIFont boldSystemFontOfSize:20]];
        [_cellTextField setReturnKeyType:UIReturnKeyDone];
        [_cellTextField setDelegate:self];
        [_cellTextField setHidden:YES];
    }

    return _cellTextField;
}

- (UITextField *)selectedCellTextField
{
    return self.cellTextField;
}

@end

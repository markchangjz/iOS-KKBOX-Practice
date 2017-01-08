//
//  ViewController.m
//  Crossword
//
//  Created by Mac on 13/10/2.
//  Copyright (c) 2013年 KKBOX. All rights reserved.
//

#import "ViewController.h"

#define ScreenWidth [[UIScreen mainScreen] bounds].size.width

@interface ViewController () <MKCrosswordViewDatasource> {
    CGFloat keyboardTop;
    CGFloat moveViewOffset;
    CGRect selectedTextFieldInWindowRect;
    CGRect crosswordViewInWindowRect;
    CGRect keyboardRect;
}

@property (strong, nonatomic) MKCrossword *crossword;
@property (strong, nonatomic) MKCrosswordView *crosswordView;
@property (strong, nonatomic) UIScrollView *crosswordScrollView;

@end

@implementation ViewController

@synthesize crosswordScrollView = crosswordScrollView;
@synthesize crosswordView = crosswordView;

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    CGRect frame = self.view.frame;
//    frame.origin.y -= 30.0;
//    frame.size.width -= 30.0;
//    frame.size.height -= 50.0;
    
    self.crosswordView = [[MKCrosswordView alloc] init];
    self.crosswordView.dataSoruce = self;
    self.crosswordView.frame = frame;
    self.crosswordView.backgroundColor = [UIColor whiteColor];
    self.crosswordView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    self.crosswordScrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    self.crosswordScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.crosswordScrollView addSubview:self.crosswordView];
    [self.view addSubview:self.crosswordScrollView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.crosswordScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    [self.crosswordView setNeedsDisplay];
}

#pragma mark - private function

- (BOOL)_isOrientationIsPortrait
{
    return UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]);
}

- (BOOL)_isOrientationLandscapeLeft
{
    return [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft;
}

- (BOOL)_isOrientationLandscapeRight
{
    return [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight;
}

- (void)_adjustViewLocation
{
    selectedTextFieldInWindowRect = [self.view.window convertRect:self.crosswordView.selectedCellTextField.bounds fromView:self.crosswordView.selectedCellTextField];
    crosswordViewInWindowRect = [self.view.window convertRect:self.crosswordView.frame fromView:nil];
    
    if ([self _isOrientationIsPortrait]) {
        [self _adjustViewWhenOrientationIsPortrait];
    }
    else if ([self _isOrientationLandscapeLeft]) {
        [self _adjustViewWhenOrientationLandscapeLeft];
    }
    else if ([self _isOrientationLandscapeRight]) {
        [self _adjustViewWhenOrientationLandscapeRight];
    }
}

- (void)_adjustViewWhenOrientationIsPortrait
{
    if (CGRectIntersectsRect(selectedTextFieldInWindowRect, keyboardRect)) {
        moveViewOffset = (selectedTextFieldInWindowRect.origin.y + selectedTextFieldInWindowRect.size.height) - keyboardTop;
        [self.crosswordScrollView setContentOffset:CGPointMake(0, moveViewOffset) animated:NO];
    }
    else if (selectedTextFieldInWindowRect.origin.y < 0) {
        [self.crosswordScrollView setContentOffset:CGPointMake(0, crosswordViewInWindowRect.origin.y) animated:NO];
    }
}

- (void)_adjustViewWhenOrientationLandscapeLeft
{
    if (CGRectIntersectsRect(selectedTextFieldInWindowRect, keyboardRect)) {
        moveViewOffset = (selectedTextFieldInWindowRect.origin.x + selectedTextFieldInWindowRect.size.width) - keyboardTop;
        [self.crosswordScrollView setContentOffset:CGPointMake(0, moveViewOffset) animated:NO];
    }
    else if (selectedTextFieldInWindowRect.origin.x < 0) {
        [self.crosswordScrollView setContentOffset:CGPointMake(0, crosswordViewInWindowRect.origin.y) animated:NO];
    }
    
//    NSLog(@"moveViewOffset - %f, %f, %f, %f, %f", self.crosswordScrollView.contentOffset.y, selectedTextFieldInWindowRect.origin.x, selectedTextFieldInWindowRect.origin.y, selectedTextFieldInWindowRect.size.width, selectedTextFieldInWindowRect.size.height);
    
}

- (void)_adjustViewWhenOrientationLandscapeRight
{
    if (CGRectIntersectsRect(selectedTextFieldInWindowRect, keyboardRect)) {
        moveViewOffset = (ScreenWidth - keyboardTop) - selectedTextFieldInWindowRect.origin.x;
        [self.crosswordScrollView setContentOffset:CGPointMake(0, moveViewOffset) animated:NO];
    }
    else if (selectedTextFieldInWindowRect.origin.x + selectedTextFieldInWindowRect.size.width > ScreenWidth) {
        [self.crosswordScrollView setContentOffset:CGPointMake(0, crosswordViewInWindowRect.origin.y) animated:NO];
    }
}

- (void)_keyboardDidShow:(NSNotification *)notification
{
    NSValue *keyboardRectValue = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    keyboardRect = [keyboardRectValue CGRectValue];
//    keyboardTop = [self _isOrientationIsPortrait] ? keyboardRect.origin.y : ScreenWidth - keyboardRect.size.width - keyboardRect.origin.x;
    
    if ([self _isOrientationIsPortrait]) {
        keyboardTop = keyboardRect.origin.y;
    }
    else if ([self _isOrientationLandscapeLeft]) {
        keyboardTop = keyboardRect.origin.x;
    }
    else if ([self _isOrientationLandscapeRight]) {
        keyboardTop = ScreenWidth - keyboardRect.size.width - keyboardRect.origin.x;
    }
    
    [self _adjustViewLocation];
}

- (void)_keyboardWillHide:(NSNotification *)notification
{    
    [self.crosswordScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
}

#pragma mark - MKCrosswordViewDatasource

- (NSUInteger)rowCountForCrosswordView:(MKCrosswordView *)inView
{
    return rowCount;
}

- (NSUInteger)columnCountForCrosswordView:(MKCrosswordView *)inView
{
    return columnCount;
}

- (void)crosswordView:(MKCrosswordView *)inView setWord:(NSString *)word atRow:(NSUInteger)row andColumn:(NSUInteger)column
{
    self.crossword.words[column][row] = word;
    [self.crosswordView setNeedsDisplay];
}

- (NSArray *)crosswordViewWordsData:(MKCrosswordView *)inView
{
    return self.crossword.words;
}

#pragma mark - lazy instantiation

- (MKCrossword *)crossword
{
    if (!_crossword) {
        _crossword = [[MKCrossword alloc] init];
    }
    
    return _crossword;
}

@end

//
//  FakeViewController.m
//  Crossword
//
//  Created by Mac on 13/10/8.
//  Copyright (c) 2013年 KKBOX. All rights reserved.
//

#import "FakeViewController.h"

@interface FakeViewController ()

@end

@implementation FakeViewController

- (CGPoint)crosswordScrollViewContentOffset
{
    return crosswordScrollView.contentOffset;
}

- (MKCrosswordView *)crosswordView
{
    return crosswordView;
}

- (UIScrollView *)crosswordScrollView
{
    return crosswordScrollView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (BOOL)_isOrientationIsPortrait
{
    return YES;
}

- (BOOL)_isOrientationLandscapeLeft
{
    return NO;
}

- (BOOL)_isOrientationLandscapeRight
{
    return NO;
}

@end

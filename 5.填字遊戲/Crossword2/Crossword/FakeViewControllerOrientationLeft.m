//
//  FakeViewControllerOrientationLeft.m
//  Crossword
//
//  Created by Mac on 13/10/9.
//  Copyright (c) 2013年 KKBOX. All rights reserved.
//

#import "FakeViewControllerOrientationLeft.h"

@interface FakeViewControllerOrientationLeft ()

@end

@implementation FakeViewControllerOrientationLeft

- (BOOL)_isOrientationIsPortrait
{
    return NO;
}

- (BOOL)_isOrientationLandscapeLeft
{
    return YES;
}

- (BOOL)_isOrientationLandscapeRight
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeLeft;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation // iOS 6 autorotation fix
{
    return UIInterfaceOrientationLandscapeLeft;
}

@end

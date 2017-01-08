//
//  FakeViewControllerOrientationRight.m
//  Crossword
//
//  Created by Mac on 13/10/9.
//  Copyright (c) 2013年 KKBOX. All rights reserved.
//

#import "FakeViewControllerOrientationRight.h"

@interface FakeViewControllerOrientationRight ()

@end

@implementation FakeViewControllerOrientationRight

- (BOOL)_isOrientationIsPortrait
{
    return NO;
}

- (BOOL)_isOrientationLandscapeLeft
{
    return NO;
}

- (BOOL)_isOrientationLandscapeRight
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation // iOS 6 autorotation fix
{
    return UIInterfaceOrientationLandscapeRight;
}

@end

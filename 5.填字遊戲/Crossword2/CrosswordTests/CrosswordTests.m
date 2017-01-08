//
//  CrosswordTests.m
//  CrosswordTests
//
//  Created by Mac on 13/10/2.
//  Copyright (c) 2013年 KKBOX. All rights reserved.
//

#import "CrosswordTests.h"
#import "FakeViewController.h"
#import "FakeViewControllerOrientationLeft.h"
#import "FakeViewControllerOrientationRight.h"

#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height

@implementation CrosswordTests 
{
    FakeViewController *fakeViewController;
    FakeViewControllerOrientationLeft *fakeViewControllerOrientationLeft;
    FakeViewControllerOrientationRight *fakeViewControllerOrientationRight;
    UIWindow *window;
}

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testSetWord
{
    fakeViewController = [[FakeViewController alloc] init];
    [fakeViewController viewDidLoad];
    
    NSString *newWord = @"K";
    NSUInteger row = 0, column = 0;
    
    [[fakeViewController crosswordView].dataSoruce crosswordView:[fakeViewController crosswordView] setWord:newWord atRow:row andColumn:column];
    
    STAssertTrue([[[fakeViewController crosswordView].dataSoruce crosswordViewWordsData:[fakeViewController crosswordView]][column][row] isEqualToString:newWord], @"After setting the value must equal %@", newWord);
}

- (void)testRowCount
{
    fakeViewController = [[FakeViewController alloc] init];
    [fakeViewController viewDidLoad];
    
    STAssertTrue([[fakeViewController crosswordView].dataSoruce rowCountForCrosswordView:[fakeViewController crosswordView]] == rowCount, @"Two different values");
}

- (void)testColumnCount
{
    fakeViewController = [[FakeViewController alloc] init];
    [fakeViewController viewDidLoad];
    
    STAssertTrue([[fakeViewController crosswordView].dataSoruce columnCountForCrosswordView:[fakeViewController crosswordView]] == columnCount, @"Two different values");
}

- (void)testAdjustViewWhenOrientationIsPortrait
{
    for (NSUInteger cellX = 0; cellX < rowCount; cellX++) {
        for (NSUInteger cellY = 0; cellY < columnCount; cellY++) {
            
            fakeViewController = [[FakeViewController alloc] init];
            
            window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
            window.rootViewController = fakeViewController;
            window.hidden = YES;
            [window addSubview:fakeViewController.view];
            
            STAssertNotNil(fakeViewController.view.window, @"Window must not be nil");

            CGRect crosswordViewInWindowRect = [window convertRect:[fakeViewController crosswordView].frame fromView:nil];
            
            SEL testSelector = @selector(changeEditCellTextFieldAtCellX:andCellY:);
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[[fakeViewController crosswordView] methodSignatureForSelector:testSelector]];
            [invocation setSelector:testSelector];
            [invocation setTarget:[fakeViewController crosswordView]];
            [invocation setArgument:&cellX atIndex:2];
            [invocation setArgument:&cellY atIndex:3];
            [invocation invoke];
            
            
            CGRect keyboardRect = CGRectMake(0, 264, ScreenWidth, ScreenHeight - 264);
            CGFloat keyboardTop = keyboardRect.origin.y;
            CGRect inSelectedTextFieldInWindowRect = [window convertRect:[fakeViewController crosswordView].selectedCellTextField.bounds fromView:[fakeViewController crosswordView].selectedCellTextField];
            CGFloat moveViewOffset = (inSelectedTextFieldInWindowRect.origin.y + inSelectedTextFieldInWindowRect.size.height) - keyboardTop;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardDidShowNotification
                                                                object:self
                                                              userInfo:@{UIKeyboardFrameEndUserInfoKey: [NSValue valueWithCGRect:keyboardRect]}];
            
            if (moveViewOffset > 0) {
                if (inSelectedTextFieldInWindowRect.origin.y < ScreenHeight) {
                    STAssertEquals([fakeViewController crosswordScrollViewContentOffset].y, moveViewOffset, @"moveViewOffset must equal %f, at (%d, %d)", moveViewOffset, cellX, cellY);
                }
                else {
                    STAssertEquals([fakeViewController crosswordScrollViewContentOffset].y, (CGFloat)0.0, @"moveViewOffset must equal %f, at (%d, %d)", moveViewOffset, cellX, cellY);
                }
            }
            else {
                if (inSelectedTextFieldInWindowRect.origin.y > 0) {
                    STAssertEquals([fakeViewController crosswordScrollViewContentOffset].y, (CGFloat)0.0, @"moveViewOffset must equal %f, at (%d, %d)", moveViewOffset, cellX, cellY);
                }
                else {
                    STAssertEquals([fakeViewController crosswordScrollViewContentOffset].y, crosswordViewInWindowRect.origin.y, @"moveViewOffset must equal %f, at (%d, %d)", moveViewOffset, cellX, cellY);
                }
            }
        }
    }
}

- (void)testAdjustViewWhenOrientationLandscapeLeft
{
    for (NSUInteger cellX = 0; cellX < rowCount; cellX++) {
        for (NSUInteger cellY = 0; cellY < columnCount; cellY++) {

            fakeViewControllerOrientationLeft = [[FakeViewControllerOrientationLeft alloc] init];
            
            window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
            window.rootViewController = fakeViewControllerOrientationLeft;
            window.hidden = YES;
            [window addSubview:fakeViewControllerOrientationLeft.view];
            
            STAssertNotNil(fakeViewControllerOrientationLeft.view.window, @"Window must not be nil");
                        
            SEL testSelector = @selector(changeEditCellTextFieldAtCellX:andCellY:);
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[[fakeViewControllerOrientationLeft crosswordView] methodSignatureForSelector:testSelector]];
            [invocation setSelector:testSelector];
            [invocation setTarget:[fakeViewControllerOrientationLeft crosswordView]];
            [invocation setArgument:&cellX atIndex:2];
            [invocation setArgument:&cellY atIndex:3];
            [invocation invoke];
            
            CGRect keyboardRect = CGRectMake(158, 0, ScreenWidth - 158, ScreenHeight);
            CGFloat keyboardTop = keyboardRect.origin.x;
            CGRect inSelectedTextFieldInWindowRect = [window convertRect:[fakeViewControllerOrientationLeft crosswordView].selectedCellTextField.bounds fromView:[fakeViewControllerOrientationLeft crosswordView].selectedCellTextField];
            CGFloat moveViewOffset = (inSelectedTextFieldInWindowRect.origin.x + inSelectedTextFieldInWindowRect.size.width) - keyboardTop;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardDidShowNotification
                                                                object:self
                                                              userInfo:@{UIKeyboardFrameEndUserInfoKey: [NSValue valueWithCGRect:keyboardRect]}];
            
            if ((inSelectedTextFieldInWindowRect.origin.y > ScreenHeight) || (moveViewOffset < 0) || (inSelectedTextFieldInWindowRect.origin.y + inSelectedTextFieldInWindowRect.size.height) < 0) {
                STAssertEquals([fakeViewControllerOrientationLeft crosswordScrollViewContentOffset].y, (CGFloat)0.0, @"moveViewOffset must equal %f, at (%d, %d)", moveViewOffset, cellX, cellY);
            }
            else {
                STAssertEquals([fakeViewControllerOrientationLeft crosswordScrollViewContentOffset].y, moveViewOffset, @"moveViewOffset must equal %f, at (%d, %d)", moveViewOffset, cellX, cellY);
            } 
        }
    }
}

- (void)testAdjustViewWhenOrientationLandscapeRight
{
    for (NSUInteger cellX = 0; cellX < rowCount; cellX++) {
        for (NSUInteger cellY = 0; cellY < columnCount; cellY++) {
            
            fakeViewControllerOrientationRight = [[FakeViewControllerOrientationRight alloc] init];
            
            window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
            window.rootViewController = fakeViewControllerOrientationRight;
            window.hidden = YES;
            [window addSubview:fakeViewControllerOrientationRight.view];
            
            STAssertNotNil(fakeViewControllerOrientationRight.view.window, @"Window must not be nil");

            SEL testSelector = @selector(changeEditCellTextFieldAtCellX:andCellY:);
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[[fakeViewControllerOrientationRight crosswordView] methodSignatureForSelector:testSelector]];
            [invocation setSelector:testSelector];
            [invocation setTarget:[fakeViewControllerOrientationRight crosswordView]];
            [invocation setArgument:&cellX atIndex:2];
            [invocation setArgument:&cellY atIndex:3];
            [invocation invoke];
            
            CGRect keyboardRect = CGRectMake(0, 0, 162, ScreenHeight);
            CGFloat keyboardTop = ScreenWidth - keyboardRect.size.width - keyboardRect.origin.x;
            CGRect inSelectedTextFieldInWindowRect = [window convertRect:[fakeViewControllerOrientationRight crosswordView].selectedCellTextField.bounds fromView:[fakeViewControllerOrientationRight crosswordView].selectedCellTextField];
            CGFloat moveViewOffset = (ScreenWidth - keyboardTop) - inSelectedTextFieldInWindowRect.origin.x;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardDidShowNotification
                                                                object:self
                                                              userInfo:@{UIKeyboardFrameEndUserInfoKey: [NSValue valueWithCGRect:keyboardRect]}];
            
            if ((inSelectedTextFieldInWindowRect.origin.y > ScreenHeight) || (moveViewOffset < 0) || (inSelectedTextFieldInWindowRect.origin.y + inSelectedTextFieldInWindowRect.size.height) < 0) {
                STAssertEquals([fakeViewControllerOrientationRight crosswordScrollViewContentOffset].y, (CGFloat)0.0, @"moveViewOffset must equal %f, at (%d, %d)", moveViewOffset, cellX, cellY);
            }
            else {
                STAssertEquals([fakeViewControllerOrientationRight crosswordScrollViewContentOffset].y, moveViewOffset, @"moveViewOffset must equal %f, at (%d, %d)", moveViewOffset, cellX, cellY);
            }
        }
    }
}

@end

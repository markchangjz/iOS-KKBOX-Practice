//
//  ViewController.m
//  calc
//
//  Created by Mac on 13/9/16.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    BOOL isTappedNumber;
    BOOL isTappedOperator;
    NSString *currentOperator;
}

@property (strong, nonatomic) NSDecimalNumber *calcNum1;

@end

@implementation ViewController

- (void)dealloc
{
    [_displayLabel release];
    [_calcNum1 release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    [self resetConfig];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Add function

- (void)resetConfig
{
    self.calcNum1 = [NSDecimalNumber decimalNumberWithString:@"0"];
    isTappedNumber = NO;
    isTappedOperator = NO;
    currentOperator = @"";
}

- (void)doCalculate
{
    if ([currentOperator isEqualToString:@""]) {
        return;
    }
    
    NSDecimalNumber *num1 = self.calcNum1;
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:self.displayLabel.text];
    
    NSLog(@"%@ %@ %@", num1, currentOperator, num2);
    
    if ([currentOperator isEqualToString:@"/"]) {
        if ([[num2 stringValue] isEqualToString:@"0"]) {
            self.displayLabel.text = @"ERROR";
            [self resetConfig];
            return;
        }
        else {
            self.calcNum1 = [num1 decimalNumberByDividingBy:num2];
        }
    }
    else if ([currentOperator isEqualToString:@"*"]) {
        self.calcNum1 = [num1 decimalNumberByMultiplyingBy:num2];
    }
    else if ([currentOperator isEqualToString:@"-"]) {
        self.calcNum1 = [num1 decimalNumberBySubtracting:num2];
    }
    else if ([currentOperator isEqualToString:@"+"]) {
        self.calcNum1 = [num1 decimalNumberByAdding:num2];
    }
    
    self.displayLabel.text = [self.calcNum1 stringValue];
    
    currentOperator = @"";
    
    NSLog(@"= %@", [self.calcNum1 stringValue]);
}

#pragma mark - IBAction

- (IBAction)tapDigits:(UIButton *)sender
{
    // 使用者按.變成0.
    if ([[sender currentTitle] isEqualToString:@"."] && isTappedOperator) {
        self.displayLabel.text = @"0.";
    }
    
    if (!isTappedNumber) {
        if ([[sender currentTitle] isEqualToString:@"."]) {
            // 檢查字串是否包含小數點
            if ([self.displayLabel.text rangeOfString:@"."].location == NSNotFound) {
                self.displayLabel.text = [self.displayLabel.text stringByAppendingString:@"."];
            }

            isTappedNumber = YES;
        }
        else if ([[sender currentTitle] isEqualToString:@"0"]) {
            self.displayLabel.text = @"0";
        }
        else {
            self.displayLabel.text = [sender currentTitle];
            isTappedNumber = YES;
        }
    }
    else {
        if ([[sender currentTitle] isEqualToString:@"."]) {
            // 檢查字串是否包含小數點
            if ([self.displayLabel.text rangeOfString:@"."].location != NSNotFound) {
                return;
            }
        }
        self.displayLabel.text = [self.displayLabel.text stringByAppendingString:[sender currentTitle]];
    }
    
    isTappedOperator = NO;
}

- (IBAction)tapClear:(UIButton *)sender
{
    self.displayLabel.text = @"0";
    [self resetConfig];
}

- (IBAction)tapOperators:(UIButton *)sender
{
    if (isTappedOperator) {
        // 使用者更改計算
        currentOperator = [sender currentTitle];
        return;
    }
    
    if (![currentOperator isEqualToString:@""]) {
        [self doCalculate];
    }
    else {
        self.calcNum1 = [NSDecimalNumber decimalNumberWithString:self.displayLabel.text];
    }

    if (currentOperator) {
        [currentOperator release];
    }
    
    currentOperator = [[sender currentTitle] retain];
    
    isTappedNumber = NO;
    isTappedOperator = YES;
}

- (IBAction)tapEqualSign:(UIButton *)sender
{    
    [self doCalculate];
}

@end

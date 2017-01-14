//
//  ViewController.m
//  StrReverse
//
//  Created by Mac on 13/9/18.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "ViewController.h"
#import "NSString+reverseString.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_enterTextField release];
    [_reverseTextLabel release];
    [super dealloc];
}

- (IBAction)tapReverseButton:(UIButton *)sender
{
    NSString *oriString = self.enterTextField.text;
    
//    self.reverseTextLabel.text = [oriString reverseStr];
    self.reverseTextLabel.text = [oriString reversedString];
}
@end

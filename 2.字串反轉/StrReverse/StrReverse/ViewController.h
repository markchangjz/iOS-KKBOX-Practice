//
//  ViewController.h
//  StrReverse
//
//  Created by Mac on 13/9/18.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (retain, nonatomic) IBOutlet UITextField *enterTextField;
@property (retain, nonatomic) IBOutlet UILabel *reverseTextLabel;
- (IBAction)tapReverseButton:(UIButton *)sender;

@end

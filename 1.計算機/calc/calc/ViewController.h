//
//  ViewController.h
//  calc
//
//  Created by Mac on 13/9/16.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController


@property (retain, nonatomic) IBOutlet UILabel *displayLabel;

- (IBAction)tapDigits:(UIButton *)sender;
- (IBAction)tapClear:(UIButton *)sender;
- (IBAction)tapOperators:(UIButton *)sender;
- (IBAction)tapEqualSign:(UIButton *)sender;

@end

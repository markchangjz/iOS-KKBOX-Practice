//
//  FakeViewController.h
//  Crossword
//
//  Created by Mac on 13/10/8.
//  Copyright (c) 2013年 KKBOX. All rights reserved.
//

#import "ViewController.h"
#import "MKCrosswordView.h"

@interface FakeViewController : ViewController

- (CGPoint)crosswordScrollViewContentOffset;
- (MKCrosswordView *)crosswordView;
- (UIScrollView *)crosswordScrollView;

@end

//
//  ViewController.h
//  Crossword
//
//  Created by Mac on 13/10/2.
//  Copyright (c) 2013年 KKBOX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKCrossword.h"
#import "MKCrosswordView.h"

@interface ViewController : UIViewController {
@protected
    UIScrollView *crosswordScrollView;
    MKCrosswordView *crosswordView;
}

@end

//
//  MKCrossword.h
//  Crossword
//
//  Created by Mac on 13/10/2.
//  Copyright (c) 2013年 KKBOX. All rights reserved.
//

#import <Foundation/Foundation.h>

static const NSUInteger rowCount = 8;
static const NSUInteger columnCount = 8;

@interface MKCrossword : NSObject

@property (strong, nonatomic) NSMutableArray *words;

@end
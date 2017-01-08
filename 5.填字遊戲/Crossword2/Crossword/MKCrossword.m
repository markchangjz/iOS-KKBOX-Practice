//
//  MKCrossword.m
//  Crossword
//
//  Created by Mac on 13/10/2.
//  Copyright (c) 2013年 KKBOX. All rights reserved.
//

#import "MKCrossword.h"

@implementation MKCrossword

#pragma mark - lazy instantiation

- (NSMutableArray *)words
{
    if (!_words) {
        NSString *string1 = @"台灣人需要消波塊";
        NSString *string2 = @"消波塊需要台灣人";
        
        _words = [[NSMutableArray alloc] init];
        NSMutableArray *rowWords;
        
        for (NSUInteger row = 0; row < rowCount; row++) {
            rowWords = [[NSMutableArray alloc] init];
            for (NSUInteger column = 0; column < columnCount; column++) {
                if (row % 2 == 0) {
                    [rowWords addObject:[string1 substringWithRange:NSMakeRange(column % string1.length, 1)]];
                }
                else {
                    [rowWords addObject:[string2 substringWithRange:NSMakeRange(column % string1.length, 1)]];
                }
            }
            [_words addObject:rowWords];
        }
    }
    
    return _words;
}

@end

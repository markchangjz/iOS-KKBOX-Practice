//
//  SearchTests.m
//  SearchTests
//
//  Created by Mac on 13/9/25.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "SearchTests.h"
#import "NSString+Trim.h"
#import "MKSearch.h"
#import "SearchViewController.h"

@implementation SearchTests
{
    BOOL waitingForResponse;
    NSArray *searchKeywords;
    NSString *searchKeyword;
}

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testTrimmedString
{
    STAssertEquals([@"ABC" trimmedString], @"ABC", @"字串需相同");
    STAssertTrue([[@"ABC " trimmedString] isEqualToString:@"ABC"], @"字串需相同");
    STAssertTrue([[@" ABC" trimmedString] isEqualToString:@"ABC"], @"字串需相同");
    STAssertTrue([[@" ABC " trimmedString] isEqualToString:@"ABC"], @"字串需相同");
    STAssertTrue([[@" AB C " trimmedString] isEqualToString:@"AB C"], @"字串需相同");
}

- (void)testReceivedData
{
    MKSearch *mkSearch = [[MKSearch alloc] init];
    
    searchKeywords = @[@"Jolin", @"Michael Jackson", @"五月天"];
    
    SearchViewController *searchViewController = [[SearchViewController alloc] initWithStyle:UITableViewStylePlain];

    for (NSString *keyword in searchKeywords) {
        [mkSearch searchKKBOXWithKeyword:keyword delegate:searchViewController];
        waitingForResponse = YES;
        searchKeyword = keyword;
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
    }
}

- (BOOL)string:(NSString *)str1 containString:(NSString *)str2
{
    return [str1 rangeOfString:str2].location != NSNotFound;
}

- (void)search:(MKSearch *)search didCompleteSearchingWithParsedData:(NSArray *)inData
{
    waitingForResponse = NO;
    
    for (NSDictionary *d in inData) {        
        STAssertTrue([self string:[d objectForKey:@"text"] containString:searchKeyword], @"搜尋到的字串尚未包含 %@", searchKeyword);
    }
}

- (void)search:(MKSearch *)search didFailWithError:(NSError *)error
{
    waitingForResponse = NO;
}

@end

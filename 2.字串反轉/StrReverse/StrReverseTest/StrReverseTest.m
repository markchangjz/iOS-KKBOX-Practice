#import "StrReverseTest.h"
#import "NSString+reverseString.h"

@implementation StrReverseTest

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

//- (void)testExample
//{
//    STFail(@"Unit tests are not implemented yet in StrReverseTest");
//}

- (void)test12345
{
    NSString *s = @"12345";
    NSString *r = [s reverseString];
    STAssertTrue([r isEqualToString:@"54321"] , @"It should be 54321");
}

- (void)testEnglish
{
    NSString *s = @"English";
    NSString *r = [s reverseString];
    STAssertTrue([r isEqualToString:@"hsilgnE"] , @"It should be hsilgnE");
}

- (void)testChinese
{
    NSString *s = @"中文呢？";
    NSString *r = [s reverseString];
    STAssertTrue([r isEqualToString:@"？呢文中"] , @"It should be hsilgnE");
}

- (void)testSomething
{
    NSString *s = @"\t\a\t\a";
    NSString *r = [s reverseString];
    STAssertTrue([r isEqualToString:@"\a\t\a\t"] , @"It should be hsilgnE");    
}

- (void)testEmpty
{
    NSString *s = @"";
    NSString *r = [s reverseString];
    STAssertTrue([r isEqualToString:@""] , @"It should be hsilgnE");
}

- (void)testA
{
    NSString *s = @"A";
    NSString *r = [s reverseString];
    STAssertTrue([r isEqualToString:@"A"] , @"It should be hsilgnE");
}


@end

#import <Foundation/Foundation.h>

@interface MKURLConnection : NSURLConnection

@property (assign, nonatomic) id APIDelegate;
@property (readonly) NSMutableData *data;

@end
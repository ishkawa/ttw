#import <Foundation/Foundation.h>

@interface TTWStreamClient : NSObject <NSURLConnectionDataDelegate>

- (void)connect;
- (void)disconnect;

@end

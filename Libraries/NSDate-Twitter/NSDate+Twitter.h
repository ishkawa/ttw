#import <Foundation/Foundation.h>

@interface NSDate (Twitter)

+ (NSDate *)dateWithTwitterCreatedAtString:(NSString *)string;
+ (NSDate *)dateWithTwitterSearchCreatedAtString:(NSString *)string;

@end

#import "NSDate+Twitter.h"

@implementation NSDate (Twitter)

+ (NSDate *)dateWithTwitterCreatedAtString:(NSString *)string
{
    static NSDateFormatter *formatter = nil;
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        formatter.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    }
    return [formatter dateFromString:string];
}

+ (NSDate *)dateWithTwitterSearchCreatedAtString:(NSString *)string
{
    static NSDateFormatter *formatter = nil;
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        formatter.dateFormat = @"EEE, dd MMM yyyy HH:mm:ss Z";
    }
    return [formatter dateFromString:string];
}

- (NSString *)description
{
    static NSCalendar *cal = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    });
    NSUInteger flag = (NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit);
    NSDateComponents *components = [cal components:flag fromDate:self];
    
    return [NSString stringWithFormat:@"%02ld:%02ld", [components hour], [components minute]];
}

@end

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TTWHTTPMethod) {
    TTWHTTPMethodGET,
    TTWHTTPMethodPOST,
};

@interface TTWRestClient : NSObject

- (void)callAPI:(NSString *)path
         method:(TTWHTTPMethod)method
     parameters:(NSDictionary *)parameters
        handler:(void (^)(NSHTTPURLResponse *response, id object, NSError *error))handler;

@end

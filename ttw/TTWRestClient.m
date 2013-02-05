#import "TTWRestClient.h"
#import "TTWConst.h"
#import "OAuthCore.h"
#import "NSDictionary+URLQuery.h"

static NSString *const TTWRestAPIBaseURL = @"https://api.twitter.com";

@interface TTWRestClient () <NSURLConnectionDataDelegate>

@property (strong, nonatomic) NSMutableData *data;
@property (strong, nonatomic) NSURLRequest *request;
@property (strong, nonatomic) NSURLConnection *connection;
@property (strong, nonatomic) NSHTTPURLResponse *response;
@property (copy, nonatomic) void (^handler)(NSHTTPURLResponse *, id object, NSError *error);

@end

@implementation TTWRestClient

- (void)callAPI:(NSString *)path
         method:(TTWHTTPMethod)method
     parameters:(NSDictionary *)parameters
        handler:(void (^)(NSHTTPURLResponse *, id, NSError *))handler
{
    NSString *URLString = [NSString stringWithFormat:@"%@%@", TTWRestAPIBaseURL, path];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    request.URL = [NSURL URLWithString:URLString];
    
    if (method == TTWHTTPMethodGET) {
        if ([[parameters allKeys] count]) {
            URLString = [URLString stringByAppendingFormat:@"?%@", [parameters URLQuery]];
            request.URL = [NSURL URLWithString:URLString];
        }
        request.HTTPMethod = @"GET";
    }
    if (method == TTWHTTPMethodPOST) {
        request.HTTPMethod = @"POST";
        request.HTTPBody = [[parameters URLQuery] dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    NSString *header = OAuthorizationHeader(request.URL,
                                            request.HTTPMethod,
                                            request.HTTPBody,
                                            TTWConsumerKey,
                                            TTWConsumerSecret,
                                            TTWAccessToken,
                                            TTWAccessTokenSecret);
    
    [request addValue:header forHTTPHeaderField:@"Authorization"];
    
    self.request = request;
    self.handler = handler;
    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.response = (NSHTTPURLResponse *)response;
    self.data = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error = nil;
    id object = [NSJSONSerialization JSONObjectWithData:self.data
                                                options:NSJSONReadingAllowFragments
                                                  error:&error];
    if (error) {
        NSLog(@"JSON parse error: %@", error);
        NSLog(@"request: %@", self.request);
        
        if (self.handler) {
            self.handler(self.response, nil, error);
        }
        return;
    }
    
    if (self.handler) {
        self.handler(self.response, object, nil);
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"connection error: %@", error);
    NSLog(@"request: %@", self.request);
    
    if (self.handler) {
        self.handler(self.response, nil, error);
    }
}

@end

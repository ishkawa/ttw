#import "TTWStreamClient.h"
#import "OAuthCore.h"
#import "OAuth+Additions.h"
#import "NSDate+Twitter.h"
#import "TTWConst.h"

@interface TTWStreamClient () <NSURLConnectionDataDelegate>

@property (strong, nonatomic) NSURLConnection *connection;

@end

@implementation TTWStreamClient

- (void)connect
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    request.HTTPMethod = @"GET";
    request.URL = [NSURL URLWithString:@"https://userstream.twitter.com/1.1/user.json"];
    request.timeoutInterval = 3600.0;
    
    NSString *header = OAuthorizationHeader(request.URL,
                                            request.HTTPMethod,
                                            request.HTTPBody,
                                            TTWConsumerKey,
                                            TTWConsumerSecret,
                                            TTWAccessToken,
                                            TTWAccessTokenSecret);
    
    [request addValue:header forHTTPHeaderField:@"Authorization"];
    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)disconnect
{
    [self.connection cancel];
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    printf("connected.\n");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if ([data isEqualToData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]]) {
        return;
    }
    
    NSError *error = nil;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data
                                                               options:NSJSONReadingAllowFragments
                                                                 error:&error];
    if (error) {
        NSLog(@"JSON parse error: %@", error);
        return;
    }
    
    NSDate *date = [NSDate dateWithTwitterCreatedAtString:[dictionary objectForKey:@"created_at"]];
    NSString *screenName = [[dictionary objectForKey:@"user"] objectForKey:@"screen_name"];
    NSString *text = [dictionary objectForKey:@"text"];
    if (!date || !screenName || !text) {
        return;
    }
    
    printf("\x1b[32m");
    printf("[%s] ",[[date description] cStringUsingEncoding:NSUTF8StringEncoding]);
    printf("\x1b[34m");
    printf("%s: ", [screenName cStringUsingEncoding:NSUTF8StringEncoding]);
    printf("\x1b[39m");
    printf("%s\n", [text cStringUsingEncoding:NSUTF8StringEncoding]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"-- finished");
    [self connect];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"-- error: %@", error);
    [self connect];
}

@end

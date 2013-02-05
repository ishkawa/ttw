#import <Foundation/Foundation.h>
#import "TTWStreamClient.h"
#import "TTWRestClient.h"

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        if (argc < 2) {
            printf("usage: ttw stream\n");
            printf("       ttw post <tweet> \n");
            
            return 1;
        }
        NSString *subcommand = [NSString stringWithCString:argv[1] encoding:NSUTF8StringEncoding];
        
        if ([subcommand isEqualToString:@"stream"]) {
            TTWStreamClient *client = [[TTWStreamClient alloc] init];
            [client connect];
            
            while (1) {
                [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:.1]];
            }
        }
       
        if ([subcommand isEqualToString:@"post"]) {
            if (argc < 3) {
                printf("usage: ttw post <tweet> \n");
                return 1;
            }
            __block BOOL finished = NO;
            NSString *status = [NSString stringWithCString:argv[2] encoding:NSUTF8StringEncoding];
            
            TTWRestClient *client = [[TTWRestClient alloc] init];
            [client callAPI:@"/1.1/statuses/update.json"
                     method:TTWHTTPMethodPOST
                 parameters:@{@"status": status}
                    handler:^(NSHTTPURLResponse *response, id object, NSError *error) {
                        if (error || response.statusCode != 200) {
                            printf("failed.");
                            return;
                        }
                        
                        printf("posted: %s", [[object objectForKey:@"text"] cStringUsingEncoding:NSUTF8StringEncoding]);
                        finished = YES;
                    }];
            
            while (!finished) {
                [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:.1]];
            }
        }
    }

    return 0;
}


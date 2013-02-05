### description

ttw is an extremely minimal twitter client.  
it has only 2 functions:
- display user stream (https://dev.twitter.com/docs/streaming-apis/streams/user)
- post tweet (https://dev.twitter.com/docs/api/1.1/post/statuses/update)

### setup

- `git clone git@github.com:ishkawa/ttw.git`
- `cd ttw`
- `touch ttw/TTWConst.h`
- edit `ttw/TTWConst.h`

```objectivec
static NSString *const TTWConsumerKey       = @"";
static NSString *const TTWConsumerSecret    = @"";
static NSString *const TTWAccessToken       = @"";
static NSString *const TTWAccessTokenSecret = @"";
```

- `xcodebuild`
- `build/Release/ttw stream` or `build/Release/ttw post hoge`

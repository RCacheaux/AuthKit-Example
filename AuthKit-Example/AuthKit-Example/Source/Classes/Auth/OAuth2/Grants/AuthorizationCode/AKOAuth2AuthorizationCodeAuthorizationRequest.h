#import <Foundation/Foundation.h>

@interface AKOAuth2AuthorizationCodeAuthorizationRequest : NSObject
- (id)initWithAuthorizationEndpointBaseURL:(NSURL *)authorizationEndpointBaseURL
                     authorizationCodePath:(NSString *)authorizationCodePath
                                  ClientID:(NSString *)clientID
                               redirectURI:(NSString *)redirectURI
                                     scope:(NSString *)scope;
- (NSURLRequest *)authorizationRequest;
- (NSURL *)redirectURL;
@end

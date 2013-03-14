#import "AKOAuth2AuthorizationCodeAuthorizationRequest.h"

#import <AFNetworking/AFNetworking.h>

@interface AKOAuth2AuthorizationCodeAuthorizationRequest ()
@property(nonatomic, strong) NSURL *authorizationEndpointBaseURL;
@property(nonatomic, strong) NSString *authorizationCodePath;
@property(nonatomic, strong) NSString *responseType;
@property(nonatomic, strong) NSString *clientID;
@property(nonatomic, strong) NSString *redirectURI;
@property(nonatomic, strong) NSString *scope;
@property(nonatomic, strong) NSString *state;
@end

static NSString * const kAuthorizationCodeRequestResponseType = @"code";

@implementation AKOAuth2AuthorizationCodeAuthorizationRequest

- (id)initWithAuthorizationEndpointBaseURL:(NSURL *)authorizationEndpointBaseURL
                     authorizationCodePath:(NSString *)authorizationCodePath
                                  ClientID:(NSString *)clientID
                               redirectURI:(NSString *)redirectURI
                                     scope:(NSString *)scope {
  self = [super init];
  if (self) {
    self.authorizationEndpointBaseURL = authorizationEndpointBaseURL;
    self.authorizationCodePath = authorizationCodePath;
    self.responseType = kAuthorizationCodeRequestResponseType;
    self.clientID = clientID;
    self.redirectURI = redirectURI;
    self.scope = scope;
    self.state = [[NSUUID UUID] UUIDString];
  }
  return self;
}

- (NSURLRequest *)authorizationRequest {
  NSDictionary *queryStringParameters = @{@"response_type": self.responseType,
                                          @"client_id" : self.clientID,
                                          @"redirect_uri" : self.redirectURI,
                                          @"scope" : self.scope,
                                          @"state" : self.state};
  
  AFHTTPClient *httpClient =
      [AFHTTPClient clientWithBaseURL:self.authorizationEndpointBaseURL];
  NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                          path:self.authorizationCodePath
                                                    parameters:queryStringParameters];
  return [request copy];
}

- (NSURL *)redirectURL {
  return [NSURL URLWithString:self.redirectURI];
}

@end

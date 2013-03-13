#import "AKLinkedInAuth.h"

#import <AFOAuth2Client/AFOAuth2Client.h>
#import <CocoaLumberjack/DDLog.h>

#import "AKAppDelegate.h"
#import "AKAuthenticationHandler.h"
#import "AKWebViewController.h"

typedef void (^AFOAuth2AuthenticationSuccess)(AFOAuthCredential *credential);
typedef void (^AFOAuth2AuthenticationFailure)(NSError *error);

static const int ddLogLevel = LOG_LEVEL_VERBOSE;

@implementation AKLinkedInAuth

+ (AKLinkedInAuth *)sharedLinkedInAuth {
  static AKLinkedInAuth *_sharedLinkedInAuth = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedLinkedInAuth = [[self alloc] init];
  });
  return _sharedLinkedInAuth;
}

- (void)openSession {
  NSString *authorizationCodeRequestQueryString =
      [NSString stringWithFormat:@"response_type=%@&"
                                 @"client_id=%@&"
                                 @"scope=%@&"
                                 @"state=%@&"
                                 @"redirect_uri=%@",
                                 @"code",
                                 @"5se92tdnfz61",
                                 @"r_basicprofile",
                                 @"GneNrlqv99QIZTTq",
                                 @"http://www.theiosengineer.com"];
  
  NSString *authorizationCodeRequestURLString =
      [NSString stringWithFormat:@"https://www.linkedin.com/uas/oauth2/authorization?%@",
                                 authorizationCodeRequestQueryString];
  NSURL *authorizationCodeRequestURL =
      [NSURL URLWithString:authorizationCodeRequestURLString];
  
  AKWebViewController *webViewController =
      [[AKWebViewController alloc] initWithWebViewURL:authorizationCodeRequestURL];
  webViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
  AKAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
  [appDelegate.window.rootViewController presentViewController:webViewController
                                                      animated:YES
                                                    completion:nil];
  
  /*
  
  NSURL *linkedInAuthServerBaseURL =
      [NSURL URLWithString:@"https://www.linkedin.com/"];
  AFOAuth2Client *linkedInOAuth2Client =
      [AFOAuth2Client clientWithBaseURL:linkedInAuthServerBaseURL
                               clientID:@"hrsfw0wa1l0x"
                                 secret:@"qbQ3Tr8zHe0vK8ot"];
  AKLinkedInAuth __weak *weakSelf = self;
  AFOAuth2AuthenticationSuccess authenticationSuccess = ^(AFOAuthCredential *credential){
    [weakSelf.authenticationHandler userDidLogin:weakSelf];
  };
  AFOAuth2AuthenticationFailure authenticationFailure = ^(NSError *error){
    DDLogError(@"AKLinkedInAuth: Failure authenticating, %@",
               [error localizedDescription]);
  };
  NSDictionary *authorizationCodeRedirectParameters =
      @{@"response_type": @"code",
        @"client_id" : @"hrsfw0wa1l0x",
        @"scope" : @"r_basicprofile",
        @"state" : @"DCEEFWF45453sdffef",
        @"redirect_uri" : @"http://www.apple.com"};
  
  [linkedInOAuth2Client authenticateUsingOAuthWithPath:@"/uas/oauth2/authorization"
                                            parameters:authorizationCodeRedirectParameters
                                               success:authenticationSuccess
                                               failure:authenticationFailure];
   */
}

- (void)closeSession {
  
}

- (BOOL)sessionIsOpen {
  
}

@end

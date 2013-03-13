#import "AKLinkedInAuth.h"

#import <AFOAuth2Client/AFOAuth2Client.h>
#import <CocoaLumberjack/DDLog.h>

#import "AKAppDelegate.h"
#import "AKAuthenticationHandler.h"
#import "AKWebViewController.h"
#import "AKOAuth2AuthorizationCodeConsumer.h"

typedef void (^AFOAuth2AuthenticationSuccess)(AFOAuthCredential *credential);
typedef void (^AFOAuth2AuthenticationFailure)(NSError *error);

static const int ddLogLevel = LOG_LEVEL_VERBOSE;

@interface AKLinkedInAuth ()<AKOAuth2AuthorizationCodeConsumer>
@property(nonatomic, strong) AKWebViewController *webViewController;
@end

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
  
  self.webViewController =
      [[AKWebViewController alloc] initWithWebViewURL:authorizationCodeRequestURL
                         andAuthorizationCodeConsumer:self];
  self.webViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
  AKAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
  [appDelegate.window.rootViewController presentViewController:self.webViewController
                                                      animated:YES
                                                    completion:nil];
  
  
  
  
   
}

- (void)closeSession {
  
}

- (BOOL)sessionIsOpen {
  
}

#pragma mark AKOAuth2AuthorizationCodeConsumer 

- (void)retriever:(id)retriever didRetrieveAuthorizationCode:(NSString *)authorizationCode {
  DDLogVerbose(@"AKLinkedInAuth: GOT AUTH CODE");
  
  NSURL *linkedInAuthServerBaseURL =
      [NSURL URLWithString:@"https://www.linkedin.com/"];
  AFOAuth2Client *linkedInOAuth2Client =
      [AFOAuth2Client clientWithBaseURL:linkedInAuthServerBaseURL
                               clientID:@"5se92tdnfz61"
                                 secret:@"GneNrlqv99QIZTTq"];
  AKLinkedInAuth __weak *weakSelf = self;
  AFOAuth2AuthenticationSuccess authenticationSuccess = ^(AFOAuthCredential *credential){
    DDLogVerbose(@"AKLinkedInAuth: Logged In to LinkedIn, %@", credential);
    [weakSelf.authenticationHandler userDidLogin:weakSelf];
  };
  AFOAuth2AuthenticationFailure authenticationFailure = ^(NSError *error){
    DDLogError(@"AKLinkedInAuth: Failure authenticating, %@",
               [error localizedDescription]);
  };
//  NSDictionary *authorizationCodeRedirectParameters =
//      @{@"response_type": @"code",
//        @"client_id" : @"hrsfw0wa1l0x",
//        @"scope" : @"r_basicprofile",
//        @"state" : @"DCEEFWF45453sdffef",
//        @"redirect_uri" : @"http://www.apple.com"};
  
//  [linkedInOAuth2Client authenticateUsingOAuthWithPath:@"/uas/oauth2/authorization"
//                                            parameters:authorizationCodeRedirectParameters
//                                               success:authenticationSuccess
//                                               failure:authenticationFailure];
  
  [linkedInOAuth2Client authenticateUsingOAuthWithPath:@"/uas/oauth2/accessToken"
                                                  code:authorizationCode
                                           redirectURI:@"http://www.theiosengineer.com"
                                               success:authenticationSuccess
                                               failure:authenticationFailure];
  
  
  [self.webViewController dismissViewControllerAnimated:YES completion:nil];
}

@end

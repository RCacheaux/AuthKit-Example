#import "AKLinkedInAuth.h"

#import <AFOAuth2Client/AFOAuth2Client.h>
#import <CocoaLumberjack/DDLog.h>

#import "AKAppDelegate.h"
#import "AKAuthenticationHandler.h"
#import "AKOAuth2AuthorizationCodeWebViewController.h"
#import "AKOAuth2AuthorizationCodeConsumer.h"

#import "AKOAuth2AuthorizationCodeAuthorizationRequest.h"

typedef void (^AFOAuth2AuthenticationSuccess)(AFOAuthCredential *credential);
typedef void (^AFOAuth2AuthenticationFailure)(NSError *error);

static const int ddLogLevel = LOG_LEVEL_VERBOSE;

@interface AKLinkedInAuth ()<AKOAuth2AuthorizationCodeConsumer>
@property(nonatomic, strong)
    AKOAuth2AuthorizationCodeWebViewController *authorizationCodeWebViewController;
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
  NSURL *baseURL = [NSURL URLWithString:@"https://www.linkedin.com/"];
  
  AKOAuth2AuthorizationCodeAuthorizationRequest *authorizationCodeRequest =
      [[AKOAuth2AuthorizationCodeAuthorizationRequest alloc]
       initWithAuthorizationEndpointBaseURL:baseURL
                      authorizationCodePath:@"/uas/oauth2/authorization"
                                   ClientID:@"5se92tdnfz61"
                                redirectURI:@"http://www.theiosengineer.com"
                                      scope:@"r_basicprofile"];
  
  self.authorizationCodeWebViewController =
      [[AKOAuth2AuthorizationCodeWebViewController alloc]
       initWithAuthorizationCodeRequest:authorizationCodeRequest
           andAuthorizationCodeConsumer:self];
  self.authorizationCodeWebViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
  AKAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
  [appDelegate.window.rootViewController presentViewController:self.authorizationCodeWebViewController
                                                      animated:YES
                                                    completion:nil];   
}

- (void)closeSession {
  
}

- (BOOL)sessionIsOpen {
  
}

#pragma mark AKOAuth2AuthorizationCodeConsumer 

- (void)retriever:(id)retriever
    didRetrieveAuthorizationCode:(NSString *)authorizationCode {
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
  
  [linkedInOAuth2Client authenticateUsingOAuthWithPath:@"/uas/oauth2/accessToken"
                                                  code:authorizationCode
                                           redirectURI:@"http://www.theiosengineer.com"
                                               success:authenticationSuccess
                                               failure:authenticationFailure];
  
  
  [self.authorizationCodeWebViewController dismissViewControllerAnimated:YES
                                                              completion:nil];
}

@end

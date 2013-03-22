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

static NSString * const kAKLinkedInURL = @"https://www.linkedin.com/";

static NSString * const kAKLinkedInAuthorizationCodePath = @"/uas/oauth2/authorization";
static NSString * const kAKLinkedInAccessTokenPath = @"/uas/oauth2/accessToken";

static NSString * const kAKLinkedInClientID = @"5se92tdnfz61";
static NSString * const kAKLinkedInClientSecret = @"GneNrlqv99QIZTTq";

static NSString * const
    kAKLinkedInAuthorizationCodeRedirectURI = @"http://www.theiosengineer.com";

static const int ddLogLevel = LOG_LEVEL_ERROR;

@interface AKLinkedInAuth ()<AKOAuth2AuthorizationCodeConsumer>
@property(nonatomic, strong)
    AKOAuth2AuthorizationCodeWebViewController *authorizationCodeWebViewController;
@property(nonatomic, strong, readonly) NSURL *linkedInAuthServerBaseURL;
@property(nonatomic, strong) AFOAuthCredential *OAuthCredential;
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
  AKOAuth2AuthorizationCodeAuthorizationRequest *authorizationCodeRequest =
      [[AKOAuth2AuthorizationCodeAuthorizationRequest alloc]
       initWithAuthorizationEndpointBaseURL:self.linkedInAuthServerBaseURL
                      authorizationCodePath:kAKLinkedInAuthorizationCodePath
                                   ClientID:kAKLinkedInClientID
                                redirectURI:kAKLinkedInAuthorizationCodeRedirectURI
                                      scope:@"r_basicprofile"];
  
  self.authorizationCodeWebViewController =
      [[AKOAuth2AuthorizationCodeWebViewController alloc]
       initWithAuthorizationCodeRequest:authorizationCodeRequest
           andAuthorizationCodeConsumer:self];
  self.authorizationCodeWebViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
  AKAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
  [appDelegate.window.rootViewController
      presentViewController:self.authorizationCodeWebViewController
                   animated:YES
                 completion:nil];   
}

- (void)closeSession {
  self.OAuthCredential = nil;
  [self.authenticationHandler userDidLogout:self];
}

- (BOOL)sessionIsOpen {
  if (self.OAuthCredential) {
    return YES;
  }
  return NO;
}

#pragma mark AKOAuth2AuthorizationCodeConsumer 

- (void)retriever:(id)retriever
    didRetrieveAuthorizationCode:(NSString *)authorizationCode {
  DDLogVerbose(@"AKLinkedInAuth: GOT AUTH CODE");
  AFOAuth2Client *linkedInOAuth2Client =
      [AFOAuth2Client clientWithBaseURL:self.linkedInAuthServerBaseURL
                               clientID:kAKLinkedInClientID
                                 secret:kAKLinkedInClientSecret];
  AKLinkedInAuth __weak *weakSelf = self;
  AFOAuth2AuthenticationSuccess authenticationSuccess = ^(AFOAuthCredential *credential){
    DDLogVerbose(@"AKLinkedInAuth: Logged In to LinkedIn, %@", credential);
    weakSelf.OAuthCredential = credential;
    [weakSelf.authenticationHandler userDidLogin:weakSelf];
    [weakSelf.authorizationCodeWebViewController dismissViewControllerAnimated:YES
                                                                    completion:nil];
    
  };
  AFOAuth2AuthenticationFailure authenticationFailure = ^(NSError *error){
    DDLogError(@"AKLinkedInAuth: Failure authenticating, %@",
               [error localizedDescription]);
  };
  [linkedInOAuth2Client
      authenticateUsingOAuthWithPath:kAKLinkedInAccessTokenPath
                                code:authorizationCode
                         redirectURI:kAKLinkedInAuthorizationCodeRedirectURI
                             success:authenticationSuccess
                             failure:authenticationFailure];
  
}

- (NSURL *)linkedInAuthServerBaseURL {
  return [NSURL URLWithString:kAKLinkedInURL];
}

@end

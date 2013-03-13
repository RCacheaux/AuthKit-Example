#import "AKFacebookAuth.h"

#import <CocoaLumberjack/DDLog.h>
#import <FacebookSDK/FacebookSDK.h>

#import "AKAuthenticationHandler.h"

static const int ddLogLevel = LOG_LEVEL_ERROR;

@interface AKFacebookAuth ()

@end

@implementation AKFacebookAuth

+ (AKFacebookAuth *)sharedFacebookAuth {
  static AKFacebookAuth *_sharedFacebookAuth = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedFacebookAuth = [[self alloc] init];
  });
  return _sharedFacebookAuth;
}

- (id)initWithAuthenticationHandler:(id<AKAuthenticationHandler>)authenticationHandler {
  self = [super init];
  if (self) {
    self.authenticationHandler = authenticationHandler;
  }
  return self;
}

- (void)openSession {
  AKFacebookAuth __weak *weakSelf = self;
  FBSessionStateHandler completionHandler = ^(FBSession *session,
                                              FBSessionState state,
                                              NSError *error) {
    [weakSelf sessionStateChanged:session state:state error:error];
  };
  [FBSession openActiveSessionWithReadPermissions:nil
                                     allowLoginUI:YES
                                completionHandler:completionHandler];
}

- (void)closeSession {
  [FBSession.activeSession closeAndClearTokenInformation];
}

- (BOOL)sessionIsOpen {
  return FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded;
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState)state
                      error:(NSError *)error {
  DDLogVerbose(@"AKLoginViewController: Facebook session, %@, state change, %d.",
               session,
               state);
  switch (state) {
    case FBSessionStateOpen:
      DDLogVerbose(@"AKLoginViewController: Facebook session state open hide login.");
      [self.authenticationHandler userDidLogin:self];
      break;
      
    case FBSessionStateClosed:
    case FBSessionStateClosedLoginFailed:
      [FBSession.activeSession closeAndClearTokenInformation];
      [self.authenticationHandler userDidLogout:self];
      break;
      
    default:
      break;
  }
  
  if (error) {
    DDLogError(@"AKLoginViewController: Error logging into Facebook: %@",
               [error localizedDescription]);
  }
}


@end

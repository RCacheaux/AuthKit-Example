#import "AKGoogleAuth.h"

#import <CocoaLumberjack/DDLog.h>
#import <GTMOAuth2ViewControllerTouch.h>

#import "AKAppDelegate.h"
#import "AKAuthenticationHandler.h"

typedef  void (^GTMOAuth2CompletionHandler)(GTMOAuth2ViewControllerTouch *viewController, GTMOAuth2Authentication *auth, NSError *error);

static NSString * const kGoogleKeychainItemName = @"AuthKit Example: Google";

static NSString * const kGoogleClientID =
    @"581129179651-vdisshpchki6tnmhhte6k6lh7jj74icj.apps.googleusercontent.com";
static NSString * const kGoogleClientSecret = @"MaOWg_eoxSbkx3S5Zt7EM5RA";

static NSString * const kGoogleScope = @"https://www.googleapis.com/auth/plus.me";

static const int ddLogLevel = LOG_LEVEL_VERBOSE;

@interface AKGoogleAuth ()
@property(nonatomic, strong) GTMOAuth2Authentication *authentication;
@end

@implementation AKGoogleAuth

+ (AKGoogleAuth *)sharedGoogleAuth {
  static AKGoogleAuth *_sharedGoogleAuth = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedGoogleAuth = [[self alloc] init];
  });
  return _sharedGoogleAuth;
}

- (id)initWithAuthenticationHandler:(id<AKAuthenticationHandler>)authenticationHandler {
  self = [super init];
  if (self) {
    self.authenticationHandler = authenticationHandler;
  }
  return self;
}

- (void)openSession {
  AKGoogleAuth __weak *weakSelf = self;
  GTMOAuth2CompletionHandler completionHandler =
      ^(GTMOAuth2ViewControllerTouch *viewController,
        GTMOAuth2Authentication *auth,
        NSError *error)
  {
    if (!error) {
      [weakSelf.authenticationHandler userDidLogin:weakSelf];
      [viewController dismissViewControllerAnimated:YES completion:nil];
    } else {
      DDLogError(@"AKGoogleAuth: Error authenticating with Google, %@",
                 [error localizedDescription]);
    }
    
        
  };
  GTMOAuth2ViewControllerTouch *googleOAuth2WebViewController =
      [[GTMOAuth2ViewControllerTouch alloc] initWithScope:kGoogleScope
                                                 clientID:kGoogleClientID
                                             clientSecret:kGoogleClientSecret
                                         keychainItemName:kGoogleKeychainItemName
                                        completionHandler:completionHandler];
  googleOAuth2WebViewController.modalTransitionStyle =
      UIModalTransitionStyleFlipHorizontal;
  AKAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
  [appDelegate.window.rootViewController
      presentViewController:googleOAuth2WebViewController
                   animated:YES
                 completion:nil];
  
}

- (void)closeSession {
  [GTMOAuth2ViewControllerTouch removeAuthFromKeychainForName:kGoogleKeychainItemName];
  [GTMOAuth2ViewControllerTouch revokeTokenForGoogleAuthentication:self.authentication];
  self.authentication = nil;
  [self.authenticationHandler userDidLogout:self];
}

- (BOOL)sessionIsOpen {
  if (self.authentication) {
    return YES;
  }
  return NO;
}


@end

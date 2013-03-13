#import "AKAppDelegate.h"

#import <CocoaLumberjack/DDLog.h>
#import <CocoaLumberjack/DDASLLogger.h>
#import <CocoaLumberjack/DDTTYLogger.h>
// TODO:Should the app delegate depend directly on FacebookSDK?
#import <FacebookSDK/FacebookSDK.h>

#import "AKApplicationViewController.h"

static const int ddLogLevel = LOG_LEVEL_VERBOSE;

@implementation AKAppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [self loadLoggingSystem];
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  // Override point for customization after application launch.
  self.viewController =
      [[AKApplicationViewController alloc] initWithNibName:nil bundle:nil];
  self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
    sourceApplication:(NSString *)sourceApplication
           annotation:(id)annotation {
//  return [FBSession.activeSession handleOpenURL:url];
  DDLogVerbose(@"AKAppDelegate: Open URL, %@, source application, %@, annotation, %@",
               url, sourceApplication, annotation);
  return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  [FBSession.activeSession handleDidBecomeActive];
}

- (void)loadLoggingSystem {
  [DDLog addLogger:[DDASLLogger sharedInstance]];
  [DDLog addLogger:[DDTTYLogger sharedInstance]];
}

@end

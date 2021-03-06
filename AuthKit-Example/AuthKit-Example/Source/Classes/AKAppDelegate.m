#import "AKAppDelegate.h"

#import <CocoaLumberjack/DDLog.h>
#import <CocoaLumberjack/DDASLLogger.h>
#import <CocoaLumberjack/DDTTYLogger.h>
// TODO:Should the app delegate depend directly on FacebookSDK?
#import <FacebookSDK/FacebookSDK.h>

#import "AKApplicationViewController.h"
#import "AKAccountsViewController.h"

static const int ddLogLevel = LOG_LEVEL_ERROR;

@implementation AKAppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [self loadLoggingSystem];
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.viewController = [[AKAccountsViewController alloc] init];
  self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
    sourceApplication:(NSString *)sourceApplication
           annotation:(id)annotation {
  DDLogVerbose(@"AKAppDelegate: Open URL, %@, source application, %@, annotation, %@",
               url, sourceApplication, annotation);
  return [FBSession.activeSession handleOpenURL:url];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  [FBSession.activeSession handleDidBecomeActive];
}

- (void)loadLoggingSystem {
  [DDLog addLogger:[DDASLLogger sharedInstance]];
  [DDLog addLogger:[DDTTYLogger sharedInstance]];
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Saves changes in the application's managed object context before the
  // application terminates.
  
  // TODO(rcacheaux): Save all contexts.
}

@end

#import "AKAuthenticatedViewController.h"

#import <CocoaLumberjack/DDLog.h>
#import <FacebookSDK/FacebookSDK.h>

#import "AKFacebookAuth.h"
#import "AKLinkedInAuth.h"

static const int ddLogLevel = LOG_LEVEL_VERBOSE;

@interface AKAuthenticatedViewController ()

@end

@implementation AKAuthenticatedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
      // Custom initialization
  }
  return self;
}

- (void)loadView {
  self.view = [[UIView alloc] init];
  self.view.backgroundColor = [UIColor greenColor];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self loadScreenIdentifier];
	[self loadLogoutButton];
  [self loadFacebookCallButton];
}

- (void)loadScreenIdentifier {
  UILabel *screenIdentifier =
      [[UILabel alloc] initWithFrame:CGRectMake(90.0f, 100.0f, 200.0f, 30.0f)];
  screenIdentifier.text = @"AUTHENTICATED";
  screenIdentifier.backgroundColor = [UIColor clearColor];
  [self.view addSubview:screenIdentifier];
}

- (void)loadLogoutButton {
  UIButton *logoutButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [logoutButton addTarget:self
                   action:@selector(logout:)
         forControlEvents:UIControlEventTouchUpInside];
  [logoutButton setTitle:@"Logout" forState:UIControlStateNormal];
  logoutButton.frame = CGRectMake(60.0f, 400.0f, 200.0f, 50.0f);
  [self.view addSubview:logoutButton];
}

- (void)loadFacebookCallButton {
  UIButton *facebookCallButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [facebookCallButton addTarget:self
                         action:@selector(facebookCall:)
               forControlEvents:UIControlEventTouchUpInside];
  [facebookCallButton setTitle:@"Facebook Call" forState:UIControlStateNormal];
  facebookCallButton.frame = CGRectMake(60.0f, 100.0f, 200.0f, 50.0f);
  [self.view addSubview:facebookCallButton];
}

- (void)logout:(id)sender {
  [[AKFacebookAuth sharedFacebookAuth] closeSession];
}

- (void)facebookCall:(id)sender {
  FBRequestHandler requestHandler = ^(FBRequestConnection *connection,
                                      id result,
                                      NSError *error){
    if (!error) {
      DDLogVerbose(@"AKAuthenticatedViewController: Facebook Call Complete, %@.", result);
    } else {
      DDLogError(@"AKAuthenticatedViewController: Facebook Call Error, %@.", error);
    }
  };
  if (FBSession.activeSession.isOpen) {
    [[FBRequest requestForMe] startWithCompletionHandler:requestHandler];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end

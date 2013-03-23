#import "AKLoginViewController.h"

#import <CocoaLumberjack/DDLog.h>

#import "AKFacebookAuth.h"
#import "AKLinkedInAuth.h"
#import "AKGoogleAuth.h"

static const int ddLogLevel = LOG_LEVEL_ERROR;

@interface AKLoginViewController ()
@end

@implementation AKLoginViewController

- (void)loadView {
  self.view = [[UIView alloc] init];
  self.view.backgroundColor = [UIColor redColor];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self loadScreenIdentifier];
  [self loadLoginButton];
}

- (void)loadScreenIdentifier {
  UILabel *screenIdentifier =
      [[UILabel alloc] initWithFrame:CGRectMake(130.0f, 100.0f, 200.0f, 30.0f)];
  screenIdentifier.text = @"LOGIN";
  screenIdentifier.backgroundColor = [UIColor clearColor];
  [self.view addSubview:screenIdentifier];
}

- (void)loadLoginButton {
  UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [loginButton addTarget:self
                  action:@selector(login:)
        forControlEvents:UIControlEventTouchUpInside];
  [loginButton setTitle:@"Login" forState:UIControlStateNormal];
  loginButton.frame = CGRectMake(60.0f, 400.0f, 200.0f, 50.0f);
  [self.view addSubview:loginButton];
}

- (void)login:(id)sender {
  [[AKLinkedInAuth sharedLinkedInAuth] openSession];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end

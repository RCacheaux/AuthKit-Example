#import "AKAuthenticatedViewController.h"

#import "AKFacebookAuth.h"
#import "AKLinkedInAuth.h"

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

- (void)logout:(id)sender {
  [[AKLinkedInAuth sharedLinkedInAuth] closeSession];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end

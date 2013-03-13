#import "AKApplicationViewController.h"

#import "AKAuthenticatedViewController.h"
#import "AKFacebookAuth.h"
#import "AKLinkedInAuth.h"
#import "AKLoginViewController.h"

@interface AKApplicationViewController ()
@property(nonatomic, strong) AKAuthenticatedViewController *authenticatedViewController;
@property(nonatomic, strong) AKLoginViewController *loginViewController;
@end

@implementation AKApplicationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    [AKFacebookAuth sharedFacebookAuth].authenticationHandler = self;
    [AKLinkedInAuth sharedLinkedInAuth].authenticationHandler = self;
  }
  return self;
}

- (void)loadView {
  self.view = [[UIView alloc] init];
  self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self initializeChildViewControllers];
	[self loadScreenIdentifier];
  [self loadRootChildViewController];
}

- (void)initializeChildViewControllers {
  self.authenticatedViewController = [[AKAuthenticatedViewController alloc] init];
  self.loginViewController = [[AKLoginViewController alloc] init];
}

- (void)loadScreenIdentifier {
  UILabel *screenIdentifier =
      [[UILabel alloc] initWithFrame:CGRectMake(130.0f, 100.0f, 200.0f, 30.0f)];
  screenIdentifier.text = @"APPLICATION";
  screenIdentifier.backgroundColor = [UIColor clearColor];
  [self.view addSubview:screenIdentifier];
}

- (void)loadRootChildViewController {
  if ([[AKFacebookAuth sharedFacebookAuth] sessionIsOpen]) {
    [[AKFacebookAuth sharedFacebookAuth] openSession];
    [self loadAuthenticatedView];
  } else {
    [self loadLoginView];
  }
}

- (void)loadLoginView {
  [self addChildViewController:self.loginViewController];
  [self.view addSubview:self.loginViewController.view];
}

- (void)unloadLoginView {
  [self.loginViewController.view removeFromSuperview];
  [self.loginViewController removeFromParentViewController];
}

- (void)loadAuthenticatedView {
  [self addChildViewController:self.authenticatedViewController];
  [self.view addSubview:self.authenticatedViewController.view];
}

- (void)unloadAuthenticatedView {
  [self.authenticatedViewController.view removeFromSuperview];
  [self.authenticatedViewController removeFromParentViewController];
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  self.loginViewController.view.frame = self.view.bounds;
  self.authenticatedViewController.view.frame = self.view.bounds;
}

#pragma mark AKAuthenticationHander

- (void)userDidLogin:(id)sender {
  [UIView animateWithDuration:0.4 animations:^{
    [self unloadLoginView];
    [self loadAuthenticatedView];
  }];
}

- (void)userDidLogout:(id)sender {
  [UIView animateWithDuration:0.4 animations:^{
    [self unloadAuthenticatedView];
    [self loadLoginView];
  }];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end

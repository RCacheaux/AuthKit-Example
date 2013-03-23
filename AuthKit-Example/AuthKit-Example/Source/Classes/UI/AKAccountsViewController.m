#import "AKAccountsViewController.h"

#import "AKApplicationCoreDataStack.h"
#import "AKUserDataAccess.h"
#import "User.h"

@interface AKAccountsViewController ()
@property(nonatomic, strong) User *user;
@property(nonatomic, strong) NSPersistentStoreCoordinator *appDataStoreCoordinator;
@property(nonatomic, strong) UIButton *loginButton;
@property(nonatomic, strong) UIButton *logoutButton;
@end

@implementation AKAccountsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
  }
  return self;
}

- (void)loadView {
  self.view = [[UIView alloc] init];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [self.loginButton addTarget:self
                       action:@selector(simulateLogIn:)
             forControlEvents:UIControlEventTouchUpInside];
  [self.loginButton setTitle:@"Log In" forState:UIControlStateNormal];
  self.loginButton.frame = CGRectMake(100.0f, 40.0f, 100.0f, 50.0f);
  [self.view addSubview:self.loginButton];
  
  self.logoutButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [self.logoutButton addTarget:self
                        action:@selector(simulateLogOut:)
              forControlEvents:UIControlEventTouchUpInside];
  [self.logoutButton setTitle:@"Log Out" forState:UIControlStateNormal];
  self.logoutButton.frame = CGRectMake(100.0f, 100.0f, 100.0f, 50.0f);
  self.logoutButton.hidden = YES;
  [self.view addSubview:self.logoutButton];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)simulateLogIn:(id)send {
  if (!self.user) {
    self.user = [[[AKUserDataAccess alloc] init] createUser];
  }
  
  if (!self.user.persistentStoreURL) {
    AKApplicationCoreDataStack *coreDataStack = [[AKApplicationCoreDataStack alloc] init];
    self.appDataStoreCoordinator = [coreDataStack newPersistentStoreCoordinator];
    NSArray *persistentStores = [self.appDataStoreCoordinator persistentStores];
    NSPersistentStore *store = persistentStores[0];
    self.user.persistentStoreURL = [[store URL] absoluteString];
  } else {
    
    
    
  }
  
  
  
  self.loginButton.hidden = YES;
  self.logoutButton.hidden = NO;
}

- (void)simulateLogOut:(id)send {
  self.appDataStoreCoordinator = nil;
  
  self.loginButton.hidden = NO;
  self.logoutButton.hidden = YES;
}

@end

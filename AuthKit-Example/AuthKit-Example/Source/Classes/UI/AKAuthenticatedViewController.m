#import "AKAuthenticatedViewController.h"

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
	UILabel *screenIdentifier =
      [[UILabel alloc] initWithFrame:CGRectMake(100.0f, 100.0f, 200.0f, 30.0f)];
  screenIdentifier.text = @"AUTHENTICATED";
  screenIdentifier.backgroundColor = [UIColor clearColor];
  [self.view addSubview:screenIdentifier];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end

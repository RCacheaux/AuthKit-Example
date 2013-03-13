#import "AKLoginViewController.h"

@interface AKLoginViewController ()

@end

@implementation AKLoginViewController

- (void)loadView {
  self.view = [[UIView alloc] init];
  self.view.backgroundColor = [UIColor redColor];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  UILabel *screenIdentifier =
      [[UILabel alloc] initWithFrame:CGRectMake(100.0f, 100.0f, 200.0f, 30.0f)];
  screenIdentifier.text = @"LOGIN";
  screenIdentifier.backgroundColor = [UIColor clearColor];
  [self.view addSubview:screenIdentifier];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end

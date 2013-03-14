#import "AKOAuth2AuthorizationCodeWebViewController.h"

#import <CocoaLumberjack/DDLog.h>

#import "AKOAuth2AuthorizationCodeConsumer.h"
#import "AKOAuth2AuthorizationCodeAuthorizationRequest.h"

static const int ddLogLevel = LOG_LEVEL_INFO;

@interface AKOAuth2AuthorizationCodeWebViewController ()<UIWebViewDelegate>
@property(nonatomic, weak)
    id<AKOAuth2AuthorizationCodeConsumer> authorizationCodeConsumer;
@property(nonatomic, strong)
    AKOAuth2AuthorizationCodeAuthorizationRequest *authorizationCodeRequest;
@property(nonatomic, strong, readonly) UIWebView *webView;
@end

@implementation AKOAuth2AuthorizationCodeWebViewController

- (id)initWithAuthorizationCodeRequest:
    (AKOAuth2AuthorizationCodeAuthorizationRequest *)authorizationCodeRequest
          andAuthorizationCodeConsumer:(id<AKOAuth2AuthorizationCodeConsumer>)consumer {
  self = [super init];
  if (self) {
    self.authorizationCodeConsumer = consumer;
    self.authorizationCodeRequest = authorizationCodeRequest;
  }
  return self;
}

- (void)loadView {
  self.view = [[UIWebView alloc] init];
}

- (void)viewDidLoad {
  [super viewDidLoad];
	self.webView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.webView loadRequest:[self.authorizationCodeRequest authorizationRequest]];
}

- (UIWebView *)webView {
  return (UIWebView *)self.view;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView
    shouldStartLoadWithRequest:(NSURLRequest *)request
                navigationType:(UIWebViewNavigationType)navigationType {
  DDLogVerbose(@"AKWebViewController: Should start loading request, %@, "
               @"navigationType, %d", request, navigationType);
  DDLogVerbose(@"AKWebViewController: Host, %@", [request.URL host]);
  NSString *requestURLHost = [request.URL host];
  NSString *redirectURLHost = [[self.authorizationCodeRequest redirectURL] host];

  if ([requestURLHost isEqualToString:redirectURLHost]) {
    NSString *authorizationCode = [self authorizationCodeFromURL:request.URL];
    [self.authorizationCodeConsumer retriever:self
                 didRetrieveAuthorizationCode:authorizationCode];
    return NO;
  }
  return YES;
}

- (NSString *)authorizationCodeFromURL:(NSURL *)URL {
  DDLogVerbose(@"AKWebViewController: Redirect URL: %@", URL);
  DDLogVerbose(@"AKWebViewController: Parameter String, %@",
               [URL query]);
  NSArray *queryParameters = [[URL query] componentsSeparatedByString:@"&"];
  // TODO: Do not assume first element is the authorization code.
  NSArray *authorizationCodeParameter =
  [queryParameters[0] componentsSeparatedByString:@"="];
  DDLogInfo(@"AKWebViewController: Authorization Code, %@",
            authorizationCodeParameter[1]);
  return authorizationCodeParameter[1];
}

@end

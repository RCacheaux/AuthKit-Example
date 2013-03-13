#import <UIKit/UIKit.h>

@protocol AKOAuth2AuthorizationCodeConsumer;

@interface AKWebViewController : UIViewController
- (id)initWithWebViewURL:(NSURL *)webViewURL
    andAuthorizationCodeConsumer:(id<AKOAuth2AuthorizationCodeConsumer>)consumer;
@end

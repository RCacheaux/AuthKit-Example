#import <UIKit/UIKit.h>

@class AKOAuth2AuthorizationCodeAuthorizationRequest;

@protocol AKOAuth2AuthorizationCodeConsumer;

@interface AKOAuth2AuthorizationCodeWebViewController : UIViewController
- (id)initWithAuthorizationCodeRequest:
    (AKOAuth2AuthorizationCodeAuthorizationRequest *)authorizationCodeRequest
          andAuthorizationCodeConsumer:(id<AKOAuth2AuthorizationCodeConsumer>)consumer;
@end

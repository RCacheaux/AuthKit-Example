#import <Foundation/Foundation.h>

@protocol AKAuthenticationHandler
- (void)userDidLogin:(id)sender;
- (void)userDidLogout:(id)sender;
@end

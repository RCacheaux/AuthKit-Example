#import <Foundation/Foundation.h>

@protocol AKAuthenticationHandler
- (void)applicationDidLogin:(id)sender;
- (void)applicationDidLogout:(id)sender;
@end

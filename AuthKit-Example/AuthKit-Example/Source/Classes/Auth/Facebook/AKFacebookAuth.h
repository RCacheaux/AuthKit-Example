#import <Foundation/Foundation.h>

@protocol AKAuthenticationHandler;

@interface AKFacebookAuth : NSObject
@property(nonatomic, weak) id<AKAuthenticationHandler> authenticationHandler;
+ (AKFacebookAuth *)sharedFacebookAuth;
- (void)openSession;
- (void)closeSession;
- (BOOL)sessionIsOpen;
@end

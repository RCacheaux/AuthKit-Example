#import <Foundation/Foundation.h>

@protocol AKAuthenticationHandler;

@interface AKGoogleAuth : NSObject
@property(nonatomic, weak) id<AKAuthenticationHandler> authenticationHandler;
+ (AKGoogleAuth *)sharedGoogleAuth;
- (void)openSession;
- (void)closeSession;
- (BOOL)sessionIsOpen;
@end

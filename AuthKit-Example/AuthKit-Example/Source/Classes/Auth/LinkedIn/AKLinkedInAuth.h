#import <Foundation/Foundation.h>

@protocol AKAuthenticationHandler;

@interface AKLinkedInAuth : NSObject
@property(nonatomic, weak) id<AKAuthenticationHandler> authenticationHandler;
+ (AKLinkedInAuth *)sharedLinkedInAuth;
- (void)openSession;
- (void)closeSession;
- (BOOL)sessionIsOpen;
@end

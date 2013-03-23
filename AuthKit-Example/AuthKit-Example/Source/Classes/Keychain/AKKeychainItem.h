#import <Foundation/Foundation.h>

@interface AKKeychainItem : NSObject

@property(nonatomic, assign) CFTypeRef accessible;
@property(nonatomic, copy) NSString *accessGroup;
@property(nonatomic, strong) NSData *secret;

@end

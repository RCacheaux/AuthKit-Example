#import "AKPasswordKeychainItem.h"

@interface AKInternetPasswordKeychainItem : AKPasswordKeychainItem

@property(nonatomic, copy) NSString *securityDomain;
@property(nonatomic, copy) NSString *server;
@property(nonatomic, assign) CFTypeRef protocol;
@property(nonatomic, assign) CFTypeRef authenticationType;
@property(nonatomic, strong) NSNumber *port;
@property(nonatomic, copy) NSString *path;

@end

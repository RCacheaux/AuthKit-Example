#import "AKPasswordKeychainItem.h"

@interface AKGenericPasswordKeychainItem : AKPasswordKeychainItem

@property(nonatomic, copy) NSString *service;
@property(nonatomic, strong) NSData *generic;

@end

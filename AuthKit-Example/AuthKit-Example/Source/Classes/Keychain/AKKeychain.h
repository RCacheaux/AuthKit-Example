#import <UIKit/UIKit.h>

#import "AKKeychainItem.h"

@interface AKKeychain : NSObject

// TODO(rcacheaux): Return error objects.
+ (AKKeychainItem *)createKeychainItem:(AKKeychainItem *)keychainItem;
+ (void)deleteKeychainItem:(AKKeychainItem *)keychainItem;
// TODO(rcacheaux): Implement update method.

@end
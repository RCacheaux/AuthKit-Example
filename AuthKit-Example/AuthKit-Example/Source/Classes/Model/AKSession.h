#import <Foundation/Foundation.h>

@class AKAccount;

@interface AKSession : NSObject

@property(nonatomic, weak) AKAccount *account;

@end

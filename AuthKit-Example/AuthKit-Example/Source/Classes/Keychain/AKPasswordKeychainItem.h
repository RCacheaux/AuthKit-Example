#import "AKKeychainItem.h"

@interface AKPasswordKeychainItem : AKKeychainItem

@property(nonatomic, strong, readonly) NSDate *creationDate;
@property(nonatomic, strong, readonly) NSDate *modificationDate;
@property(nonatomic, copy) NSString *description;
@property(nonatomic, copy) NSString *comment;
@property(nonatomic, assign) NSUInteger creator;
@property(nonatomic, assign) NSUInteger type;
@property(nonatomic, copy) NSString *label;
@property(nonatomic, assign) BOOL invisible;
@property(nonatomic, assign) BOOL negative;
@property(nonatomic, strong) NSString *account;

@end

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Account;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * persistentStoreURL;
@property (nonatomic, retain) NSSet *accounts;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addAccountsObject:(Account *)value;
- (void)removeAccountsObject:(Account *)value;
- (void)addAccounts:(NSSet *)values;
- (void)removeAccounts:(NSSet *)values;

@end

#import <Foundation/Foundation.h>

@interface AKApplicationCoreDataStack : NSObject


- (NSPersistentStoreCoordinator *)newPersistentStoreCoordinator;
- (NSPersistentStoreCoordinator *)
    persistentStoreCoordinatorForStoreAtURL:(NSURL *)persistentStoreURL;

@end

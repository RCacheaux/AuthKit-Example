#import "AKApplicationCoreDataStack.h"

#import <CoreData/CoreData.h>
#import <CocoaLumberjack/DDLog.h>

static NSString * const kModelName = @"ApplicationModel";

static const int ddLogLevel = LOG_LEVEL_VERBOSE;

@implementation AKApplicationCoreDataStack


- (NSPersistentStoreCoordinator *)newPersistentStoreCoordinator {
  NSURL *storeURL = [self newURLForNewStore];
  
  NSError *error = nil;
  NSPersistentStoreCoordinator *persistentStoreCoordinator =
      [[NSPersistentStoreCoordinator alloc]
       initWithManagedObjectModel:[self managedObjectModel]];
  
  if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                configuration:nil
                                                          URL:storeURL
                                                      options:nil
                                                        error:&error]) {
    /*
     Replace this implementation with code to handle the error appropriately.
     
     abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
     
     Typical reasons for an error here include:
     * The persistent store is not accessible;
     * The schema for the persistent store is incompatible with current managed object model.
     Check the error message to determine what the actual problem was.
     
     
     If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
     
     If you encounter schema incompatibility errors during development, you can reduce their frequency by:
     * Simply deleting the existing store:
     [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
     
     * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
     @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
     
     Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
     
     */
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
  }
  DDLogVerbose(@"AKApplicationCoreDataStack: New Coordinator, %@",
               persistentStoreCoordinator);
  return persistentStoreCoordinator;
}

- (NSURL *)newURLForNewStore {
  NSString *UUIDString = [[NSUUID UUID] UUIDString];
  NSString *storeFileName =
      [NSString stringWithFormat:@"AppDataStore-%@.sqlite", UUIDString];
  DDLogVerbose(@"AKApplicationCoreDataStack: New Store URL, %@", storeFileName);
  return [[self applicationDocumentsDirectory] URLByAppendingPathComponent:storeFileName];
}

- (NSManagedObjectModel *)managedObjectModel {
  NSURL *modelURL = [[NSBundle mainBundle] URLForResource:kModelName
                                            withExtension:@"momd"];
  NSManagedObjectModel *managedObjectModel =
      [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
  return managedObjectModel;
}

- (NSURL *)applicationDocumentsDirectory {
  return [[[NSFileManager defaultManager]
          URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSPersistentStoreCoordinator *)
    persistentStoreCoordinatorForStoreAtURL:(NSURL *)persistentStoreURL {
  return nil; // TODO(rcacheaux): Implement.
}

@end

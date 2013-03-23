#import "AKUserDataAccess.h"

#import <CoreData/CoreData.h>

#import "AKAccountsCoreDataStack.h"
#import "User.h"
#import "Account.h"

@interface AKUserDataAccess ()
@property(nonatomic, strong) AKAccountsCoreDataStack *coreDataStack;
@end

@implementation AKUserDataAccess

- (id)init {
  self = [super init];
  if (self) {
    _coreDataStack = [[AKAccountsCoreDataStack alloc] init];
  }
  return self;
}

- (User *)createUser {
  User *newUser =
      [NSEntityDescription
       insertNewObjectForEntityForName:@"User"
                inManagedObjectContext:self.coreDataStack.managedObjectContext];
  return newUser;
}

- (Account *)createAccountForUser:(User *)user {
  Account *newAccount =
      [NSEntityDescription
       insertNewObjectForEntityForName:@"Account"
                inManagedObjectContext:self.coreDataStack.managedObjectContext];
  [user addAccountsObject:newAccount];
  return newAccount;
}

@end

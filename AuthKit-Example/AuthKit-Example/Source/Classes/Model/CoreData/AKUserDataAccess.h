#import <Foundation/Foundation.h>

@class User;
@class Account;

@interface AKUserDataAccess : NSObject

// Have a master account ID that is authenticated

// 1. Handle Authenticated Master Account

// - Get User with Master Account ID (may be new or existing)
//    - Look for master accounts with the account ID that is authenticated

// - Load Application Core Data Stack for User
//    - Does the user have a persistent store file URL?
//    - Create new store if needed otherwise load existing store



- (User *)createUser;
- (Account *)createAccountForUser:(User *)user;

@end

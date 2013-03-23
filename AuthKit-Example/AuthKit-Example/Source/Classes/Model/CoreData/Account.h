//
//  Account.h
//  AuthKit-Example
//
//  Created by Rene Cacheaux on 3/23/13.
//  Copyright (c) 2013 RCach Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Account : NSManagedObject

@property (nonatomic, retain) NSString * service;
@property (nonatomic, retain) NSString * session;
@property (nonatomic, retain) NSManagedObject *user;

@end

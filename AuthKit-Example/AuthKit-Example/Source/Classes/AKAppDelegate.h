//
//  AKAppDelegate.h
//  AuthKit-Example
//
//  Created by Rene Cacheaux on 3/12/13.
//  Copyright (c) 2013 RCach Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AKLoginViewController;

@interface AKAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) AKLoginViewController *viewController;

@end

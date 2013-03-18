#import <Foundation/Foundation.h>

@class AKService;
@class AKSession;

// TODO: Where to store authenticated scopes?
@interface AKAccount : NSObject

@property(nonatomic, strong) AKService *service;
@property(nonatomic, strong) AKSession *activeSession;

@end

#import "AKData.h"

#import "AKAccount.h"
#import "AKEngine.h"
#import "AKProtocol.h"
#import "AKService.h"
#import "AKUser.h"

@implementation AKData

- (id)init {
  self = [super init];
  if (self) {
    [self loadData];
  }
  return self;
}

- (void)loadData {
  AKProtocol *oauth2 = [[AKProtocol alloc] init];
  AKProtocol *oauth1 = [[AKProtocol alloc] init];
  AKProtocol *HTTPBasic = [[AKProtocol alloc] init];
  
  AKService *facebook = [[AKService alloc] init];
  AKService *linkedIn = [[AKService alloc] init];
  AKService *google = [[AKService alloc] init];
  
  
  
  
  
  
  
  
  
  
}

@end

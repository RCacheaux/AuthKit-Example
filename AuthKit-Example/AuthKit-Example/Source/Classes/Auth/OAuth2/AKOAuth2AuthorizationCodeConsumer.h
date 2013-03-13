#import <Foundation/Foundation.h>

@protocol AKOAuth2AuthorizationCodeConsumer

- (void)retriever:(id)retriever didRetrieveAuthorizationCode:(NSString *)authorizationCode;

@end

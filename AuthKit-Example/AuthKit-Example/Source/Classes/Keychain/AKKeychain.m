#import "AKKeychain.h"

#import <Security/Security.h>

//Unique string used to identify the keychain item:
static NSString * const kKeychainItemID = @"com.rcach.authkit";

@interface AKKeychain ()
@property (nonatomic, strong) NSMutableDictionary *keychainData;
@property (nonatomic, strong) NSMutableDictionary *genericPasswordQuery;
@end

@implementation AKKeychain

//Synthesize the getter and setter:
@synthesize keychainData, genericPasswordQuery;

- (id)init {
  if ((self = [super init])) {
    
    OSStatus keychainErr = noErr;
    // Set up the keychain search dictionary:
    genericPasswordQuery = [self keychainSearchDictionary];
    
    //Initialize the dictionary used to hold return data from the keychain:
    NSMutableDictionary *outDictionary = nil;
    
    // If the keychain item exists, return the attributes of the item:
    // TODO(rcacheaux): Make sure using correct ARC bridging options.
    CFDictionaryRef result;
    keychainErr = SecItemCopyMatching((__bridge CFDictionaryRef)genericPasswordQuery,
                                      (CFTypeRef *)&result);
//    NSDictionary *resultData = (__bridge_transfer NSDictionary *)result;
    if (keychainErr == noErr) {
      // Convert the data dictionary 
      self.keychainData = [self secItemFormatToDictionary:outDictionary];
    } else if (keychainErr == errSecItemNotFound) {
      // Put default values into the keychain if no matching
      // keychain item is found:
      [self resetKeychainItem];
    } else {
      // Any other error is unexpected.
      NSAssert(NO, @"Serious error.\n");
    }
  }
  return self;
}

- (NSMutableDictionary *)keychainSearchDictionary {
  // This keychain item is a generic password.
  
  // The kSecAttrGeneric attribute is used to store a unique string that is used
  // to easily identify and find this keychain item. The string is first
  // converted to an NSData object:

  // Return the attributes of the first match only:
  
  // Return the attributes of the keychain item (the password is
  //  acquired in the secItemFormatToDictionary: method):
  
  // TODO(rcacheaux): Make sure using correct ARC bridging options.
  NSDictionary *keychainSearchDictionary =
      @{ (__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
         (__bridge id)kSecAttrGeneric : [kKeychainItemID dataUsingEncoding:NSUTF8StringEncoding],
         (__bridge id)kSecMatchLimit : (__bridge id)kSecMatchLimitOne,
         (__bridge id)kSecReturnAttributes : (id)kCFBooleanTrue }; // TODO(rcacheaux): This
  // determines the return type of data, so this must be tightly coupled with keychain
  // operations.
  
  return [keychainSearchDictionary mutableCopy];
}

// Implement the mySetObject:forKey method, which writes attributes to the keychain:
- (void)mySetObject:(id)inObject forKey:(id)key
{
  if (inObject == nil) return;
  id currentObject = [keychainData objectForKey:key];
  if (![currentObject isEqual:inObject]) {
    [keychainData setObject:inObject forKey:key];
    [self writeToKeychain];
  }
}

// Implement the myObjectForKey: method, which reads an attribute value from a dictionary:
- (id)myObjectForKey:(id)key
{
  return [keychainData objectForKey:key];
}

// Reset the values in the keychain item, or create a new item if it
// doesn't already exist:

- (void)resetKeychainItem
{
  if (!keychainData) {
    //Allocate the keychainData dictionary if it doesn't exist yet.
    self.keychainData = [NSMutableDictionary dictionary];
  } else if (keychainData) {
    // Format the data in the keychainData dictionary into the format needed for a query
    //  and put it into tmpDictionary:
    NSMutableDictionary *tmpDictionary = [self dictionaryToSecItemFormat:keychainData];
    // Delete the keychain item in preparation for resetting the values:
    // TODO(rcacheaux): Make sure using correct ARC bridging options.
    CFDictionaryRef tmpDictionaryRef = (__bridge CFDictionaryRef)tmpDictionary;
    NSAssert(SecItemDelete(tmpDictionaryRef) == noErr, @"Problem deleting current keychain item." );
  }
  
  // Default generic data for Keychain Item:
  // TODO(rcacheaux): Make sure using correct ARC bridging options.
  [keychainData setObject:@"Item label" forKey:(__bridge id)kSecAttrLabel];
  [keychainData setObject:@"Item description" forKey:(__bridge id)kSecAttrDescription];
  [keychainData setObject:@"Account" forKey:(__bridge id)kSecAttrAccount];
  [keychainData setObject:@"Service" forKey:(__bridge id)kSecAttrService];
  [keychainData setObject:@"Your comment here." forKey:(__bridge id)kSecAttrComment];
  [keychainData setObject:@"password" forKey:(__bridge id)kSecValueData];
}

// Implement the dictionaryToSecItemFormat: method, which takes the attributes that
//   you want to add to the keychain item and sets up a dictionary in the format
//  needed by Keychain Services:
- (NSMutableDictionary *)dictionaryToSecItemFormat:(NSDictionary *)dictionaryToConvert {
  // This method must be called with a properly populated dictionary
  // containing all the right key/value pairs for a keychain item search.
  
  // Create the return dictionary:
  NSMutableDictionary *returnDictionary =
  [NSMutableDictionary dictionaryWithDictionary:dictionaryToConvert];
  
  // Add the keychain item class and the generic attribute:
  NSData *keychainItemID = [kKeychainItemID dataUsingEncoding:NSUTF8StringEncoding];
  
  // TODO(rcacheaux): Make sure using correct ARC bridging options.
  [returnDictionary setObject:keychainItemID forKey:(__bridge id)kSecAttrGeneric];
  [returnDictionary setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
  
  // Convert the password NSString to NSData to fit the API paradigm:
  // TODO(rcacheaux): Make sure using correct ARC bridging options.
  NSString *passwordString = [dictionaryToConvert objectForKey:(__bridge id)kSecValueData];
  [returnDictionary setObject:[passwordString dataUsingEncoding:NSUTF8StringEncoding]
                       forKey:(__bridge id)kSecValueData];
  return returnDictionary;
}

// Implement the secItemFormatToDictionary: method, which takes the attribute dictionary
//  obtained from the keychain item, acquires the password from the keychain, and
//  adds it to the attribute dictionary:
- (NSMutableDictionary *)secItemFormatToDictionary:(NSDictionary *)dictionaryToConvert {
  // This method must be called with a properly populated dictionary
  // containing all the right key/value pairs for the keychain item.
  
  // Create a return dictionary populated with the attributes:
  NSMutableDictionary *returnDictionary = [NSMutableDictionary
                                           dictionaryWithDictionary:dictionaryToConvert];
  
  // To acquire the password data from the keychain item,
  // first add the search key and class attribute required to obtain the password:
  // TODO(rcacheaux): Make sure using correct ARC bridging options.
  [returnDictionary setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
  [returnDictionary setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
  // Then call Keychain Services to get the password:
  // TODO(rcacheaux): Make sure using correct ARC bridging options.
  CFDataRef passwordDataRef;
  OSStatus keychainError = noErr; //
  keychainError = SecItemCopyMatching((__bridge CFDictionaryRef)returnDictionary,
                                      (CFTypeRef *)&passwordDataRef);
  NSData *passwordData = (__bridge_transfer NSData *)passwordDataRef;
  
  if (keychainError == noErr) {
    // Remove the kSecReturnData key; we don't need it anymore:
    // TODO(rcacheaux): Make sure using correct ARC bridging options.
    [returnDictionary removeObjectForKey:(__bridge id)kSecReturnData];
    
    // Convert the password to an NSString and add it to the return dictionary:
    // TODO(rcacheaux): Make sure using correct ARC bridging options.
    NSString *password =
        [[NSString alloc] initWithBytes:[passwordData bytes]
                                 length:[passwordData length] encoding:NSUTF8StringEncoding];
    [returnDictionary setObject:password forKey:(__bridge id)kSecValueData];
  }
  // Don't do anything if nothing is found.
  else if (keychainError == errSecItemNotFound) {
    NSAssert(NO, @"Nothing was found in the keychain.\n");
  }
  // Any other error is unexpected.
  else
  {
    NSAssert(NO, @"Serious error.\n");
  }
  
  return returnDictionary;
}

// Implement the writeToKeychain method, which is called by the mySetObject routine,
//   which in turn is called by the UI when there is new data for the keychain. This
//   method modifies an existing keychain item, or--if the item does not already
//   exist--creates a new keychain item with the new attribute value plus
//  default values for the other attributes.
- (void)writeToKeychain {
  NSDictionary *attributes = nil;
  NSMutableDictionary *updateItem = nil;
  
  CFDictionaryRef resultDictionary;
  // TODO(rcacheaux): Make sure using correct ARC bridging options.
  OSStatus returnCode = SecItemCopyMatching((__bridge CFDictionaryRef)genericPasswordQuery,
                                            (CFTypeRef *)&resultDictionary);
  // If the keychain item already exists, modify it:
  if (returnCode == noErr) {
    // First, get the attributes returned from the keychain and add them to the
    // dictionary that controls the update:
    updateItem = [NSMutableDictionary dictionaryWithDictionary:attributes];
    
    // Second, get the class value from the generic password query dictionary and
    // add it to the updateItem dictionary:
    // TODO(rcacheaux): Make sure using correct ARC bridging options.
    [updateItem setObject:[genericPasswordQuery objectForKey:(__bridge id)kSecClass]
                   forKey:(__bridge id)kSecClass];
    
    // Finally, set up the dictionary that contains new values for the attributes:
    NSMutableDictionary *tempCheck = [self dictionaryToSecItemFormat:keychainData];
    //Remove the class--it's not a keychain attribute:
    // TODO(rcacheaux): Make sure using correct ARC bridging options.
    [tempCheck removeObjectForKey:(__bridge id)kSecClass];
    
    // You can update only a single keychain item at a time.
    // TODO(rcacheaux): Make sure using correct ARC bridging options.
    CFDictionaryRef updateItemRef = (__bridge CFDictionaryRef)updateItem;
    CFDictionaryRef tempCheckRef = (__bridge CFDictionaryRef)tempCheck;
    NSAssert(SecItemUpdate(updateItemRef, tempCheckRef) == noErr,
             @"Couldn't update the Keychain Item." );
  } else {
    // No previous item found; add the new item.
    // The new value was added to the keychainData dictionary in the mySetObject routine,
    //  and the other values were added to the keychainData dictionary previously.
    
    // No pointer to the newly-added items is needed, so pass NULL for the second parameter:
    // TODO(rcacheaux): Make sure using correct ARC bridging options.
    CFDictionaryRef newItemDictionaryRef =
        (__bridge CFDictionaryRef)[self dictionaryToSecItemFormat:keychainData];
    NSAssert(SecItemAdd(newItemDictionaryRef, NULL) == noErr, @"Couldn't add the Keychain Item." );
  }
}


@end
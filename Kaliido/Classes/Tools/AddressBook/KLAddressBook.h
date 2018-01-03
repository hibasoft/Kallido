//
//  KLAddressBook.h
//  Kaliido
//
//  Created by Daron07/03/2014.
//  Copyright (c) 2014 Kaliido. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^AddressBookResult)(NSArray *contacts, BOOL success, NSError *error);

@interface KLAddressBook : NSObject

+ (void)getAllContactsFromAddressBook:(AddressBookResult)block;
+ (void)getContactsWithEmailsWithCompletionBlock:(AddressBookResult)block;

@end

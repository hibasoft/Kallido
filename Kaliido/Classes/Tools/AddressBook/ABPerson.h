//
//  ABPerson.h
//  Kaliido
//
//  Created by Daron on 06.07.14.
//  Copyright (c) 2014 Kaliido. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

@interface ABPerson : NSObject

@property (strong, nonatomic, readonly) NSString *firstName;
@property (strong, nonatomic, readonly) NSString *lastName;
@property (strong, nonatomic, readonly) NSString *middleName;
@property (strong, nonatomic, readonly) NSString *nickName;
@property (strong, nonatomic, readonly) UIImage *image;
@property (strong, nonatomic, readonly) NSArray *emails;
@property (strong, nonatomic, readonly) NSString *organizationProperty;
@property (strong, nonatomic, readonly) NSString *fullName;

- (instancetype)initWithRecordID:(ABRecordID)recordID addressBookRef:(ABAddressBookRef)addressBookRef;

@end

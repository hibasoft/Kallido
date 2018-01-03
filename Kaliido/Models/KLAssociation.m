//
//  KLAssociation.m
//  Kaliido
//
//  Created by Admin on 7/2/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "KLAssociation.h"

@implementation KLAssociation

- (NSDictionary *) toDictionary {
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    
    [[super class] addItemToDictionary:dict key:@"Name" value:self.name default:@""];
    [[super class] addItemToDictionary:dict key:@"PhoneNumber" value:self.phoneNumber default:@""];
    [[super class] addItemToDictionary:dict key:@"MobileNumber" value:self.mobileNumber default:@""];
    [[super class] addItemToDictionary:dict key:@"AddressLine1" value:self.addressLine1 default:@""];
    [[super class] addItemToDictionary:dict key:@"AddressLine2" value:self.addressLine2 default:@""];
    [[super class] addItemToDictionary:dict key:@"Suburb" value:self.suburb default:@""];
    [[super class] addItemToDictionary:dict key:@"State" value:self.state default:@""];
    [[super class] addItemToDictionary:dict key:@"Country" value:self.country default:@""];
    [[super class] addItemToDictionary:dict key:@"PostCodeText" value:self.postCode default:@""];
    [[super class] addItemToDictionary:dict key:@"Latitude" value:[NSNumber numberWithFloat:self.latitude] default:@""];
    [[super class] addItemToDictionary:dict key:@"Longitude" value:[NSNumber numberWithFloat:self.longitude] default:@""];
    [[super class] addItemToDictionary:dict key:@"BusinessOpenTime" value:self.businessOpenTime default:@""];
    [[super class] addItemToDictionary:dict key:@"BusinessCloseTime" value:self.businessCloseTime default:@""];
    [[super class] addItemToDictionary:dict key:@"BusinessWorkingOpenMask" value:self.businessWorkingOpenMask default:@""];
    [[super class] addItemToDictionary:dict key:@"IsShowBusinessOpenTimes" value:[NSNumber numberWithBool:self.showBusinessOpenTimes] default:@""];
    [[super class] addItemToDictionary:dict key:@"WebAddress" value:self.webAddress default:@""];
    [[super class] addItemToDictionary:dict key:@"MainContactName" value:self.mainContactName default:@""];
    [[super class] addItemToDictionary:dict key:@"BusinessTypeId" value:[NSNumber numberWithUnsignedInteger:self.businessTypeId] default:@""];
    [[super class] addItemToDictionary:dict key:@"EmailAddress" value:self.emailAddress default:@""];
    [[super class] addItemToDictionary:dict key:@"ProfilePictureBlogStorageUrl" value:self.profilePictureBlogStorageUrl default:@""];
    [[super class] addItemToDictionary:dict key:@"BackgroundPictureBlobStorageUrl" value:self.backgroundPictureBlobStorageUrl default:@""];
    
    NSMutableArray *interestIDArray = [NSMutableArray array];
    for (KLInterest *interest in self.interests) {
        [interestIDArray addObject:[NSNumber numberWithUnsignedInteger:interest.ID]];
    }
    [[super class] addItemToDictionary:dict key:@"Interests" value:interestIDArray default:@[]];

    return dict;
}

@end

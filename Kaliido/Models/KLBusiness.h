//
//  KLBusiness.h
//  Kaliido
//
//  Created by Hiba on 07/07/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "KLBaseModel.h"

@interface KLBusiness : KLBaseModel

@property (nonatomic, assign) NSUInteger ID;
@property (nonatomic, strong) KLUser *owner;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *mobileNumber;
@property (nonatomic, strong) NSString *addressLine1;
@property (nonatomic, strong) NSString *addressLine2;
@property (nonatomic, strong) NSString *suburb;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *postCode;
@property (nonatomic, assign) CGFloat latitude;
@property (nonatomic, assign) CGFloat longitude;
@property (nonatomic, strong) NSString *businessOpenTime;
@property (nonatomic, strong) NSString *businessCloseTime;
@property (nonatomic, strong) NSString *businessWorkingOpenMask;
@property (nonatomic, assign) BOOL showBusinessOpenTimes;
@property (nonatomic, strong) NSString *webAddress;
@property (nonatomic, strong) NSString *mainContactName;
@property (nonatomic, assign) NSInteger businessTypeId;
@property (nonatomic, strong) NSString *emailAddress;
@property (nonatomic, strong) NSString *profilePictureBlogStorageUrl;
@property (nonatomic, strong) NSString *backgroundPictureBlobStorageUrl;
@property (nonatomic, strong) NSMutableArray *interests;
@property (nonatomic, strong) NSString *pageType;
@property (nonatomic, strong) NSMutableArray *members;
@property (nonatomic, strong) NSMutableArray *followers;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSString *ejabberdId;

- (NSDictionary *) toDictionary;

@end

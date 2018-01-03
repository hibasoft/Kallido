//
//  KLUser+CustomParameters.h
//  Kaliido
//
//  Created by Daron 29.09.14.
//  Copyright (c) 2014 Kaliido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KLUser :NSObject

@property (nonatomic) NSUInteger ID;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *oldPassword;
@property (nonatomic, strong) NSString *website;
@property (nonatomic, strong) NSMutableArray* tags;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *avatarURL;
@property (nonatomic, strong) NSString *photoUID;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, assign) BOOL imported;
@property (nonatomic, strong) NSString *headline;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) BOOL isAgeShowen;
@property (nonatomic, assign) BOOL isBirthDateShowen;
@property (nonatomic, strong) NSString *birthDate;
@property (nonatomic, assign) BOOL isZodiacShowen;
@property (nonatomic, strong) NSString *zodiac;
@property (nonatomic, strong) NSString *aboutMe;
@property (nonatomic, assign) BOOL isDelux;
@property (nonatomic, strong) NSMutableArray *lookingFors;
@property (nonatomic, strong) NSString *relationship;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) NSInteger quickbloxUserId;
@property (nonatomic, strong) NSMutableArray *interests;
@property (nonatomic, strong) NSMutableArray *relations;
@property (nonatomic, strong) NSString *customData;
-(void)setInterestsDic:(NSDictionary*)dic;
-(void)setLookingForsDic:(NSDictionary*)dic;
-(void)setRelationShipDic:(NSDictionary*)dic;
-(void) setUser:(NSDictionary*)dic;
-(NSDictionary*) getUserDic;


+ (KLUser*)currentUser;
+ (void)setCurrentUser:(KLUser*)user;
@end

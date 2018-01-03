//
//  KLSettingsManager.h
//  Kaliido
//
//  Created by Daron on 24.06.14.
//  Copyright (c) 2014 Kaliido. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, KLAccountType) {
    KLAccountTypeNone,
    KLAccountTypeEmail,
    KLAccountTypeFacebook
};

@interface KLSettingsManager : NSObject

@property (assign, nonatomic) KLAccountType accountType;

/**
 Licence Agreement accepted
 */
@property (assign, nonatomic) BOOL userAgreementAccepted;

/**
 * User login
 */
@property (strong, nonatomic, readonly) NSString *login;

/**
 * User password
 */
@property (strong, nonatomic, readonly) NSString *password;
@property (strong, nonatomic) NSString *deviceToken;
@property (strong, nonatomic) NSString *accessToken;
@property (strong, nonatomic) NSString *refreshToken;
@property (strong, nonatomic) NSDate *tokenExpires;
@property (assign, nonatomic) int ejabberdId;
@property (assign, nonatomic) int userId;


/**
 * User status
 */
@property (strong, nonatomic) NSString *userStatus;

/**
 * Push notifcation enable (Default YES)
 */
@property (assign, nonatomic) BOOL pushNotificationsEnabled;

/**
 * Remember user login and password
 */
@property (assign, nonatomic) BOOL rememberMe;

/**
 * Last activity date. Needed for updating chat dialogs when go back from tray.
 */
@property (strong, nonatomic) NSDate *lastActivityDate;

/**
 * 
 */
@property (strong, nonatomic) NSString *dialogWithIDisActive;



- (void)setLogin:(NSString *)login andPassword:(NSString *)password;
/**
 * Set Default settings
 */
- (void)clearSettings;
- (void)defaultSettings;

@end

//
//  KLSettingsManager.m
//  Kaliido
//
//  Created by Daron on 24.06.14.
//  Copyright (c) 2014 Kaliido. All rights reserved.
//

#import "KLSettingsManager.h"
#import <Security/Security.h>
#import "NSUserDefaultsHelper.h"
#import "SAMKeychain/SAMKeychain.h"
#import "KLApi.h"
//#import "KLUsersService.h"
NSString *const kKLSettingsPasswordKey = @"passwordKey";
NSString *const kKLSettingsLoginKey = @"loginKey";
NSString *const kKLSettingsRememberMeKey = @"rememberMeKey";
NSString *const kKLFirstFacebookLoginKey = @"first_facebook_login";
NSString *const kKLSettingsPushNotificationEnabled = @"pushNotificationEnabledKey";
NSString *const kKLSettingsUserStatusKey = @"userStatusKey";
NSString *const kKLAuthServiceKey = @"KLAuthServiceKey";
NSString *const kKLLicenceAcceptedKey = @"licence_accepted";
NSString *const kKLAccountTypeKey = @"accountType";
NSString *const kKLApplicationEnteredFromPushKey = @"app_entered_from_push";
NSString *const kKLLastActivityDateKey = @"last_activity_date";
NSString *const kKLDialogWithIDisActiveKey = @"dialog_is_active";
NSString *const kKLUserIdKey = @"user_idKey";
NSString *const kKLEjabberdKey = @"ejabberdIdKEY";

@implementation KLSettingsManager

@dynamic login;
@dynamic password;
@dynamic userStatus;
@dynamic pushNotificationsEnabled;
@dynamic rememberMe;
@dynamic userAgreementAccepted;
@dynamic accountType;


#pragma mark - accountType

- (void)setAccountType:(KLAccountType)accountType {
    defSetInt(kKLAccountTypeKey, accountType);
}

- (KLAccountType)accountType {
    
    NSUInteger accountType = defInt(kKLAccountTypeKey);
    return accountType;
}

#pragma mark - userAgreementAccepted

- (void)setUserAgreementAccepted:(BOOL)userAgreementAccepted {
    
    defSetBool(kKLLicenceAcceptedKey, userAgreementAccepted);
}

- (BOOL)userAgreementAccepted {
    BOOL accepted = defBool(kKLLicenceAcceptedKey);
    return accepted;
}

#pragma mark - Login

- (void)setLogin:(NSString *)login andPassword:(NSString *)password {

    [self setLogin:login];
    [self setPassword:password];
    
}

- (NSString *)login {
    
    NSString *login = defObject(kKLSettingsLoginKey);
    return login;
}


- (void)setPassword:(NSString *)password {
    
    defSetObject(kKLSettingsPasswordKey, password);
}

- (void)setLogin:(NSString *)login {
    
    defSetObject(kKLSettingsLoginKey, login);
}


- (int )userId {
    
    int login = defInt(kKLUserIdKey);
    return login;
}

- (void)setUserId:(int)login {
    
    defSetInt(kKLUserIdKey, login);
}




- (int )ejabberdId {
    
    int login = defInt(kKLEjabberdKey);
    return login;
}

- (void)setEjabberdUserId:(int)login {
    
    defSetInt(kKLEjabberdKey, login);
}



#pragma mark - Password

- (NSString *)password {
    
    NSString *password = defObject(kKLSettingsPasswordKey);
    return password;
    
}

#pragma mark - Push notifications enabled

- (BOOL)pushNotificationsEnabled {
    
    BOOL pushNotificationEnabled = defBool(kKLSettingsPushNotificationEnabled);
    return pushNotificationEnabled;
}

- (void)setPushNotificationsEnabled:(BOOL)pushNotificationsEnabled {
    
    defSetBool(kKLSettingsPushNotificationEnabled, pushNotificationsEnabled);
}

#pragma mark - remember login

- (BOOL)rememberMe {
    
    BOOL rememberMe = defBool(kKLSettingsRememberMeKey);
    return rememberMe;
}

- (void)setRememberMe:(BOOL)rememberMe {
    
    defSetBool(kKLSettingsRememberMeKey, rememberMe);
}

#pragma mark - User Status

- (NSString *)userStatus {
    
    NSString *userStatus = defObject(kKLSettingsUserStatusKey);
    return userStatus;
}

- (void)setUserStatus:(NSString *)userStatus {
    
    defSetObject(kKLSettingsUserStatusKey, userStatus);
}

#pragma mark - Last activity date

- (void)setLastActivityDate:(NSDate *)lastActivityDate
{
    defSetObject(kKLLastActivityDateKey, lastActivityDate);
}

- (NSDate *)lastActivityDate
{
    return defObject(kKLLastActivityDateKey);
}


#pragma mark - Default Settings
- (void)defaultSettings {
    self.pushNotificationsEnabled = YES;
}

- (void)clearSettings {
    [self defaultSettings];
    self.rememberMe = NO;
    [self setLogin:nil andPassword:nil];
    self.userAgreementAccepted = NO;
    self.accountType = KLAccountTypeNone;
    self.userStatus = nil;
    self.login = nil;
}

@end

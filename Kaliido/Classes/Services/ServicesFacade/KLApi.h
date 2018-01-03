//
//  KLServicesFacade.h
//  Kaliido
//
//  Created by Daron on 01.07.14.
//  Copyright (c) 2014 Kaliido. All rights reserved.
//

#import <Foundation/Foundation.h>



@class FacebookService;
@class Reachability;
@class RegisterClient;
@class KLSettingsManager;
typedef NS_ENUM(NSInteger, KLAccountType);

@interface KLApi : NSObject



@property (strong, nonatomic,readonly) KLSettingsManager *settingsManager;
@property (strong, nonatomic, readonly) Reachability *internetConnection;
@property (strong, nonatomic) NSDictionary* pushNotification;
@property (strong, nonatomic) NSData *deviceToken;
@property (strong, nonatomic) RegisterClient* registerClient;
@property (strong, nonatomic) NSString* ejabberdUserId;
@property (strong, nonatomic) KLUser* userAuthObject;
+ (instancetype)instance;

//- (BOOL)checkResult:(QBResult *)result;

- (void)startServices;
- (void)stopServices;
//
- (void)applicationDidBecomeActive:(void(^)(BOOL success))completion;
- (void)applicationWillResignActive;
- (void)openChatPageForPushNotification:(NSDictionary *)notification completion:(void(^)(BOOL completed))completionBlock;

- (BOOL)isInternetConnected;

- (void)fetchAllHistory:(void(^)(void))completion;

@end

@interface KLApi (Auth)
- (void)registerWithDeviceToken:(int)userId completion:(void(^)(BOOL success))completion;
- (void)SendNotificationASPNETBackend:(NSSet*)tags message:(NSString*)message;

- (void)autoLogin:(void(^)(BOOL success))completion;

- (void)createSessionWithBlock:(void(^)(BOOL success))completion;
- (void)setAutoLogin:(BOOL)autologin withAccountType:(KLAccountType)accountType;

- (void)signUpAndLoginWithUser:(KLUser *)user rememberMe:(BOOL)rememberMe completion:(void(^)(BOOL success))completion;
- (void)singUpAndLoginWithFacebook:(void(^)(BOOL success))completion;
/**
 User LogIn with email and password
 
 Type of Result - KLUserLogInResult
 @return completion stastus
 */

- (void)loginWithEmail:(NSString *)email password:(NSString *)password rememberMe:(BOOL)rememberMe completion:(void(^)(BOOL success))completion;

/**
 User LogIn with facebook
 
 Type of Result - KLUserLogInResult
 @return completion stastus
 */
- (void)loginWithFacebook:(void(^)(BOOL success))completion;
- (void)logout:(void(^)(BOOL success))completion;

/**
 Reset user password wiht email
 */
- (void)resetUserPassordWithEmail:(NSString *)email completion:(void(^)(BOOL success))completion;
- (void)subscribeToPushNotificationsForceSettings:(BOOL)force complete:(void(^)(BOOL success))complete;
- (void)unSubscribeToPushNotifications:(void(^)(BOOL success))complete;

@end




/**
 Facebook interface
 */
@interface KLApi (Facebook)

- (void)fbLogout;
- (void)fbIniviteDialogWithCompletion:(void(^)(BOOL success))completion;
- (NSURL *)fbUserImageURLWithUserID:(NSString *)userID;
- (void)fbFriends:(void(^)(NSArray *fbFriends))completion;
- (void)fbInviteUsersWithIDs:(NSArray *)ids copmpletion:(void(^)(NSError *error))completion;

@end


@interface KLApi (Permissions)

- (void)requestPermissionToCameraWithCompletion:(void(^)(BOOL authorized))completion;
- (void)requestPermissionToMicrophoneWithCompletion:(void(^)(BOOL granted))completion;

@end



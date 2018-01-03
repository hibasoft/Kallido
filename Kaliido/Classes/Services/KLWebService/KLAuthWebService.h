//
//  KLAuthWebService.h
//  Kaliido
//
//  Created by Robbie Tapping on 8/08/2015.
//  Copyright (c) 2015 Kaliido. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KLAccessTokenResponse.h"
#import "KLUserRegistration.h"
#import "RestKit.h"

@interface KLAuthWebService : NSObject

#define kBASEAUTHURL @"http://kaliido-test-auth-api.azurewebsites.net/"
//#define kBASERESOURCEURL @"https://kaliido-resource.azurewebsites.net/"
//#define kBASEPUSHURL @"http://kaliido-test-admin.azurewebsites.net"
#define kCLIENTID @"KaliidoIOSClient"
#define kCLIENTSECRET @""



@property (nonatomic, strong) KLAccessTokenResponse *sessionInformation;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *refreshToken;
@property (nonatomic, strong) NSDate *tokenExpiresAt;
@property (nonatomic, strong) RKObjectManager *objectManager;

typedef void (^KLAuthCompletionBlock)(BOOL success, KLAccessTokenResponse *response, NSError *error);
typedef void (^KLResetPasswordCompletionBlock)(BOOL success, NSDictionary *response, NSError *error);

- (void)configureRestKit;
- (KLAccessTokenResponse*)loginSession:(NSString *)email password:(NSString *)password;

- (void)loginSession:(NSString *)email password:(NSString *)password withCallback:(KLAuthCompletionBlock)callback;
- (void)getTokenFromRefreshToken:(KLAuthCompletionBlock)callback;

- (void)resetPassword:(NSString*)email withCallback:(KLResetPasswordCompletionBlock)callback;
- (void)registerUser:(KLUserRegistration *)model withCallback:(KLAuthCompletionBlock)callback;

- (void)registerFaceUser:(NSString*)sessionToken withCallback:(KLAuthCompletionBlock)callback;
- (void)loginFaceUser:(NSString*)sessionToken withCallback:(KLAuthCompletionBlock)callback;

+ (KLAuthWebService*)getInstance;
- (id)init;

@end

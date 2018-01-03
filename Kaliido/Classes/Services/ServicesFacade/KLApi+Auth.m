//
//  KLApi+Auth.m
//  Kaliido
//
//  Created by Daron on 03.07.14.
//  Copyright (c) 2014 Kaliido. All rights reserved.
//

#import "KLApi.h"
#import "FacebookService.h"
#import "KLSettingsManager.h"
//#import "KLUsersService.h"
//#import "KLMessagesService.h"
#import "REAlertView+KLSuccess.h"
//#import "KLTwitterService.h"
#import "KLAuthWebService.h"
#import "KLWebService.h"
#import "AppDelegate.h"

@implementation KLApi (Auth)

#pragma mark Public methods

- (void)logout:(void(^)(BOOL success))completion {
    
    [self unSubscribeToPushNotifications:^(BOOL success) {
        
        if(success)
        {
            
            completion(YES);
        }else{
            completion(NO);
            
        }
        KLUser.currentUser = nil;
        [self.settingsManager clearSettings];
        
        if ([FBSDKAccessToken currentAccessToken]) {
            FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
            [login logOut];
        }
        
        [self stopServices];
        
    }];
}

- (void)setAutoLogin:(BOOL)autologin withAccountType:(KLAccountType)accountType {
    
    self.settingsManager.rememberMe = autologin;
    self.settingsManager.accountType = accountType;
}

- (void)autoLogin:(void(^)(BOOL success))completion {
    
    [self startServices];
    
    if (!KLUser.currentUser) {
        
        if (self.settingsManager.accountType == KLAccountTypeEmail) {
            
            NSString *email = self.settingsManager.login;
            NSString *password = self.settingsManager.password;
            [self loginWithEmail:email password:password rememberMe:YES completion:completion];
        }
        else if (self.settingsManager.accountType == KLAccountTypeFacebook) {
            [self loginWithFacebook:completion];
        }else
        {
            NSString *email = self.settingsManager.login;
            NSString *password = self.settingsManager.password;
            [self loginWithEmail:email password:password rememberMe:YES completion:completion];
        }
    }
    else {
        
        completion(YES);
    }
}

- (void)singUpAndLoginWithFacebook:(void(^)(BOOL success))completion {
    
    __weak __typeof(self)weakSelf = self;
    
    
    
    [self loginWithFacebook:^(BOOL success) {
        
        if (!success) {
            completion(success);
        }
        else {
            
            [weakSelf setAutoLogin:YES withAccountType:KLAccountTypeFacebook];
            
            if (KLUser.currentUser.photoUID.length == 0) {
                /*Update user image from facebook */
//                [FacebookService loadMe:^(NSDictionary<FBGraphUser> *user) {
                
//                    NSURL *userImageUrl = [FacebookService userImageUrlWithUserID:user.id];
//                    
//                    //                    [weakSelf uploadProfilePhoto:userImageUrl progress:nil completion:completion];
//                    //                    [weakSelf updateUser:weakSelf.currentUser imageUrl:userImageUrl progress:nil completion:completion];
//                    
//                    
//                    [[KLApi instance] registerWithDeviceToken:self.ejabberdUserId  completion:^(BOOL success) {
//                        if(success)
//                        {
//                            completion(YES);
//                            
//                        }else{
//                            completion(NO);
//                        }
//                    }];
                    
                    
                    
//                }];
                completion(YES);
            }
            else {
                completion(YES);
            }
        }
    }];
}

- (void)singUpAndLoginWithTwitter:(void(^)(BOOL success))completion {
    
    __weak __typeof(self)weakSelf = self;
    /*create QBSession*/
    [self loginWithTwitter:^(BOOL success) {
        completion(success);
    }];
}
- (void)signUpAndLoginWithUser:(KLUser *)user rememberMe:(BOOL)rememberMe completion:(void(^)(BOOL success))completion {

    
}

- (void)resetUserPassordWithEmail:(NSString *)email completion:(void(^)(BOOL success))completion {
    

    
}

#pragma mark - Private methods

- (void)createSessionWithBlock:(void(^)(BOOL success))completion {

    
}

- (void)destroySessionWithCompletion:(void(^)(BOOL success))completion {

    
}





- (void)loginWithFacebook:(void(^)(BOOL success))completion {
    
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:@[@"public_profile", @"email" ] fromViewController:nil handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        
        if (error) {
            
            completion(NO);
        }
        
        if ([FBSDKAccessToken currentAccessToken] &&
            [[FBSDKAccessToken currentAccessToken].permissions containsObject:@"public_profile"]) {
            /*Longin with Social provider*/
            NSString* sessionToken = [FBSDKAccessToken currentAccessToken].tokenString;
            [[KLAuthWebService getInstance] registerFaceUser:sessionToken withCallback:^(BOOL success, KLAccessTokenResponse *response, NSError *error) {
                
                
                [[KLAuthWebService getInstance] loginFaceUser:sessionToken withCallback:^(BOOL succ, KLAccessTokenResponse *res, NSError *err) {
                    
                    
                    
                    AppDelegate* blah = (AppDelegate*)[[UIApplication sharedApplication]delegate];
                    
                    [blah setToken:res];
                    [blah setUserName:res.email];
                    
                    
                    if(res.quickbloxId > 0)
                    {
                        [blah setUserId:res.quickbloxId];
                    }else{
                        [blah setUserId:res.userId];
                        
                    }
                    
                    res.userId = res.quickbloxId;
                    [self.settingsManager setAccessToken:res.accessToken];
                    [self.settingsManager setRefreshToken:res.refreshToken];
                    [self.settingsManager setTokenExpires:res.expireDate];
                    [self.settingsManager setEjabberdId:res.quickbloxId];
                    [self.settingsManager setUserId:res.quickbloxId];
                    
                    self.ejabberdUserId = [NSString stringWithFormat:@"%lu", (unsigned long)res.userId];
                    
                    
                    [self.settingsManager setLogin:res.email andPassword:self.ejabberdUserId ];
                    
                    
                    
                    KLUser.currentUser = [[KLUser alloc] init];
                    KLUser.currentUser.email = res.email;
                    KLUser.currentUser.quickbloxUserId = res.quickbloxId;
                    
                    [[KLXMPPTool sharedInstance] loginWithJID:[XMPPJID jidWithUser:[NSString stringWithFormat:@"%lu", (unsigned long)res.quickbloxId] domain:@"klsocial.404la.be" resource:@"Kaliido-App-iOSv1.0"] andPassword:[NSString stringWithFormat:@"%lu",(unsigned long)res.userId] ];
                    
                    
                    
                    [self registerWithDeviceToken:blah.userId completion:^(BOOL success) {
                        if(success)
                        {
                            completion(succ);
                            
                        }else{
                            completion(succ);
                        }
                    }];
                    
                    
                }];
            }];
        }
    }];

    
}



- (void)loginWithTwitter:(void(^)(BOOL success))completion {

    
}


- (void)subscribeToPushNotificationsForceSettings:(BOOL)force complete:(void(^)(BOOL success))complete {
    
    
    if (self.settingsManager.pushNotificationsEnabled || force) {
        __weak __typeof(self)weakSelf = self;
    
        if(self.ejabberdUserId != nil && self.ejabberdUserId != 0)
        {
            [self registerWithDeviceToken:self.settingsManager.userId completion:^(BOOL success) {
                if(success)
                {
                    complete(success);
                    
                }else{
                    complete(success);
                }
            }];
        }
        
        
        
    }
    else{
        if( complete ){
            complete(NO);
        }
    }
}

- (void)unSubscribeToPushNotifications:(void(^)(BOOL success))complete {
    
    if (self.settingsManager.pushNotificationsEnabled) {
        //__weak __typeof(self)weakSelf = self;
        
        self.ejabberdUserId = [NSString stringWithFormat:@"%i", [self.settingsManager userId]];
        
        if(self.ejabberdUserId != nil)
        {
        NSSet *tagsSet = [NSSet setWithArray:@[@{@"Name": @0, @"Value" :self.ejabberdUserId}]];
        
        [self.registerClient unsubscribeFromPushNotifications:self.deviceToken userId:[self.settingsManager userId] andCompletion:^(NSURLResponse *response, NSError *error) {
            
            if(error == nil)
            {
                
                
                complete(YES);
            }else{
                complete(NO);
            }
            
            
            
        }];
        }else{
             complete(NO);
        }
        
        
    }
    
    complete(YES);
}

- (void)loginWithEmail:(NSString *)email password:(NSString *)password rememberMe:(BOOL)rememberMe completion:(void(^)(BOOL success))completion {
    
    __weak __typeof(self)weakSelf = self;
    
    [[KLAuthWebService getInstance] loginSession:email password:password withCallback:^(BOOL success, KLAccessTokenResponse *response, NSError *error) {
        if(success)
        {
            response.userId = response.quickbloxId;
            [self.settingsManager setAccessToken:response.accessToken];
            [self.settingsManager setRefreshToken:response.refreshToken];
            [self.settingsManager setTokenExpires:response.expireDate];
            [self.settingsManager setEjabberdId:response.quickbloxId];
            [self.settingsManager setUserId:response.quickbloxId];
            [self.settingsManager setLogin:email andPassword:password];
            self.ejabberdUserId = [NSString stringWithFormat:@"%lu", (unsigned long)response.quickbloxId];
            NSLog(@"%@",response);
            AppDelegate* blah = (AppDelegate*)[[UIApplication sharedApplication]delegate];
            
            [blah setToken:response];
            
            [blah setUserName:email];
            
            [blah setPassword:password];
            
            
            if(response.quickbloxId > 0)
            {
                [blah setUserId:response.quickbloxId];
            }else{
                [blah setUserId:response.userId];
                
            }
            
            if(KLUser.currentUser == nil)
            {
                KLUser.currentUser = [[KLUser alloc]init];
            }
            
            
            KLUser.currentUser.ID = response.quickbloxId;
            KLUser.currentUser.email = email;
            KLUser.currentUser.password = password;
            NSLog(@"%@",KLUser.currentUser);
            NSLog(@"%@",weakSelf.settingsManager);
            self.ejabberdUserId = [NSString stringWithFormat:@"%d", response.quickbloxId];
            
            
            [[KLXMPPTool sharedInstance] loginWithJID:[XMPPJID jidWithUser:[NSString stringWithFormat:@"%lu", (unsigned long)response.quickbloxId] domain:@"klsocial.404la.be" resource:@"Kaliido-App-iOSv1.0"] andPassword:password];
            
            completion(YES);
            
            [[KLApi instance] registerWithDeviceToken:blah.userId     completion:^(BOOL success) {
                if(success)
                {
                    completion(YES);
                    
                }else{
                    completion(NO);
                }
            }];
            
        }else{
            completion(NO);
        }
    }];
}




- (void)registerWithDeviceToken:(int)userId completion:(void(^)(BOOL success))completion
{
    [self setEjabberdUserId:[NSString stringWithFormat:@"%d",userId]];
    
    if (self.deviceToken == nil || userId == 0) {
        return;
    }
    
    NSString* headerValue = [NSString stringWithFormat:@"%@:%@", @"UserId", self.ejabberdUserId];
    
    NSData* encodedData = [[headerValue dataUsingEncoding:NSUTF8StringEncoding] base64EncodedDataWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
    
    self.registerClient = [[RegisterClient alloc] initWithEndpoint:kBASERESOURCEURL];
    
    self.registerClient.authenticationHeader = [[NSString alloc] initWithData:encodedData
                                                                     encoding:NSUTF8StringEncoding];
    
    NSSet *tags = [NSSet setWithArray:@[@{@"Name": @2, @"Value" :  self.ejabberdUserId}]];
    
    [self.registerClient registerWithDeviceToken:self.deviceToken tags:tags
                                   andCompletion:^(NSError* error) {
                                       if (!error) {
                                           dispatch_async(dispatch_get_main_queue(),
                                                          ^{
                                                              completion(true);
                                                              
                                                          });
                                       }else{
                                           completion(false);
                                       }
                                   }];
    //completion(true);
}


- (void)SendNotificationASPNETBackend:(NSSet*)tags message:(id)message
{
    
    NSDictionary* deviceRegistration = @{@"Platform" : @2, @"Message": message,
                                         @"Tags": [tags allObjects]};
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:deviceRegistration
                                                       options:NSJSONWritingPrettyPrinted error:nil];
    
    NSLog(@"JSON registration: %@", [[NSString alloc] initWithData:jsonData
                                                          encoding:NSUTF8StringEncoding]);
    
    
    
    NSURLSession* session = [NSURLSession
                             sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil
                             delegateQueue:nil];
    
    // Pass the pns and username tag as parameters with the REST URL to the ASP.NET backend
    NSURL* requestURL = [NSURL URLWithString:[NSString
                                              stringWithFormat:@"%@api/notification/test/sendNotificationToTags", kBASERESOURCEURL]];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:requestURL];
    [request setHTTPMethod:@"POST"];
    
    // Get the mock authenticationheader from the register client
    NSString* authorizationHeaderValue = [NSString stringWithFormat:@"bearer %@", [KLAuthWebService getInstance].accessToken];
    [request setValue:authorizationHeaderValue forHTTPHeaderField:@"Authorization"];
    
    //Add the notification message body
    [request setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:jsonData];
    
    // Execute the send notification REST API on the ASP.NET Backend
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*) response;
                                          if (error || httpResponse.statusCode == 500 || httpResponse.statusCode == 400)
                                          {
                                              NSString* status = [NSString stringWithFormat:@"Error Status for %ld\nError: %@\n",
                                                                  (long)httpResponse.statusCode, error];
                                              dispatch_async(dispatch_get_main_queue(),
                                                             ^{
                                                                 
                                                             });
                                              NSLog(status);
                                          }
                                          
                                          if (data != NULL)
                                          {
                                              NSLog(@"push sent");
                                          }
                                      }];
    [dataTask resume];
}

@end

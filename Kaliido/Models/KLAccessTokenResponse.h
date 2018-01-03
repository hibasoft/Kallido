//
//  KLAccessTokenResponse.h
//  Kaliido
//
//  Created by Robbie Tapping on 9/08/2015.
//  Copyright (c) 2015 Kaliido. All rights reserved.
//
/*

 e.g. of output object
 
 {"access_token":"ck_v_atG9FOrOtynxZ6VduNhMW2-0W5pZI7m0EzQK4S0Vmu1yCTcF8pyb9iOj9D1MVBbLn8slIgM1Yw5KTbF585Ak0X4h9HfTZ477RxV7x-bVA3gz6wYU-4nt_iKrkECiIJ8Ztgua55V_rkfkRDpKBc0Ebebb2EY9f2VnndBsetdGpZw4ZOPtzFK7zYt-3yBZpHzrTKaHcXB2Q2SB9f8gWnOpeppZvc6WniAGH__L9kZjpzP1rg6Bpttu1zPeQnSlZ03Um_Z21CZ9PSu8GKOHqgGD9YxyHdMwhYfF9gQExPd97zJduyqaggPQogt4kfnXsnTWd3RmjlKAIQxsfqZ0LLF0StpkMLPL5M91dQs48IW19IfvoMiHfx3YQodcybW3DU9HHDoP1AfueUKaAkCfUIb_H9eZ2JZ9EdDNuVc2J4cADOG"
 ,"token_type":"bearer"
 ,"expires_in":1799
 ,"refresh_token":"a051d1d8fbd74c2989c7871187781ff3"
 ,"as:client_id":"KaliidoIOSClient"
 ,"email":"robbie@kaliido.com"
 ,"quickblox_id":"4679325"
 ,".issued":"Sun, 09 Aug 2015 02:51:56 GMT"
 ,".expires":"Sun, 09 Aug 2015 03:21:56 GMT"}
 
 
 */
 
#import <Foundation/Foundation.h>

@interface KLAccessTokenResponse : NSObject


@property (nonatomic, strong) NSString *accessToken;

@property (nonatomic, strong) NSString *tokenType;

@property (nonatomic) int *expiresIn;

@property (nonatomic, strong) NSDate *issuedDate;
@property (nonatomic, strong) NSDate *expireDate;

@property (nonatomic, strong) NSString *refreshToken;

@property (nonatomic, strong) NSString *clientId;

@property (nonatomic, strong) NSString *email;

@property (nonatomic) int userId;

@property (nonatomic) int quickbloxId;


-(void) setPropertiesFromDictionary:(NSDictionary*)accessTokenDic;


@end

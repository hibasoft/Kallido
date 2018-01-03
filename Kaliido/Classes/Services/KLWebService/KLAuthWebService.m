//
//  KLAuthWebService.m
//  Kaliido
//
//  Created by Robbie Tapping on 8/08/2015.
//  Copyright (c) 2015 Kaliido. All rights reserved.
//

#import "KLAuthWebService.h"
#import "RestKit.h"
#import "KLUserRegistration.h"
#import "KLAccessTokenResponse.h"
#import "KLAccessTokenRequest.h"


@interface KLAuthWebService ()



@end

@implementation KLAuthWebService


static KLAuthWebService* instance;

+ (KLAuthWebService*)getInstance
{
    static dispatch_once_t dispatchOnceToken;
    
    dispatch_once(&dispatchOnceToken, ^{
        instance = [[KLAuthWebService alloc] init];
    });
    
    return instance;
}


- (id)init {
    
    if (self = [super init]) {
        [self configureRestKit];
    }
    return self;
}



- (void)configureRestKit
{
    

    
    
    if(_tokenExpiresAt != nil)
    {
        if ([_tokenExpiresAt timeIntervalSince1970] > 0) {
            
            if([[NSDate date] timeIntervalSinceDate:_tokenExpiresAt] > 0)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self getTokenFromRefreshToken:^(BOOL success, KLAccessTokenResponse *response, NSError *error) {
                        if(success)
                        {
                            NSLog(@"Refreshed Token");
                        }
                    }];
                        
                        
                    
                });
            }
        }
        
    }

    
    // initialize AFNetworking HTTPClient
    NSURL *baseURL = [NSURL URLWithString:kBASEAUTHURL];
    AFRKHTTPClient *client = [[AFRKHTTPClient alloc] initWithBaseURL:baseURL];
    [self setObjectManager:[[RKObjectManager alloc] initWithHTTPClient:client]];
    
}

- (KLAccessTokenResponse*)loginSession:(NSString *)email password:(NSString *)password
{
    [self configureRestKit];
    
    KLAccessTokenResponse *response = nil;
    
    NSDictionary *queryParams = @{@"grant_type" : @"password",
                                  @"client_id" : @"KaliidoIOSClient",
                                  @"username" : email,
                                  @"password" : password};

    // initialize RestKit
    
    
    RKObjectMapping *loginTokenRequestMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [loginTokenRequestMapping addAttributeMappingsFromDictionary:@{@"grant_type": @"grantype",
                                                                   @"client_id": @"clientid",
                                                                   @"username" : @"username",
                                                                   @"password": @"password"}];
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:loginTokenRequestMapping objectClass:[KLAccessTokenRequest class] rootKeyPath:nil method:RKRequestMethodPOST];
    
    RKObjectMapping *userTokenMapping = [RKObjectMapping mappingForClass:[KLAccessTokenResponse class]];
    [userTokenMapping addAttributeMappingsFromDictionary:@{@"access_token": @"accessToken",
                                                           @"token_type": @"tokenType",
                                                           @"refresh_token": @"refreshToken",
                                                           @"client_id":@"clientId",
                                                           @"email":@"email",
                                                           @"user_id":@"quickbloxId",
                                                           @"user_id":@"userId"}];
 
    RKResponseDescriptor *userTokenResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:userTokenMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:@"token"
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    
    
    
    [[self objectManager] addRequestDescriptor:requestDescriptor];
    [[self objectManager]  addResponseDescriptor:userTokenResponseDescriptor];
    
    [[self objectManager]  postObject:queryParams
                                           path:@"token"
                                           parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                             
                                                  KLAccessTokenResponse *dataResponse = mappingResult.firstObject;
                                                  _accessToken = dataResponse.accessToken;
                                                  _refreshToken = dataResponse.refreshToken;
                                                   NSLog(@"%@", mappingResult.array);
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"What do you mean by 'there is no coffee?': %@", error);
                                              }];
    
    return response;
    
}

// --------------
- (void)loginSession:(NSString *)email password:(NSString *)password withCallback:(KLAuthCompletionBlock)callback
{
    [self configureRestKit];
    
    NSDictionary *queryParams = @{@"grant_type" : @"password",
                                  @"client_id" : @"TestNativeKaliidoClient",
                                  @"username" : email,
                                  @"password" : password,
                                  @"client_secret":@"123@abc"};
    
    RKObjectMapping *loginTokenRequestMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [loginTokenRequestMapping addAttributeMappingsFromDictionary:@{@"grant_type": @"grantype",
                                                                   @"client_id": @"clientid",
                                                                   @"username" : @"username",
                                                                   @"password": @"password",
                                                                   @"client_secret":@"client_secret"}];
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:loginTokenRequestMapping objectClass:[KLAccessTokenRequest class] rootKeyPath:nil method:RKRequestMethodPOST];
    
    RKObjectMapping *userTokenMapping = [RKObjectMapping mappingForClass:[KLAccessTokenResponse class]];
    [userTokenMapping addAttributeMappingsFromDictionary:@{@"access_token": @"accessToken",
                                                           @"token_type": @"tokenType",
                                                           @"refresh_token": @"refreshToken",
                                                           @"client_id":@"clientId",
                                                           @"email":@"email",
                                                           //@"expires_in":@"expiresIn",
                                                           @".issued":@"issuedDate",
                                                           @".expires":@"expireDate",
                                                           @"user_id":@"quickbloxId",
                                                           @"user_id":@"userId"}];
    
    RKResponseDescriptor *userTokenResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:userTokenMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:@"token"
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [[self objectManager]  addRequestDescriptor:requestDescriptor];
    [[self objectManager]  addResponseDescriptor:userTokenResponseDescriptor];
    
    [[self objectManager]  postObject:queryParams
                                           path:@"token"
                                     parameters:queryParams
                                        success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                            
                                            KLAccessTokenResponse *dataResponse = mappingResult.firstObject;
                                            _accessToken = dataResponse.accessToken;
                                            _refreshToken = dataResponse.refreshToken;
                                            _tokenExpiresAt = dataResponse.expireDate;
                                            callback(YES, dataResponse, nil);
                                            
                                            NSLog(@"%@", mappingResult.array);
                                        }
                                        failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                            [self getTokenFromRefreshToken:^(BOOL success, KLAccessTokenResponse *response, NSError *error) {
                                                if(success)
                                                {
                                                    
                                                    _accessToken = response.accessToken;
                                                    _refreshToken = response.refreshToken;
                                                    _tokenExpiresAt = response.expireDate;
                                                    callback(YES, response, nil);
                                                    
                                                    NSLog(@"%@", response);
                                                    NSLog(@"Refreshed Token");
                                                }else{
                                                     callback(NO, nil, error);
                                                }
                                            }];
                                           

                                        }];
    
}

- (void)getTokenFromRefreshToken:(KLAuthCompletionBlock)callback
{
    [self configureRestKit];
    [[self.objectManager HTTPClient] setDefaultHeader:@"Authorization" value: [NSString stringWithFormat:@"bearer %@", [KLAuthWebService getInstance].accessToken]];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    
    if (_refreshToken == nil) {
       callback(NO, nil, nil);
        return;
    }
    NSDictionary *queryParams = @{@"grant_type" : @"refresh_token",
                                  @"client_id" : @"TestNativeKaliidoClient",
                                  @"refresh_token" : _refreshToken,
                                  @"client_secret":@"123@abc"};
    
    RKObjectMapping *loginTokenRequestMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [loginTokenRequestMapping addAttributeMappingsFromDictionary:@{@"grant_type": @"grantype",
                                                                   @"client_id": @"clientid",
                                                                   @"refresh_token" : @"refresh_token",
                                                                   @"client_secret":@"client_secret"}];
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:loginTokenRequestMapping objectClass:[KLAccessTokenRequest class] rootKeyPath:nil method:RKRequestMethodPOST];
    
    RKObjectMapping *userTokenMapping = [RKObjectMapping mappingForClass:[KLAccessTokenResponse class]];
    [userTokenMapping addAttributeMappingsFromDictionary:@{@"access_token": @"accessToken",
                                                           @"token_type": @"tokenType",
                                                           @"refresh_token": @"refreshToken",
                                                           @"client_id":@"clientId",
                                                           @"email":@"email",
                                                          // @"expires_in":@"expiresIn",
                                                           @".issued":@"issuedDate",
                                                           @".expires":@"expireDate",
                                                           @"user_id":@"quickbloxId",
                                                           @"user_id":@"userId"}];

    
    RKResponseDescriptor *userTokenResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:userTokenMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:@"token"
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    
    
    
    [[self objectManager]  addRequestDescriptor:requestDescriptor];
    [[self objectManager]  addResponseDescriptor:userTokenResponseDescriptor];
    
    [[self objectManager]  postObject:queryParams
                                 path:@"token"
                           parameters:queryParams
                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                  
                                  KLAccessTokenResponse *dataResponse = mappingResult.firstObject;
                                  _accessToken = dataResponse.accessToken;
                                  _refreshToken = dataResponse.refreshToken;
                                  _tokenExpiresAt = dataResponse.expireDate;
                                  callback(YES, dataResponse, nil);
                              }
                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                  callback(NO, nil, error);
                                  
                              }];
}

- (void)resetPassword:(NSString*)email withCallback:(KLResetPasswordCompletionBlock)callback
{
    [self configureRestKit];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    // register mappings with the provider using a response descriptor
    RKObjectMapping *userTokenMapping = [RKObjectMapping mappingForClass:[KLAccessTokenResponse class]];
    [userTokenMapping addAttributeMappingsFromDictionary:@{@"success": @"success"}];
    
    RKResponseDescriptor *userTokenResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:userTokenMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [[self objectManager]  addResponseDescriptor:userTokenResponseDescriptor];
    
    // Start doing some time consuming tasks like sending a request to the backend services
    
    // To see your callback in action uncomment the line below
    
    [self.objectManager  getObjectsAtPath:[NSString stringWithFormat:@"api/Account/GenerateResetPasswordToken/%@/", email]
                               parameters:nil
                                  success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                      callback(YES, mappingResult.firstObject, nil);
                                  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                      callback(NO, nil, error);
                                  }];
}

- (void)registerUser:(KLUserRegistration *)model withCallback:(KLAuthCompletionBlock)callback
{
    [self configureRestKit];
    
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromDictionary:[KLUserRegistration elementToPropertyMappings]];
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[KLUserRegistration class] rootKeyPath:nil method:RKRequestMethodPOST];
    [[self objectManager]  addRequestDescriptor:requestDescriptor];

    RKObjectMapping *userTokenMapping = [RKObjectMapping mappingForClass:[KLAccessTokenResponse class]];
    [userTokenMapping addAttributeMappingsFromDictionary:@{@"access_token": @"accessToken",
                                                           @"token_type": @"tokenType",
                                                           @"refresh_token": @"refreshToken",
                                                           @"client_id":@"clientId",
                                                           @"email":@"email",
                                                           //@"expires_in":@"expiresIn",
                                                           @".issued":@"issuedDate",
                                                           @".expires":@"expireDate",
                                                           @"user_id":@"quickbloxId",
                                                           @"user_id":@"userId"}];
    
    RKResponseDescriptor *userTokenResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:userTokenMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [[self objectManager]  addResponseDescriptor:userTokenResponseDescriptor];
    
    [[self objectManager] postObject:model
                                           path:@"/api/account/register"
                                     parameters:nil
                                        success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                            callback(YES, nil, nil);
                                            NSLog(@"%@", mappingResult.array);
                                        }
                                        failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                            callback(NO, nil, error);
                                        }];
    
}

- (void)registerFaceUser:(NSString*)sessionToken withCallback:(KLAuthCompletionBlock)callback
{
    [self configureRestKit];
    
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    
    RKObjectMapping *userTokenMapping = [RKObjectMapping mappingForClass:[KLAccessTokenResponse class]];
    [userTokenMapping addAttributeMappingsFromDictionary:@{@"access_token": @"accessToken",
                                                           @"token_type": @"tokenType",
                                                           @"refresh_token": @"refreshToken",
                                                           @"client_id":@"clientId",
                                                           @"email":@"email",
                                                          // @"expires_in":@"expiresIn",
                                                           @".issued":@"issuedDate",
                                                           @".expires":@"expireDate",
                                                           @"user_id":@"quickbloxId",
                                                           @"user_id":@"userId"}];
    
    RKResponseDescriptor *userTokenResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:userTokenMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:@"/api/account/registerexternal"
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [[self objectManager]  addResponseDescriptor:userTokenResponseDescriptor];
    
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromDictionary:@{@"externalAccessToken": @"externalAccessToken", @"Provider":@"Provider"}];
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[NSMutableDictionary class] rootKeyPath:nil method:RKRequestMethodPOST];
    [self.objectManager addRequestDescriptor:requestDescriptor];
    
    NSDictionary *queryParams = @{@"externalAccessToken" :sessionToken,
                                  @"Provider":@"facebook"};
    
    [[self objectManager] postObject:queryParams
                                path:@"/api/account/registerexternal"
                          parameters:queryParams
                             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                 KLAccessTokenResponse *dataResponse = mappingResult.firstObject;
                                 _accessToken = dataResponse.accessToken;
                                 _tokenExpiresAt = dataResponse.expireDate;
                                 callback(YES, dataResponse, nil);
                                 NSLog(@"%@", mappingResult.array);
                             }
                             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                 callback(NO, nil, error);
                             }];

}

- (void)loginFaceUser:(NSString*)sessionToken withCallback:(KLAuthCompletionBlock)callback
{
    [self configureRestKit];
    
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    
    RKObjectMapping *userTokenMapping = [RKObjectMapping mappingForClass:[KLAccessTokenResponse class]];
    [userTokenMapping addAttributeMappingsFromDictionary:@{@"access_token": @"accessToken",
                                                           @"token_type": @"tokenType",
                                                           @"refresh_token": @"refreshToken",
                                                           @"client_id":@"clientId",
                                                           @"email":@"email",
                                                          // @"expires_in":@"expiresIn",
                                                           @".issued":@"issuedDate",
                                                           @".expires":@"expireDate",
                                                           @"user_id":@"quickbloxId",
                                                           @"user_id":@"userId"}];
    RKResponseDescriptor *userTokenResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:userTokenMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [[self objectManager]  addResponseDescriptor:userTokenResponseDescriptor];
    
    [[self objectManager] getObjectsAtPath:[NSString stringWithFormat:@"/api/account/ObtainLocalAccessToken?provider=facebook&externalaccesstoken=%@",sessionToken] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        KLAccessTokenResponse *dataResponse = mappingResult.firstObject;
        _accessToken = dataResponse.accessToken;
        _refreshToken = dataResponse.refreshToken;
        _tokenExpiresAt = dataResponse.expireDate;
        callback(YES, dataResponse, nil);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        callback(NO, nil, error);
    }];
}
@end

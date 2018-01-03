//
//  KLAuthWebService.m
//  Kaliido
//
//  Created by Robbie Tapping on 8/08/2015.
//  Copyright (c) 2015 Kaliido. All rights reserved.
//

#import "KLWebService.h"
#import "RestKit.h"
#import "KLUserRegistration.h"
#import "KLAccessTokenResponse.h"
#import "KLAccessTokenRequest.h"
#import "KLAuthWebService.h"
#import "NotificationTag.h"

#import "KLApi.h"
#import "AppDelegate.h"

#define PLATFORM_APNS   @"2"

@interface KLWebService ()



@end

@implementation KLWebService

static KLWebService* instance;

+ (KLWebService*)getInstance
{
    static dispatch_once_t dispatchOnceToken;
    
    dispatch_once(&dispatchOnceToken, ^{
        instance = [[KLWebService alloc] init];
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
    NSURL *baseURL = [NSURL URLWithString:kBASERESOURCEURL];
    AFRKHTTPClient *client = [[AFRKHTTPClient alloc] initWithBaseURL:baseURL];
    
    // initialize RestKit
//    [RKObjectManager sharedManager].HTTPClient = client;
    self.objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    [[self.objectManager HTTPClient] setDefaultHeader:@"Authorization" value: [NSString stringWithFormat:@"bearer %@", [KLAuthWebService getInstance].accessToken]];
//    [[[RKObjectManager sharedManager] HTTPClient] setDefaultHeader:@"Authorization" value: [NSString stringWithFormat:@"bearer %@", [KLAuthWebService getInstance].accessToken]];
}

- (NSDictionary*) getDictionaryFromArray:(NSArray*) valueArray
{
    NSMutableDictionary *returnDic = [[NSMutableDictionary alloc] init];
    for (NSUInteger index=0UL; index < valueArray.count; index++)
    [returnDic setObject:[valueArray objectAtIndex:index] forKey:[NSString stringWithFormat:@"array[%ld]", index]];
    return returnDic;
}

- (void)sendRequest:(NSString*)url Method:(NSString*)method Data:(NSDictionary *)data withCallback:(KLCompletionBlock) callback
{
    if ([method isEqualToString:@"GET"])
    {
        [self.objectManager  getObjectsAtPath:url
                                   parameters:data
                                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                          callback(YES, mappingResult.firstObject, nil);
                                      }
                                      failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                          if (operation.HTTPRequestOperation.response.statusCode == 401)
                                          {
                                              [[KLAuthWebService getInstance] getTokenFromRefreshToken:^(BOOL success, KLAccessTokenResponse *response, NSError *error2) {
                                                  if (success)
                                                  {
                                                      [[self.objectManager HTTPClient] setDefaultHeader:@"Authorization" value: [NSString stringWithFormat:@"bearer %@", [KLAuthWebService getInstance].accessToken]];
                                                      [self sendRequest:url Method:method Data:data withCallback:callback];
                                                  }else
                                                  {
                                                      callback(NO, nil, error);
                                                      [SVProgressHUD  showWithMaskType:SVProgressHUDMaskTypeClear];
                                                      [[KLApi instance] logout:^(BOOL succ) {
                                                          [SVProgressHUD dismiss];
                                                          AppDelegate *delegate =  (AppDelegate *)[UIApplication sharedApplication].delegate;
                                                          [delegate logout];
                                                      }];
                                                  }
                                              }];
                                          }else
                                          {
                                              callback(NO, nil, error);
                                          }
                                      }];
    }else if ([method isEqualToString:@"POST"])
    {
        [self.objectManager postObject:data
                                  path:url
                            parameters:data
                               success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                   callback(YES, mappingResult.firstObject, nil);
                               }
                               failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                   if (operation.HTTPRequestOperation.response.statusCode == 401)
                                   {
                                       [[KLAuthWebService getInstance] getTokenFromRefreshToken:^(BOOL success, KLAccessTokenResponse *response, NSError *error2) {
                                           if (success)
                                           {
                                               [[self.objectManager HTTPClient] setDefaultHeader:@"Authorization" value: [NSString stringWithFormat:@"bearer %@", [KLAuthWebService getInstance].accessToken]];
                                               [self sendRequest:url Method:method Data:data withCallback:callback];
                                           }else
                                           {
                                               callback(NO, nil, error);
                                               [SVProgressHUD  showWithMaskType:SVProgressHUDMaskTypeClear];
                                               [[KLApi instance] logout:^(BOOL succ) {
                                                   [SVProgressHUD dismiss];
                                                   AppDelegate *delegate =  (AppDelegate *)[UIApplication sharedApplication].delegate;
                                                   [delegate logout];
                                               }];
                                           }
                                       }];
                                   }else
                                   {
                                       callback(NO, nil, error);
                                   }
                                   
                               }];
    }else if ([method isEqualToString:@"PUT"])
    {
        [self.objectManager putObject:data
                                 path:url
                           parameters:data
                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                  callback(YES, nil, nil);
                              }
                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                  if (operation.HTTPRequestOperation.response.statusCode == 401)
                                  {
                                      [[KLAuthWebService getInstance] getTokenFromRefreshToken:^(BOOL success, KLAccessTokenResponse *response, NSError *error2) {
                                          if (success)
                                          {
                                              [[self.objectManager HTTPClient] setDefaultHeader:@"Authorization" value: [NSString stringWithFormat:@"bearer %@", [KLAuthWebService getInstance].accessToken]];
                                              [self sendRequest:url Method:method Data:data withCallback:callback];
                                          }else
                                          {
                                              callback(NO, nil, error);
                                              [SVProgressHUD  showWithMaskType:SVProgressHUDMaskTypeClear];
                                              [[KLApi instance] logout:^(BOOL succ) {
                                                  [SVProgressHUD dismiss];
                                                  AppDelegate *delegate =  (AppDelegate *)[UIApplication sharedApplication].delegate;
                                                  [delegate logout];
                                              }];
                                          }
                                      }];
                                  }else
                                  {
                                      callback(NO, nil, error);
                                  }
                              }];
    }else if ([method isEqualToString:@"DELETE"])
    {
        [self.objectManager deleteObject:data
                                    path:url
                              parameters:data
                                 success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                     callback(YES, nil, nil);
                                 }
                                 failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                     if (operation.HTTPRequestOperation.response.statusCode == 401)
                                     {
                                         [[KLAuthWebService getInstance] getTokenFromRefreshToken:^(BOOL success, KLAccessTokenResponse *response, NSError *error2) {
                                             if (success)
                                             {
                                                 [[self.objectManager HTTPClient] setDefaultHeader:@"Authorization" value: [NSString stringWithFormat:@"bearer %@", [KLAuthWebService getInstance].accessToken]];
                                                 [self sendRequest:url Method:method Data:data withCallback:callback];
                                             }else
                                             {
                                                 callback(NO, nil, error);
                                                 [SVProgressHUD  showWithMaskType:SVProgressHUDMaskTypeClear];
                                                 [[KLApi instance] logout:^(BOOL succ) {
                                                     [SVProgressHUD dismiss];
                                                     AppDelegate *delegate =  (AppDelegate *)[UIApplication sharedApplication].delegate;
                                                     [delegate logout];
                                                 }];
                                             }
                                         }];
                                     }else
                                     {
                                         callback(NO, nil, error);
                                     }
                                     
                                 }];
    }
}

- (void)sendArrayRequest:(NSString*)url Method:(NSString*)method Data:(NSDictionary *)data withCallback:(KLCompletionArrayBlock) callback
{
    if ([method isEqualToString:@"GET"])
    {
        [self.objectManager  getObjectsAtPath:url
                                   parameters:data
                                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                          callback(YES, mappingResult.array, nil);
                                      }
                                      failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                          if (operation.HTTPRequestOperation.response.statusCode == 401)
                                          {
                                              [[KLAuthWebService getInstance] getTokenFromRefreshToken:^(BOOL success, KLAccessTokenResponse *response, NSError *error2) {
                                                  if (success)
                                                  {
                                                      [[self.objectManager HTTPClient] setDefaultHeader:@"Authorization" value: [NSString stringWithFormat:@"bearer %@", [KLAuthWebService getInstance].accessToken]];
                                                      [self sendArrayRequest:url Method:method Data:data withCallback:callback];
                                                  }else
                                                  {
                                                      callback(NO, nil, error);
                                                      [SVProgressHUD  showWithMaskType:SVProgressHUDMaskTypeClear];
                                                      [[KLApi instance] logout:^(BOOL succ) {
                                                          [SVProgressHUD dismiss];
                                                          AppDelegate *delegate =  (AppDelegate *)[UIApplication sharedApplication].delegate;
                                                          [delegate logout];
                                                      }];
                                                  }
                                              }];
                                          }else
                                          {
                                              callback(NO, nil, error);
                                          }
                                      }];
    }else if ([method isEqualToString:@"POST"])
    {
        [self.objectManager postObject:data
                                  path:url
                            parameters:data
                               success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                   callback(YES, mappingResult.array, nil);
                               }
                               failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                   if (operation.HTTPRequestOperation.response.statusCode == 401)
                                   {
                                       [[KLAuthWebService getInstance] getTokenFromRefreshToken:^(BOOL success, KLAccessTokenResponse *response, NSError *error2) {
                                           if (success)
                                           {
                                               [[self.objectManager HTTPClient] setDefaultHeader:@"Authorization" value: [NSString stringWithFormat:@"bearer %@", [KLAuthWebService getInstance].accessToken]];
                                               [self sendArrayRequest:url Method:method Data:data withCallback:callback];
                                           }else
                                           {
                                               callback(NO, nil, error);
                                               [SVProgressHUD  showWithMaskType:SVProgressHUDMaskTypeClear];
                                               [[KLApi instance] logout:^(BOOL succ) {
                                                   [SVProgressHUD dismiss];
                                                   AppDelegate *delegate =  (AppDelegate *)[UIApplication sharedApplication].delegate;
                                                   [delegate logout];
                                               }];
                                           }
                                       }];
                                   }else
                                   {
                                       callback(NO, nil, error);
                                   }
                                   
                               }];
    }else if ([method isEqualToString:@"PUT"])
    {
        [self.objectManager putObject:data
                                 path:url
                           parameters:data
                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                  callback(YES, mappingResult.array, nil);
                              }
                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                  if (operation.HTTPRequestOperation.response.statusCode == 401)
                                  {
                                      [[KLAuthWebService getInstance] getTokenFromRefreshToken:^(BOOL success, KLAccessTokenResponse *response, NSError *error2) {
                                          if (success)
                                          {
                                              [[self.objectManager HTTPClient] setDefaultHeader:@"Authorization" value: [NSString stringWithFormat:@"bearer %@", [KLAuthWebService getInstance].accessToken]];
                                              [self sendArrayRequest:url Method:method Data:data withCallback:callback];
                                          }else
                                          {
                                              callback(NO, nil, error);
                                              [SVProgressHUD  showWithMaskType:SVProgressHUDMaskTypeClear];
                                              [[KLApi instance] logout:^(BOOL succ) {
                                                  [SVProgressHUD dismiss];
                                                  AppDelegate *delegate =  (AppDelegate *)[UIApplication sharedApplication].delegate;
                                                  [delegate logout];
                                              }];
                                          }
                                      }];
                                  }else
                                  {
                                      callback(NO, nil, error);
                                  }
                              }];
    }else if ([method isEqualToString:@"DELETE"])
    {
        [self.objectManager deleteObject:data
                                    path:url
                              parameters:data
                                 success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                     callback(YES, mappingResult.array, nil);
                                 }
                                 failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                     if (operation.HTTPRequestOperation.response.statusCode == 401)
                                     {
                                         [[KLAuthWebService getInstance] getTokenFromRefreshToken:^(BOOL success, KLAccessTokenResponse *response, NSError *error2) {
                                             if (success)
                                             {
                                                 [[self.objectManager HTTPClient] setDefaultHeader:@"Authorization" value: [NSString stringWithFormat:@"bearer %@", [KLAuthWebService getInstance].accessToken]];
                                                 [self sendArrayRequest:url Method:method Data:data withCallback:callback];
                                             }else
                                             {
                                                 callback(NO, nil, error);
                                                 [SVProgressHUD  showWithMaskType:SVProgressHUDMaskTypeClear];
                                                 [[KLApi instance] logout:^(BOOL succ) {
                                                     [SVProgressHUD dismiss];
                                                     AppDelegate *delegate =  (AppDelegate *)[UIApplication sharedApplication].delegate;
                                                     [delegate logout];
                                                 }];
                                             }
                                         }];
                                     }else
                                     {
                                         callback(NO, nil, error);
                                     }
                                 }];
    }
}

#pragma mark - User Profile

- (void)getProfile:(NSString *)accessToken withCallback:(KLCompletionBlock)callback
{
    [self configureRestKit];
    RKObjectMapping *userTokenMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [userTokenMapping addAttributeMappingsFromArray:@[@"headLine", @"age",
                                                      @"isAgeShowen",@"isBirthDateShowen",@"birthDate",@"isZodiacShowen",@"zodiac", @"aboutMe",
                                                      @"isDelux",@"lookingFors",
                                                      @"relationship",@"id",
                                                      @"quickbloxUserId",@"fullName",
                                                      @"photoUID",@"interests", @"relations"]];
    
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *userTokenResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:userTokenMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:@"api/userprofile"
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:userTokenResponseDescriptor];
    
    
    // Start doing some time consuming tasks like sending a request to the backend services
    
    // To see your callback in action uncomment the line below
    //[self onBackendResponse:nil withSuccess:YES error:nil];
    [self sendRequest:@"api/userprofile" Method:@"GET" Data:nil withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
    
    
}

- (void)updateProfile:(NSDictionary *)userProfile withCallback:(KLCompletionBlock)callback
{
    [self configureRestKit];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
   
    RKObjectMapping *userRegistrationMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [userRegistrationMapping addAttributeMappingsFromDictionary:@{@"fullname": @"fullname",
                                                                  @"aboutme":@"aboutme",
                                                                  @"headline":@"headline",
                                                                  @"birthdate":@"birthdate",
                                                                  @"isageshowen":@"isageshowen",
                                                                  @"isbirthdateshowen":@"isbirthdateshowen",
                                                                  @"iszodiacshowen":@"iszodiacshowen",
                                                                  @"personalitytypeid":@"personalitytypeid",
                                                                  @"relationshipid":@"relationshipid",
                                                                  @"photouid":@"photouid"}];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:userRegistrationMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:responseDescriptor];
    
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromDictionary:@{@"fullname": @"fullname",
                                                         @"aboutme":@"aboutme",
                                                         @"headline":@"headline",
                                                         @"birthdate":@"birthdate",
                                                         @"isageshowen":@"isageshowen",
                                                         @"isbirthdateshowen":@"isbirthdateshowen",
                                                         @"iszodiacshowen":@"iszodiacshowen",
                                                         @"personalitytypeid":@"personalitytypeid",
                                                         @"relationshipid":@"relationshipid",
                                                         @"photouid":@"photouid"}];
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[NSMutableDictionary class] rootKeyPath:nil method:RKRequestMethodPOST];
    [self.objectManager addRequestDescriptor:requestDescriptor];
    
    [self sendRequest:@"/api/userprofile/updateuserprofile" Method:@"POST" Data:userProfile withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
    
}

- (void)setPassword:(NSString *)password withCallback:(KLCompletionBlock)callback
{
    [self configureRestKit];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    
    RKObjectMapping *userRegistrationMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [userRegistrationMapping addAttributeMappingsFromDictionary:@{@"text": @"text"}];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:userRegistrationMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:responseDescriptor];
    
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromDictionary:@{@"NewPassword": @"NewPassword", @"ConfirmPassword": @"ConfirmPassword"}];
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[NSMutableDictionary class] rootKeyPath:nil method:RKRequestMethodPOST];
    [self.objectManager addRequestDescriptor:requestDescriptor];
    
    NSDictionary *queryParams = @{@"NewPassword" : password, @"ConfirmPassword": password};
    
    [self sendRequest:@"api/Account/SetPassword" Method:@"POST" Data:queryParams withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)changePassword:(NSString *)password oldPassword:(NSString *)oldPassword withCallback:(KLCompletionBlock)callback {
    [self configureRestKit];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    
    RKObjectMapping *userRegistrationMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [userRegistrationMapping addAttributeMappingsFromDictionary:@{@"text": @"text"}];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:userRegistrationMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:responseDescriptor];
    
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromDictionary:@{@"OldPassword": @"OldPassword", @"NewPassword": @"NewPassword", @"ConfirmPassword": @"ConfirmPassword"}];
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[NSMutableDictionary class] rootKeyPath:nil method:RKRequestMethodPOST];
    [self.objectManager addRequestDescriptor:requestDescriptor];
    
    NSDictionary *queryParams = @{@"OldPassword" : oldPassword, @"NewPassword" : password, @"ConfirmPassword": password};
    
    [self sendRequest:@"api/Account/ChangePassword" Method:@"POST" Data:queryParams withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)updateUserFullName:(NSString *)username withCallback:(KLCompletionBlock)callback
{
    [self configureRestKit];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    
    RKObjectMapping *userRegistrationMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [userRegistrationMapping addAttributeMappingsFromDictionary:@{@"text": @"text"}];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:userRegistrationMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:responseDescriptor];
    
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromDictionary:@{@"text": @"text"}];
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[NSMutableDictionary class] rootKeyPath:nil method:RKRequestMethodPOST];
    [self.objectManager addRequestDescriptor:requestDescriptor];
    
    NSDictionary *queryParams = @{@"text" : username};
    
    [self sendRequest:@"/api/userprofile/updatefullname" Method:@"POST" Data:queryParams withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)updateUserAboutMe:(NSString *)aboutme withCallback:(KLCompletionBlock)callback
{
    [self configureRestKit];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    
    RKObjectMapping *userRegistrationMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [userRegistrationMapping addAttributeMappingsFromDictionary:@{@"text": @"text"}];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:userRegistrationMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:responseDescriptor];
    
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromDictionary:@{@"text": @"text"}];
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[NSMutableDictionary class] rootKeyPath:nil method:RKRequestMethodPOST];
    [self.objectManager addRequestDescriptor:requestDescriptor];
    
    NSDictionary *queryParams = @{@"text" : aboutme};
    
    [self sendRequest:@"/api/userprofile/updateaboutme" Method:@"POST" Data:queryParams withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
    
}

- (void)updateUserHeadLine:(NSString *)headLine withCallback:(KLCompletionBlock)callback
{
    [self configureRestKit];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    
    RKObjectMapping *userRegistrationMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [userRegistrationMapping addAttributeMappingsFromDictionary:@{@"text": @"text"}];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:userRegistrationMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:responseDescriptor];
    
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromDictionary:@{@"text": @"text"}];
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[NSMutableDictionary class] rootKeyPath:nil method:RKRequestMethodPOST];
    [self.objectManager addRequestDescriptor:requestDescriptor];
    
    NSDictionary *queryParams = @{@"text" : headLine};
    
    [self sendRequest:@"/api/userprofile/updateheadline" Method:@"POST" Data:queryParams withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)updateUserAge:(int)age isShown:(BOOL)isShow withCallback:(KLCompletionBlock)callback
{
    [self configureRestKit];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    
    RKObjectMapping *userRegistrationMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [userRegistrationMapping addAttributeMappingsFromDictionary:@{@"age": @"age", @"isshown":@"isshown"}];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:userRegistrationMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:responseDescriptor];
    
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromDictionary:@{@"age": @"age", @"isshown":@"isshown"}];
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[NSMutableDictionary class] rootKeyPath:nil method:RKRequestMethodPOST];
    [self.objectManager addRequestDescriptor:requestDescriptor];
    
    NSDictionary *queryParams = @{@"age" :[NSString stringWithFormat:@"%d", age],
                                  @"isshown":isShow?@"true":@"false"};
    
    [self sendRequest:@"/api/userprofile/updateage" Method:@"POST" Data:queryParams withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
    
}

- (void)updateUserBirthDate:(NSString*)birthDate isShown:(BOOL)isShow withCallback:(KLCompletionBlock)callback
{
    [self configureRestKit];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    
    RKObjectMapping *userRegistrationMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [userRegistrationMapping addAttributeMappingsFromDictionary:@{@"birthDate": @"birthDate",
                                                                  @"isAgeShowen":@"isAgeShowen",
                                                                  @"isBirthDateShowen":@"isBirthDateShowen",
                                                                  @"isZodiacShowen":@"isZodiacShowen"}];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:userRegistrationMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:responseDescriptor];
    
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromDictionary:@{@"birthDate": @"birthDate",
                                                         @"isAgeShowen":@"isAgeShowen",
                                                         @"isBirthDateShowen":@"isBirthDateShowen",
                                                         @"isZodiacShowen":@"isZodiacShowen"}];
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[NSMutableDictionary class] rootKeyPath:nil method:RKRequestMethodPOST];
    [self.objectManager addRequestDescriptor:requestDescriptor];
    
    NSDictionary *queryParams = @{@"birthDate" :birthDate,
                                  @"isAgeShowen":isShow?@"true":@"false",
                                  @"isBirthDateShowen":isShow?@"true":@"false",
                                  @"isZodiacShowen":isShow?@"true":@"false"};
    
    [self sendRequest:@"/api/userprofile/updatebirthdate" Method:@"POST" Data:queryParams withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)updateUserRelationShip:(int)Id withCallback:(KLCompletionBlock)callback
{
    [self configureRestKit];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    
    RKObjectMapping *userRegistrationMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [userRegistrationMapping addAttributeMappingsFromDictionary:@{@"id": @"id"}];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:userRegistrationMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:responseDescriptor];

    [self sendRequest:[NSString stringWithFormat:@"/api/userprofile/updaterelationship/%d", Id] Method:@"POST" Data:nil withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)blockUser:(int)userId withCallback:(KLCompletionBlock)callback
{
    [self configureRestKit];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    
    RKObjectMapping *userRegistrationMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [userRegistrationMapping addAttributeMappingsFromDictionary:@{@"id": @"id"}];
    
    //    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:userRegistrationMapping
                                                 method:RKRequestMethodPUT
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:responseDescriptor];
    
    [self sendRequest:[NSString stringWithFormat:@"/api/user/block/%d", userId] Method:@"POST" Data:nil withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)updateUserNote:(NSString*)note UserId:(int)userId withCallback:(KLCompletionBlock)callback
{
    [self configureRestKit];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    
    
    RKObjectMapping *userRegistrationMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [userRegistrationMapping addAttributeMappingsFromDictionary:@{@"text": @"text"}];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:userRegistrationMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:responseDescriptor];
    
    NSDictionary *queryParams = @{@"text" : note};
    
    [self sendRequest:[NSString stringWithFormat:@"%@%d",@"/api/user/updatenote/", userId] Method:@"POST" Data:queryParams withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)updateUserLocation:(NSMutableDictionary*)location  withCallback:(KLCompletionBlock)callback
{
    [self configureRestKit];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    
    
    RKObjectMapping *userRegistrationMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [userRegistrationMapping addAttributeMappingsFromDictionary:@{@"latitude": @"latitude", @"longitude":@"longitude", @"accuracy":@"accuracy"}];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:userRegistrationMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:responseDescriptor];
    
    NSMutableDictionary *queryParams = @{@"latitude" : [location valueForKey:@"latitude"], @"longitude":[location valueForKey:@"longitude"], @"accuracy":[location valueForKey:@"theAccuracy"]};
    
    [self sendRequest:@"/api/user/updateLocation" Method:@"POST" Data:queryParams withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)addUserInterest:(int)Id withCallback:(KLCompletionBlock)callback
{
    [self configureRestKit];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    
    RKObjectMapping *userRegistrationMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [userRegistrationMapping addAttributeMappingsFromDictionary:@{@"id": @"id"}];

//    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:userRegistrationMapping
                                                 method:RKRequestMethodPUT
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:responseDescriptor];
    
    [self sendRequest:[NSString stringWithFormat:@"/api/userprofile/addinterest/%d", Id] Method:@"PUT" Data:nil withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)deleteUserInterest:(int)Id withCallback:(KLCompletionBlock)callback
{
    [self configureRestKit];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    
    RKObjectMapping *userRegistrationMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [userRegistrationMapping addAttributeMappingsFromDictionary:@{@"id": @"id"}];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:userRegistrationMapping
                                                 method:RKRequestMethodDELETE
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:responseDescriptor];
    
    [self sendRequest:[NSString stringWithFormat:@"/api/userprofile/removeinterest/%d", Id] Method:@"DELETE" Data:nil withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)addUserLookingFor:(int)Id withCallback:(KLCompletionBlock)callback
{
    [self configureRestKit];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    
    RKObjectMapping *userRegistrationMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [userRegistrationMapping addAttributeMappingsFromDictionary:@{@"id": @"id"}];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:userRegistrationMapping
                                                 method:RKRequestMethodPUT
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:responseDescriptor];
    
    [self sendRequest:[NSString stringWithFormat:@"/api/userprofile/addlookingfor/%d", Id] Method:@"PUT" Data:nil withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)deleteUserLookingFor:(int)Id withCallback:(KLCompletionBlock)callback
{
    [self configureRestKit];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    
    RKObjectMapping *userRegistrationMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [userRegistrationMapping addAttributeMappingsFromDictionary:@{@"id": @"id"}];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:userRegistrationMapping
                                                 method:RKRequestMethodDELETE
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:responseDescriptor];
    
    [self sendRequest:[NSString stringWithFormat:@"/api/userprofile/removelookingfor/%d", Id] Method:@"DELETE" Data:nil withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)updateUserPhotoUID:(NSString *)photoUID withCallback:(KLCompletionBlock)callback
{
    [self configureRestKit];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    
    RKObjectMapping *userRegistrationMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [userRegistrationMapping addAttributeMappingsFromDictionary:@{@"text": @"text"}];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:userRegistrationMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:responseDescriptor];
    
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromDictionary:@{@"text": @"text"}];
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[NSMutableDictionary class] rootKeyPath:nil method:RKRequestMethodPOST];
    [self.objectManager addRequestDescriptor:requestDescriptor];
    
    NSDictionary *queryParams = @{@"text" : photoUID};
    
    [self sendRequest:@"/api/userprofile/updatephotouid" Method:@"POST" Data:queryParams withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)updateUserMakeDelux:(NSString *)makeDelux withCallback:(KLCompletionBlock)callback
{
    [self configureRestKit];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    
    RKObjectMapping *userRegistrationMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [userRegistrationMapping addAttributeMappingsFromDictionary:@{@"text": @"text"}];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:userRegistrationMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:responseDescriptor];
    
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromDictionary:@{@"text": @"text"}];
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[NSMutableDictionary class] rootKeyPath:nil method:RKRequestMethodPOST];
    [self.objectManager addRequestDescriptor:requestDescriptor];
    
    NSDictionary *queryParams = @{@"text" : makeDelux};
    
    [self sendRequest:@"/api/userprofile/makedelux" Method:@"POST" Data:queryParams withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)updateUserCharity:(int)Id withCallback:(KLCompletionBlock)callback
{
    [self configureRestKit];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    
    RKObjectMapping *userRegistrationMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [userRegistrationMapping addAttributeMappingsFromDictionary:@{@"id": @"id"}];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:userRegistrationMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:responseDescriptor];
    
    [self sendRequest:[NSString stringWithFormat:@"/api/userprofile/updatecharity/%d", Id] Method:@"PUT" Data:nil withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)removeUserCharity:(int)Id withCallback:(KLCompletionBlock)callback
{
    [self configureRestKit];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    
    RKObjectMapping *userRegistrationMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [userRegistrationMapping addAttributeMappingsFromDictionary:@{@"id": @"id"}];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:userRegistrationMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:responseDescriptor];
    
    [self sendRequest:[NSString stringWithFormat:@"/api/userprofile/removecharity/%d", Id] Method:@"PUT" Data:nil withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)updatePersonalityType:(int)personalityType withCallback:(KLCompletionBlock)callback {
    [self configureRestKit];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    
    RKObjectMapping *userRegistrationMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [userRegistrationMapping addAttributeMappingsFromDictionary:@{@"Request": @"Request"}];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:userRegistrationMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:responseDescriptor];
    
    [self sendRequest:[NSString stringWithFormat:@"api/UserProfile/UpdatePersonalityType/%d", personalityType] Method:@"POST" Data:nil withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)getUserCharities:(KLCompletionArrayBlock)callback {
    [self configureRestKit];
    
    RKObjectMapping *userRegistrationMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [userRegistrationMapping addAttributeMappingsFromArray:@[@"Id", @"Name", @"LogoUID", @"Domain"]];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:userRegistrationMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:responseDescriptor];
    
    [self sendArrayRequest:@"api/UserProfile/GetCharities" Method:@"GET" Data:nil withCallback:^(BOOL success, NSArray *response, NSError *error) {
        callback(success, response, error);
    }];
}

#pragma mark - PersonalityTypes API

- (void)getPersonalityTypes:(KLCompletionArrayBlock)callback
{
    [self configureRestKit];
    RKObjectMapping *PersonalityTypesMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [PersonalityTypesMapping addAttributeMappingsFromDictionary:@{@"id": @"id", @"name":@"name"}];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *PersonalityTypesMappingResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:PersonalityTypesMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:@"api/personalitytypes"
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:PersonalityTypesMappingResponseDescriptor];
    
    
    // Start doing some time consuming tasks like sending a request to the backend services
    
    // To see your callback in action uncomment the line below
    [self sendArrayRequest:@"api/personalitytypes" Method:@"GET" Data:nil withCallback:^(BOOL success, NSArray *response, NSError *error) {
        callback(success, response, error);
    }];
}

#pragma mark - Interests API

- (void)getInterests:(KLCompletionArrayBlock)callback
{
    [self configureRestKit];
    RKObjectMapping *InterestMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [InterestMapping addAttributeMappingsFromDictionary:@{@"id": @"id", @"name":@"name"}];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *InterestResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:InterestMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:InterestResponseDescriptor];
    
    
    // Start doing some time consuming tasks like sending a request to the backend services
    
    // To see your callback in action uncomment the line below
    [self sendArrayRequest:@"api/interests" Method:@"GET" Data:nil withCallback:^(BOOL success, NSArray *response, NSError *error) {
        callback(success, response, error);
    }];
}

-(void)getCategory:(int)Id withCallback:(KLCompletionArrayBlock)callback
{
    [self configureRestKit];
    RKObjectMapping *InterestMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [InterestMapping addAttributeMappingsFromDictionary:@{@"id": @"id", @"name":@"name"}];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *InterestResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:InterestMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:InterestResponseDescriptor];
    
    
    // Start doing some time consuming tasks like sending a request to the backend services
    
    // To see your callback in action uncomment the line below
    [self sendArrayRequest:[NSString stringWithFormat:@"api/interests/category/%d", Id] Method:@"GET" Data:nil withCallback:^(BOOL success, NSArray *response, NSError *error) {
        callback(success, response, error);
    }];
    
}

#pragma mark - User APIs

- (void)getUsersClosestByDistance:(int)distance latitude:(double)lat longitude:(double)lng withCallback:(KLCompletionArrayBlock)callback
{
    [self configureRestKit];
    RKObjectMapping *CategoryMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [CategoryMapping addAttributeMappingsFromArray:@[@"headLine", @"age",
                                                     @"isAgeShowen",@"isBirthDateShowen",@"birthDate",@"isZodiacShowen",@"zodiac", @"aboutMe",
                                                     @"isDelux",@"lookingFors",
                                                     @"relationship",@"id",
                                                     @"quickbloxUserId",@"fullName",
                                                     @"photoUID",@"interests", @"relations"]];
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *CategoryResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:CategoryMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:CategoryResponseDescriptor];
    
    [self sendArrayRequest:[NSString stringWithFormat:@"/api/user/SearchClosest/%d/%f/%f", distance, lat, lng] Method:@"GET" Data:nil withCallback:^(BOOL success, NSArray *response, NSError *error) {
        callback(success, response, error);
    }];
}


- (void)getAllFavourites:(KLCompletionArrayBlock)callback
{
    [self configureRestKit];
    RKObjectMapping *CategoryMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [CategoryMapping addAttributeMappingsFromArray:@[@"headLine", @"age",
                                                     @"isAgeShowen",@"isBirthDateShowen",@"birthDate",@"isZodiacShowen",@"zodiac", @"aboutMe",
                                                     @"isDelux",@"lookingFors",
                                                     @"relationship",@"id",
                                                     @"quickbloxUserId",@"fullName",
                                                     @"photoUID",@"interests", @"relations"]];
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *CategoryResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:CategoryMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:CategoryResponseDescriptor];
    
    [self sendArrayRequest:[NSString stringWithFormat:@"/api/User/GetMyFavoriteUsers"] Method:@"GET" Data:nil withCallback:^(BOOL success, NSArray *response, NSError *error) {
        callback(success, response, error);
    }];
}


- (void)getUsersClosestByDistance:(int)distance withCallback:(KLCompletionArrayBlock)callback
{
     [self configureRestKit];
    RKObjectMapping *CategoryMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [CategoryMapping addAttributeMappingsFromArray:@[@"headLine", @"age",
                                                      @"isAgeShowen",@"isBirthDateShowen",@"birthDate",@"isZodiacShowen",@"zodiac", @"aboutMe",
                                                      @"isDelux",@"lookingFors",
                                                      @"relationship",@"id",
                                                      @"quickbloxUserId",@"fullName",
                                                      @"photoUID",@"interests", @"relations"]];
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *CategoryResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:CategoryMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:CategoryResponseDescriptor];

    [self sendArrayRequest:[NSString stringWithFormat:@"/api/user/SearchClosestByDistance/%d", distance] Method:@"GET" Data:nil withCallback:^(BOOL success, NSArray *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)getUserSearchByInterests:(NSArray*)IdArray withCallback:(KLCompletionArrayBlock)callback
{
    [self configureRestKit];
    RKObjectMapping *InterestMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [InterestMapping addAttributeMappingsFromArray:@[@"headLine", @"age",
                                                     @"isAgeShowen",@"isBirthDateShowen",@"birthDate",@"isZodiacShowen",@"zodiac", @"aboutMe",
                                                     @"isDelux",@"lookingFors",
                                                     @"relationship",@"id",
                                                     @"quickbloxUserId",@"fullName",
                                                     @"photoUID",@"interests", @"relations"]];
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *InterestResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:InterestMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:InterestResponseDescriptor];
    
    
    // Start doing some time consuming tasks like sending a request to the backend services
    
    // To see your callback in action uncomment the line below
    
    [self sendArrayRequest:@"api/user/searchbyinterests" Method:@"GET" Data:[self getDictionaryFromArray:IdArray] withCallback:^(BOOL success, NSArray *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)getUsersByName:(NSString*)name withCallback:(KLCompletionArrayBlock)callback
{
     [self configureRestKit];
    RKObjectMapping *CategoryMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [CategoryMapping addAttributeMappingsFromArray:@[@"headLine", @"age",
                                                     @"isAgeShowen",@"isBirthDateShowen",@"birthDate",@"isZodiacShowen",@"zodiac", @"aboutMe",
                                                     @"isDelux",@"lookingFors",
                                                     @"relationship",@"id",
                                                     @"quickbloxUserId",@"fullName",
                                                     @"photoUID",@"interests", @"relations"]];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *CategoryResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:CategoryMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:CategoryResponseDescriptor];
    
    [self sendArrayRequest:[NSString stringWithFormat:@"/api/user/SearchByName/%@", name] Method:@"GET" Data:nil withCallback:^(BOOL success, NSArray *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)getUsersByName:(NSString*)name searchArea:(NSString*)area withCallback:(KLCompletionArrayBlock)callback
{
    //area is friends
    if (area == nil)
        area = @"friends";
    [self configureRestKit];
    RKObjectMapping *CategoryMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [CategoryMapping addAttributeMappingsFromArray:@[@"id",
                                                     @"quickbloxUserId",@"fullName",
                                                     @"photoUID",@"interests", @"relations",@"userorder"]];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *CategoryResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:CategoryMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:CategoryResponseDescriptor];
    
    [self sendArrayRequest:[NSString stringWithFormat:@"/api/user/SearchByName/%@/%@", name, area] Method:@"GET" Data:nil withCallback:^(BOOL success, NSArray *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)getUserById:(int)userId withCallback:(KLCompletionBlock)callback
{
    [self configureRestKit];
    RKObjectMapping *CategoryMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [CategoryMapping addAttributeMappingsFromArray:@[@"headLine", @"age",
                                                     @"isAgeShowen",@"isBirthDateShowen",@"birthDate",@"isZodiacShowen",@"zodiac", @"aboutMe",
                                                     @"isDelux",@"lookingFors",
                                                     @"relationship",@"id",
                                                     @"quickbloxUserId",@"fullName",
                                                     @"photoUID",@"interests", @"relations"]];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *CategoryResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:CategoryMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:CategoryResponseDescriptor];
    
    [self sendRequest:[NSString stringWithFormat:@"/api/user/get/%d", userId] Method:@"GET" Data:nil withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)getFullInfoByEjabberdUserIds:(NSArray*)IdArray withCallback:(KLCompletionArrayBlock)callback
{
    [self configureRestKit];
    RKObjectMapping *CategoryMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [CategoryMapping addAttributeMappingsFromArray:@[@"headLine", @"age",
                                                     @"isAgeShowen",@"isBirthDateShowen",@"birthDate",@"isZodiacShowen",@"zodiac", @"aboutMe",
                                                     @"isDelux",@"lookingFors",
                                                     @"relationship",@"id",
                                                     @"quickbloxUserId",@"fullName",
                                                     @"photoUID",@"interests", @"relations"]];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *CategoryResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:CategoryMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:CategoryResponseDescriptor];
    
    [self sendArrayRequest:@"api/user/GetFullInfoByQuickbloxUserIds" Method:@"GET" Data:[self getDictionaryFromArray:IdArray] withCallback:^(BOOL success, NSArray *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)getFullInfoByUserIds:(NSArray*)IdArray withCallback:(KLCompletionArrayBlock)callback {
    
    [self configureRestKit];
    
    RKObjectMapping *CategoryMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [CategoryMapping addAttributeMappingsFromArray:@[@"headLine", @"age",
                                                     @"isAgeShowen",@"isBirthDateShowen",@"birthDate",@"isZodiacShowen",@"zodiac", @"aboutMe",
                                                     @"isDelux",@"lookingFors",
                                                     @"relationship",@"id",
                                                     @"quickbloxUserId",@"fullName",
                                                     @"photoUID",@"interests", @"relations"]];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *CategoryResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:CategoryMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:CategoryResponseDescriptor];
    
    [self sendArrayRequest:@"api/User/GetFullInfoByUserIds" Method:@"GET" Data:[self getDictionaryFromArray:IdArray] withCallback:^(BOOL success, NSArray *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)getShortInfoByUserIds:(NSArray*)IdArray withCallback:(KLCompletionArrayBlock)callback {
    
    [self configureRestKit];
    
    RKObjectMapping *CategoryMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [CategoryMapping addAttributeMappingsFromArray:@[@"FullName", @"UserOrder", @"id", @"quickbloxUserId",
                                                     @"photoUID",@"interests", @"relations"]];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *CategoryResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:CategoryMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:CategoryResponseDescriptor];
    
    [self sendArrayRequest:@"api/User/configureRestKit" Method:@"GET" Data:[self getDictionaryFromArray:IdArray] withCallback:^(BOOL success, NSArray *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)addFavorite:(int)userId withCallback:(KLCompletionBlock)callback
{
    [self configureRestKit];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    
    RKObjectMapping *userRegistrationMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [userRegistrationMapping addAttributeMappingsFromDictionary:@{@"id": @"id"}];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:userRegistrationMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:responseDescriptor];
    
    [self sendRequest:[NSString stringWithFormat:@"/api/User/Favorite/%d", userId] Method:@"POST" Data:nil withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)removeFavorite:(int)userId withCallback:(KLCompletionBlock)callback
{
    [self configureRestKit];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    
    RKObjectMapping *userRegistrationMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [userRegistrationMapping addAttributeMappingsFromDictionary:@{@"id": @"id"}];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:userRegistrationMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:responseDescriptor];
    
    [self sendRequest:[NSString stringWithFormat:@"/api/User/Unfavorite/%d", userId] Method:@"POST" Data:nil withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)sendFriendRequest:(NSUInteger)friendID message:(NSString *)message withCallback:(KLCompletionBlock)callback {
    
    [self configureRestKit];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    
    RKObjectMapping *userRegistrationMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [userRegistrationMapping addAttributeMappingsFromDictionary:@{@"text": @"text"}];
    
    // register mappings with the provider using a response descriptor
    
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:userRegistrationMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:responseDescriptor];
    
    // Register request descriptor
    
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromDictionary:@{@"Text": @"Text" }];
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[NSMutableDictionary class] rootKeyPath:nil method:RKRequestMethodPOST];
    [self.objectManager addRequestDescriptor:requestDescriptor];
    
    // Start doing some time consuming tasks like sending a request to the backend services
    
    NSDictionary *data = @{@"Text": message};
    
    [self sendRequest:[NSString stringWithFormat:@"api/User/SendFriendRequest/%lu", friendID] Method:@"POST" Data:data withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)acceptFriendRequest:(NSUInteger)requesterID message:(NSString *)message withCallback:(KLCompletionBlock)callback {
    
    [self configureRestKit];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    
    RKObjectMapping *userRegistrationMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [userRegistrationMapping addAttributeMappingsFromDictionary:@{@"text": @"text"}];
    
    // register mappings with the provider using a response descriptor
    
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:userRegistrationMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:responseDescriptor];

    // Start doing some time consuming tasks like sending a request to the backend services
    
    [self sendRequest:[NSString stringWithFormat:@"api/User/AcceptFriendRequest/%lu", requesterID] Method:@"POST" Data:nil withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)declineFriendRequest:(NSUInteger)requesterID message:(NSString *)message withCallback:(KLCompletionBlock)callback {
    
    [self configureRestKit];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    
    RKObjectMapping *userRegistrationMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [userRegistrationMapping addAttributeMappingsFromDictionary:@{@"text": @"text"}];
    
    // register mappings with the provider using a response descriptor
    
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:userRegistrationMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:responseDescriptor];
    
    // Start doing some time consuming tasks like sending a request to the backend services
    
    [self sendRequest:[NSString stringWithFormat:@"api/User/DeclaneFriendRequest/%lu", requesterID] Method:@"POST" Data:nil withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)getLookingFors:(KLCompletionArrayBlock)callback
{
    [self configureRestKit];
    RKObjectMapping *LookingForsMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [LookingForsMapping addAttributeMappingsFromDictionary:@{@"id": @"id", @"name":@"name"}];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *LookingForsMappingResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:LookingForsMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:@"api/lookingfors"
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:LookingForsMappingResponseDescriptor];
    
    
    // Start doing some time consuming tasks like sending a request to the backend services
    
    // To see your callback in action uncomment the line below
    [self sendArrayRequest:@"api/lookingfors" Method:@"GET" Data:nil withCallback:^(BOOL success, NSArray *response, NSError *error) {
        callback(success, response, error);
    }];
    
}

- (void)getUserListWithFriendRequest:(KLCompletionArrayBlock)callback {
    
    [self configureRestKit];
    
    RKObjectMapping *CategoryMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [CategoryMapping addAttributeMappingsFromArray:@[@"headLine", @"age", @"isAgeShowen", @"isBirthDateShowen",
                                                     @"birthDate", @"isZodiacShowen", @"zodiac", @"aboutMe",
                                                     @"isDelux", @"lookingFors", @"relationship", @"id",
                                                     @"quickbloxUserId", @"fullName",
                                                     @"photoUID", @"interests", @"relations"]];
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *CategoryResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:CategoryMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:CategoryResponseDescriptor];
    
    [self sendArrayRequest:@"api/User/GetListOfUsersWithFriendRequests" Method:@"GET" Data:nil withCallback:^(BOOL success, NSArray *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)getRelationshipTypes:(KLCompletionArrayBlock)callback
{
    [self configureRestKit];
    RKObjectMapping *RelationshipMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [RelationshipMapping addAttributeMappingsFromDictionary:@{@"id": @"id", @"name":@"name"}];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *RelationshipMappingResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:RelationshipMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:@"api/relationships"
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:RelationshipMappingResponseDescriptor];
    
    
    // Start doing some time consuming tasks like sending a request to the backend services
    
    // To see your callback in action uncomment the line below
    [self sendArrayRequest:@"api/relationships" Method:@"GET" Data:nil withCallback:^(BOOL success, NSArray *response, NSError *error) {
        callback(success, response, error);
    }];
}

#pragma mark - Charity APIs

- (void)getCharity:(KLCompletionArrayBlock)callback
{
    [self configureRestKit];
    RKObjectMapping *CharityMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [CharityMapping addAttributeMappingsFromDictionary:@{@"id": @"id", @"name": @"name", @"logouid":@"logouid", @"domain":@"domain"}];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *CharityResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:CharityMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:@"api/charity"
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:CharityResponseDescriptor];
    
    
    // Start doing some time consuming tasks like sending a request to the backend services
    
    // To see your callback in action uncomment the line below
    [self sendArrayRequest:@"api/charity" Method:@"GET" Data:nil withCallback:^(BOOL success, NSArray *response, NSError *error) {
        callback(success, response, error);
    }];
}

#pragma mark - Stumbler APIs

- (void)getStumblerById:(int)Id withCallback:(KLCompletionBlock)callback
{
    [self configureRestKit];
    RKObjectMapping *InterestMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [InterestMapping addAttributeMappingsFromDictionary:@{@"post": @"post", @"privacy":@"privacy",@"latitude":@"latitude", @"longitude":@"longitude", @"createdate":@"createdate",@"userownerid":@"userownerid",@"ownerfullname":@"ownerfullname",@"owneruserphotouid":@"owneruserphotouid",@"goingcount":@"goingcount",@"maybecount":@"maybecount",@"attendees":@"attendees",@"id":@"id",@"name":@"name",@"date":@"date",@"imageUID":@"imageUID",@"invitedcount":@"invitedcount"}];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *InterestResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:InterestMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:InterestResponseDescriptor];
    
    
    // Start doing some time consuming tasks like sending a request to the backend services
    
    // To see your callback in action uncomment the line below
    [self sendRequest:[NSString stringWithFormat:@"api/stumbler/get/%d", Id] Method:@"GET" Data:nil withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)getMyStumbler:(KLCompletionArrayBlock)callback
{
    [self configureRestKit];
    RKObjectMapping *InterestMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [InterestMapping addAttributeMappingsFromDictionary:@{@"id": @"id",@"name":@"name",@"date":@"date",@"imageUID":@"imageUID",@"invitedcount":@"invitedcount"}];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *InterestResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:InterestMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:InterestResponseDescriptor];
    
    
    // Start doing some time consuming tasks like sending a request to the backend services
    
    // To see your callback in action uncomment the line below
    [self sendArrayRequest:@"api/stumbler/getallmy" Method:@"GET" Data:nil withCallback:^(BOOL success, NSArray *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)getStumblerByName:(NSString*)name withCallback:(KLCompletionArrayBlock)callback
{
    [self configureRestKit];
    RKObjectMapping *InterestMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [InterestMapping addAttributeMappingsFromDictionary:@{@"id": @"id",@"name":@"name",@"date":@"date",@"imageUID":@"imageUID",@"invitedcount":@"invitedcount"}];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *InterestResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:InterestMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:InterestResponseDescriptor];
    
    
    // Start doing some time consuming tasks like sending a request to the backend services
    
    // To see your callback in action uncomment the line below
    [self sendArrayRequest:[NSString stringWithFormat:@"api/stumbler/searchbyname?text=%@", name] Method:@"GET" Data:nil withCallback:^(BOOL success, NSArray *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)createStumbler:(KLStumblerModel*)stumbler withCallback:(KLCompletionBlock)callback
{
    [self configureRestKit];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    
    RKObjectMapping *userRegistrationMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [userRegistrationMapping addAttributeMappingsFromDictionary:@{@"post": @"post", @"privacy":@"privacy",@"address":@"address",@"latitude":@"latitude", @"longitude":@"longitude", @"createdate":@"createdate",@"userownerid":@"userownerid",@"ownerfullname":@"ownerfullname",@"owneruserphotouid":@"owneruserphotouid",@"goingcount":@"goingcount",@"maybecount":@"maybecount",@"attendees":@"attendees",@"id":@"id",@"name":@"name",@"date":@"date",@"imageUID":@"imageUID",@"invitedcount":@"invitedcount"}];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:userRegistrationMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:responseDescriptor];
    
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromDictionary:@{@"stumblername": @"stumblername",
                                                         @"date":@"date",
                                                         @"imageUID":@"imageUID",
                                                         @"post":@"post",
                                                         @"privacy":@"privacy",
                                                         @"address":@"address",
                                                         @"latitude":@"latitude",
                                                         @"longitude":@"longitude",
                                                         @"attendeeids":@"attendeeids",
                                                         @"subcategoryids":@"subcategoryids"}];
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[NSMutableDictionary class] rootKeyPath:nil method:RKRequestMethodPOST];
    [self.objectManager addRequestDescriptor:requestDescriptor];
    
    [self sendRequest:@"/api/stumbler/create" Method:@"POST" Data:[stumbler postDictionary] withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)addAttendee:(int)Id withCallback:(KLCompletionBlock)callback
{
    [self configureRestKit];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    
    RKObjectMapping *userRegistrationMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [userRegistrationMapping addAttributeMappingsFromDictionary:@{@"id": @"id"}];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:userRegistrationMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:responseDescriptor];
    
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromDictionary:@{@"id":@"id"}];
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[NSMutableDictionary class] rootKeyPath:nil method:RKRequestMethodPOST];
    [self.objectManager addRequestDescriptor:requestDescriptor];
    
    NSDictionary *queryParams = @{@"id":[NSString stringWithFormat:@"%d",Id]};
    [self sendRequest:[NSString stringWithFormat:@"/api/stumbler/addattendee/%d", Id] Method:@"POST" Data:queryParams withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)removeAttendee:(int)Id withCallback:(KLCompletionBlock)callback
{
    [self configureRestKit];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    
    RKObjectMapping *userRegistrationMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [userRegistrationMapping addAttributeMappingsFromDictionary:@{@"id": @"id"}];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:userRegistrationMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:responseDescriptor];
    
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromDictionary:@{@"id":@"id"}];
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[NSMutableDictionary class] rootKeyPath:nil method:RKRequestMethodPOST];
    [self.objectManager addRequestDescriptor:requestDescriptor];
    
    NSDictionary *queryParams = @{@"id":[NSString stringWithFormat:@"%d",Id]};
    [self sendRequest:[NSString stringWithFormat:@"/api/stumbler/removeattendee/%d", Id] Method:@"POST" Data:queryParams withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)inviteStumbler:(int)Id withCallback:(KLCompletionBlock)callback
{
    [self configureRestKit];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    
    RKObjectMapping *userRegistrationMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [userRegistrationMapping addAttributeMappingsFromDictionary:@{@"id": @"id"}];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:userRegistrationMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:responseDescriptor];
    
    [self sendRequest:[NSString stringWithFormat:@"/api/stumbler/invitetostumbler/%d", Id] Method:@"POST" Data:nil withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)gotoStumbler:(int)Id withCallback:(KLCompletionBlock)callback
{
    [self configureRestKit];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    
    RKObjectMapping *userRegistrationMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [userRegistrationMapping addAttributeMappingsFromDictionary:@{@"id": @"id"}];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:userRegistrationMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:responseDescriptor];
    
    [self sendRequest:[NSString stringWithFormat:@"/api/stumbler/gotostumbler/%d", Id] Method:@"POST" Data:nil withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)maybeGotoStumbler:(int)Id withCallback:(KLCompletionBlock)callback
{
    [self configureRestKit];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    
    RKObjectMapping *userRegistrationMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [userRegistrationMapping addAttributeMappingsFromDictionary:@{@"id": @"id"}];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:userRegistrationMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:responseDescriptor];
    
    [self sendRequest:[NSString stringWithFormat:@"/api/stumbler/maybegotostumbler/%d", Id] Method:@"POST" Data:nil withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)likeAttendee:(int)Id withCallback:(KLCompletionBlock)callback
{
    [self configureRestKit];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    
    RKObjectMapping *userRegistrationMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [userRegistrationMapping addAttributeMappingsFromDictionary:@{@"id": @"id"}];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:userRegistrationMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:responseDescriptor];
    
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromDictionary:@{@"id":@"id"}];
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[NSMutableDictionary class] rootKeyPath:nil method:RKRequestMethodPOST];
    [self.objectManager addRequestDescriptor:requestDescriptor];
    
    NSDictionary *queryParams = @{@"id":[NSString stringWithFormat:@"%d",Id]};
    [self sendRequest:[NSString stringWithFormat:@"/api/stumbler/likeattendee/%d", Id] Method:@"POST" Data:queryParams withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)addCommentAttendee:(int)Id comment:(NSString*)comment withCallback:(KLCompletionBlock)callback
{
    [self configureRestKit];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    
    RKObjectMapping *userRegistrationMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [userRegistrationMapping addAttributeMappingsFromDictionary:@{@"id": @"id"}];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:userRegistrationMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:responseDescriptor];
    
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromDictionary:@{@"comment": @"comment",
                                                         @"id":@"id"}];
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[NSMutableDictionary class] rootKeyPath:nil method:RKRequestMethodPOST];
    [self.objectManager addRequestDescriptor:requestDescriptor];
    
    NSDictionary *queryParams = @{@"text" : comment, @"id":[NSString stringWithFormat:@"%d",Id]};
    [self sendRequest:[NSString stringWithFormat:@"/api/stumbler/addcommenttoattendee/%d", Id] Method:@"POST" Data:queryParams withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
}

-(void)getSearchByCategoryId:(int)Id withCallback:(KLCompletionArrayBlock)callback
{
    [self configureRestKit];
    RKObjectMapping *InterestMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [InterestMapping addAttributeMappingsFromDictionary:@{@"id": @"id",@"name":@"name",@"date":@"date",@"imageUID":@"imageUID",@"invitedcount":@"invitedcount"}];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *InterestResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:InterestMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:InterestResponseDescriptor];
    
    
    // Start doing some time consuming tasks like sending a request to the backend services
    
    // To see your callback in action uncomment the line below
    [self sendArrayRequest:[NSString stringWithFormat:@"/api/stumbler/searchbycategoryid/%d", Id] Method:@"GET" Data:nil withCallback:^(BOOL success, NSArray *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)getSearchByCategories:(NSArray*)IdArray withCallback:(KLCompletionArrayBlock)callback
{
    [self configureRestKit];
    RKObjectMapping *InterestMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [InterestMapping addAttributeMappingsFromDictionary:@{@"id": @"id",@"name":@"name",@"date":@"date",@"imageUID":@"imageUID",@"invitedcount":@"invitedcount"}];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *InterestResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:InterestMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:InterestResponseDescriptor];
    
    
    // Start doing some time consuming tasks like sending a request to the backend services
    
    // To see your callback in action uncomment the line below

    [self sendArrayRequest:@"api/stumbler/searchbycategories" Method:@"GET" Data:[self getDictionaryFromArray:IdArray] withCallback:^(BOOL success, NSArray *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)getSearchBySubCategories:(NSArray*)IdArray withCallback:(KLCompletionArrayBlock)callback
{
    [self configureRestKit];
    RKObjectMapping *InterestMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [InterestMapping addAttributeMappingsFromDictionary:@{@"id": @"id",@"name":@"name",@"date":@"date",@"imageUID":@"imageUID",@"invitedcount":@"invitedcount"}];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *InterestResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:InterestMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:InterestResponseDescriptor];
    
    
    // Start doing some time consuming tasks like sending a request to the backend services
    
    // To see your callback in action uncomment the line below
    
    [self sendArrayRequest:@"api/stumbler/searchbysubcategories" Method:@"GET" Data:[self getDictionaryFromArray:IdArray] withCallback:^(BOOL success, NSArray *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)getFutureByStatus:(int)status withCallback:(KLCompletionArrayBlock)callback
{
    [self configureRestKit];
    RKObjectMapping *InterestMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [InterestMapping addAttributeMappingsFromDictionary:@{@"id": @"id",@"name":@"name",@"date":@"date",@"imageUID":@"imageUID",@"invitedcount":@"invitedcount"}];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *InterestResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:InterestMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:InterestResponseDescriptor];
    
    NSArray *statusArray = @[@"going", @"invited", @"maybe", @"joined", @"notgoing"];
    // Start doing some time consuming tasks like sending a request to the backend services
    
    // To see your callback in action uncomment the line below
    [self sendArrayRequest:[NSString stringWithFormat:@"api/stumbler/getfuturebystatus/%@", [statusArray objectAtIndex:status]] Method:@"GET" Data:nil withCallback:^(BOOL success, NSArray *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)getStumblerAllPast:(KLCompletionArrayBlock)callback
{
    [self configureRestKit];
    RKObjectMapping *InterestMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [InterestMapping addAttributeMappingsFromDictionary:@{@"id": @"id",@"name":@"name",@"date":@"date",@"imageUID":@"imageUID",@"invitedcount":@"invitedcount"}];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *InterestResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:InterestMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:InterestResponseDescriptor];

    // Start doing some time consuming tasks like sending a request to the backend services
    
    // To see your callback in action uncomment the line below
    [self sendArrayRequest:@"api/stumbler/all/past" Method:@"GET" Data:nil withCallback:^(BOOL success, NSArray *response, NSError *error) {
        callback(success, response, error);
    }];
}


- (void)getStumblerAllPastHosted:(KLCompletionArrayBlock)callback
{
    [self configureRestKit];
    RKObjectMapping *InterestMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [InterestMapping addAttributeMappingsFromDictionary:@{@"id": @"id",@"name":@"name",@"date":@"date",@"imageUID":@"imageUID",@"invitedcount":@"invitedcount"}];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *InterestResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:InterestMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:InterestResponseDescriptor];
    
    // Start doing some time consuming tasks like sending a request to the backend services
    
    // To see your callback in action uncomment the line below
    [self sendArrayRequest:@"api/stumbler/all/past/hosted" Method:@"GET" Data:nil withCallback:^(BOOL success, NSArray *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)getStumblerAllFutureHosted:(KLCompletionArrayBlock)callback
{
    [self configureRestKit];
    RKObjectMapping *InterestMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [InterestMapping addAttributeMappingsFromDictionary:@{@"id": @"id",@"name":@"name",@"date":@"date",@"imageUID":@"imageUID",@"invitedcount":@"invitedcount"}];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *InterestResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:InterestMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:InterestResponseDescriptor];
    
    // Start doing some time consuming tasks like sending a request to the backend services
    
    // To see your callback in action uncomment the line below
    [self sendArrayRequest:@"api/stumbler/all/future/hosted" Method:@"GET" Data:nil withCallback:^(BOOL success, NSArray *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)addStumblerId:(int)stumblerId attendeeId:(int)Id withCallback:(KLCompletionBlock)callback
{
    [self configureRestKit];
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *InterestResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:nil
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:InterestResponseDescriptor];
    
    // Start doing some time consuming tasks like sending a request to the backend services
    
    // To see your callback in action uncomment the line below
    [self sendRequest:[NSString stringWithFormat:@"api/stumbler/%d/add/%d", stumblerId, Id] Method:@"POST" Data:nil withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)getStumblerCategoryAll:(KLCompletionArrayBlock)callback
{
    [self configureRestKit];
    RKObjectMapping *InterestMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [InterestMapping addAttributeMappingsFromDictionary:@{@"id": @"id",@"name":@"name"}];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *InterestResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:InterestMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:InterestResponseDescriptor];
    
    // Start doing some time consuming tasks like sending a request to the backend services
    
    // To see your callback in action uncomment the line below
    [self sendArrayRequest:@"api/stumblercategory/all" Method:@"GET" Data:nil withCallback:^(BOOL success, NSArray *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)getStumblerSubCategory:(int)Id withCallback:(KLCompletionArrayBlock)callback
{
    [self configureRestKit];
    RKObjectMapping *InterestMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [InterestMapping addAttributeMappingsFromDictionary:@{@"id": @"id",@"name":@"name"}];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *InterestResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:InterestMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:InterestResponseDescriptor];
    
    // Start doing some time consuming tasks like sending a request to the backend services
    
    // To see your callback in action uncomment the line below
    [self sendArrayRequest:[NSString stringWithFormat:@"api/stumblercategory/%d/subcategories", Id] Method:@"GET" Data:nil withCallback:^(BOOL success, NSArray *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)fileUpload:(NSData*) data storageName:(NSString*)storageName progress:(KLContentProgressBlock)progress withCallback:(KLCompletionBlock)callback;
{
    [self configureRestKit];
    if (data == nil)
    {
        callback(YES, nil, nil);
        return;
    }
    RKObjectMapping *InterestMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [InterestMapping addAttributeMappingsFromDictionary:@{@"fileName": @"filename",@"fileUrl":@"fileurl"}];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *InterestResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:InterestMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:InterestResponseDescriptor];
    
    NSMutableURLRequest *request = [self.objectManager multipartFormRequestWithObject:nil method:RKRequestMethodPOST path:[NSString stringWithFormat:@"%@%@",@"api/storage/UploadFile/",storageName] parameters:nil constructingBodyWithBlock:^(id<AFRKMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:@"file" fileName:@"image.png" mimeType:@"image/png"];
    }];

    RKObjectRequestOperation *requestOperation = [self.objectManager objectRequestOperationWithRequest:request success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        callback(YES, mappingResult.firstObject, nil);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        callback(NO, nil, error);
    }];
    [requestOperation.HTTPRequestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        if (progress != nil)
            progress((float)totalBytesWritten/totalBytesExpectedToWrite);
    }];
    [self.objectManager enqueueObjectRequestOperation:requestOperation];
}

- (void)fileUploadVideo:(NSData*) data storageName:(NSString*)storageName progress:(KLContentProgressBlock)progress withCallback:(KLCompletionBlock)callback;
{
    [self configureRestKit];
    if (data == nil)
    {
        callback(YES, nil, nil);
        return;
    }
    RKObjectMapping *InterestMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [InterestMapping addAttributeMappingsFromDictionary:@{@"fileName": @"filename",@"fileUrl":@"fileurl"}];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *InterestResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:InterestMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:InterestResponseDescriptor];
    
    NSMutableURLRequest *request = [self.objectManager multipartFormRequestWithObject:nil method:RKRequestMethodPOST path:[NSString stringWithFormat:@"%@%@",@"api/storage/UploadFile/",storageName] parameters:nil constructingBodyWithBlock:^(id<AFRKMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:@"file" fileName:@"video.mov" mimeType:@"video/quicktime"];
    }];
    
    RKObjectRequestOperation *requestOperation = [self.objectManager objectRequestOperationWithRequest:request success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        callback(YES, mappingResult.firstObject, nil);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        callback(NO, nil, error);
    }];
    [requestOperation.HTTPRequestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        if (progress != nil)
            progress((float)totalBytesWritten/totalBytesExpectedToWrite);
    }];
    [self.objectManager enqueueObjectRequestOperation:requestOperation];
}

#pragma mark - Notification API

- (void)getNotificationId:(NSString *)pushHandle withCallback:(KLCompletionBlock)callback {
    [self configureRestKit];
    
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [responseMapping addAttributeMappingsFromDictionary:@{@"text": @"text"}];
    
    // register mappings with the provider using a response descriptor
    
    RKResponseDescriptor *InterestResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:InterestResponseDescriptor];
    
    // Start doing some time consuming tasks like sending a request to the backend services
    
    [self sendRequest:[NSString stringWithFormat:@"api/notification/GetRegistrationId?handle=%@", pushHandle] Method:@"POST" Data:nil withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)registserNotification:(NSString *)registrationId pushHandle:(NSString *)handle tags:(NSArray *)tags withCallback:(KLCompletionBlock)callback {
    
    [self configureRestKit];
    
    // Register mappings with the provider using a response descriptor
    
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [responseMapping addAttributeMappingsFromDictionary:@{@"text": @"text"}];
    
    RKResponseDescriptor *InterestResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:InterestResponseDescriptor];
    
    // Register request mapping
    
    RKObjectMapping *tagsMapping = [RKObjectMapping mappingForClass:[NotificationTag class]];
    [tagsMapping addAttributeMappingsFromDictionary:@{@"Name": @"name", @"Value": @"value"}];
    
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromDictionary:@{@"Platform": @"Platform",
                                                         @"Handle": @"Handle"}];
    [requestMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Tags" toKeyPath:@"Tags" withMapping:tagsMapping]];
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[NSMutableDictionary class] rootKeyPath:nil method:RKRequestMethodPOST];
    [self.objectManager addRequestDescriptor:requestDescriptor];
    
    // Start doing some time consuming tasks like sending a request to the backend services
    
    NSMutableArray *tagData = [NSMutableArray array];
    
    for (NotificationTag *tag in tags) {
        [tagData addObject:[tag toDictionary]];
    }
    
    NSDictionary *data = @{@"Platform": PLATFORM_APNS, @"Handle": handle, @"Tags":tagData};
    
    [self sendRequest:[NSString stringWithFormat:@"api/notification/register/%@", registrationId] Method:@"POST" Data:data withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)testNotificationToTags:(NSString *)message tags:(NSArray *)tags {
    
    [self configureRestKit];
    
    // Register mappings with the provider using a response descriptor
    
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [responseMapping addAttributeMappingsFromDictionary:@{@"text": @"text"}];
    
    RKResponseDescriptor *InterestResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:InterestResponseDescriptor];
    
    // Register request mapping
    
    RKObjectMapping *tagsMapping = [RKObjectMapping mappingForClass:[NotificationTag class]];
    [tagsMapping addAttributeMappingsFromDictionary:@{@"Name": @"name", @"Value": @"value"}];
    
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromDictionary:@{@"Platform": @"Platform",
                                                         @"Handle": @"Handle"}];
    [requestMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Tags" toKeyPath:@"Tags" withMapping:tagsMapping]];
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[NSMutableDictionary class] rootKeyPath:nil method:RKRequestMethodPOST];
    [self.objectManager addRequestDescriptor:requestDescriptor];
    
    // Start doing some time consuming tasks like sending a request to the backend services
    
    NSMutableArray *tagData = [NSMutableArray array];
    
    for (NotificationTag *tag in tags) {
        [tagData addObject:[tag toDictionary]];
    }
    
    NSDictionary *data = @{@"Platform": PLATFORM_APNS, @"Message": message, @"Tags":tagData};
    
    [self sendRequest:@"api/notification/test/sendNotificationToTags" Method:@"POST" Data:data withCallback:^(BOOL success, NSDictionary *response, NSError *error) {

    }];
}

- (void)testNotificationToSelf:(NSString *)message tags:(NSArray *)tags {
    
    [self configureRestKit];
    
    // Register mappings with the provider using a response descriptor
    
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [responseMapping addAttributeMappingsFromDictionary:@{@"text": @"text"}];
    
    RKResponseDescriptor *InterestResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:InterestResponseDescriptor];
    
    // Register request mapping
    
    RKObjectMapping *tagsMapping = [RKObjectMapping mappingForClass:[NotificationTag class]];
    [tagsMapping addAttributeMappingsFromDictionary:@{@"Name": @"name", @"Value": @"value"}];
    
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromDictionary:@{@"Platform": @"Platform",
                                                         @"Handle": @"Handle"}];
    [requestMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Tags" toKeyPath:@"Tags" withMapping:tagsMapping]];
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[NSMutableDictionary class] rootKeyPath:nil method:RKRequestMethodPOST];
    [self.objectManager addRequestDescriptor:requestDescriptor];
    
    // Start doing some time consuming tasks like sending a request to the backend services
    
    NSMutableArray *tagData = [NSMutableArray array];
    
    for (NotificationTag *tag in tags) {
        [tagData addObject:[tag toDictionary]];
    }
    
    NSDictionary *data = @{@"Platform": PLATFORM_APNS, @"Message": message, @"Tags":tagData};
    
    [self sendRequest:@"api/notification/test/SendNotificationToSelf" Method:@"POST" Data:data withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        
    }];
}

#pragma mark - Association API

- (void)setAssociationActive:(NSUInteger)associationId isActive:(BOOL)isActive withCallback:(KLCompletionBlock)callback
{
    [self configureRestKit];
    
    // Register mappings with the provider using a response descriptor
    
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [responseMapping addAttributeMappingsFromDictionary:@{@"text": @"text"}];
    
    RKResponseDescriptor *InterestResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:InterestResponseDescriptor];
    
    // Start doing some time consuming tasks like sending a request to the backend services
    
    [self sendRequest:[NSString stringWithFormat:@"api/association/%ld/set/active/%@", (unsigned long)associationId, isActive?@"true":@"false"] Method:@"POST" Data:nil withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)createAssociation:(KLAssociation *)association withCallback:(KLCompletionBlock)callback {
    [self configureRestKit];
    
    NSDictionary* deviceRegistration = @{@"Name":association.name,
                                         @"PhoneNumber": association.phoneNumber,
                                         @"MobileNumber": association.mobileNumber,
                                         @"AddressLine1": association.addressLine1,
                                         @"AddressLine2": association.addressLine2,
                                         @"Suburb": association.suburb,
                                         @"State": association.state,
                                         @"Country": association.country,
                                         @"PostCodeText": association.postCode,
                                         @"Latitude": [NSNumber numberWithFloat:association.latitude],
                                         @"Longitude": [NSNumber numberWithFloat:association.longitude],
                                         @"BusinessOpenTime": association.businessOpenTime,
                                         @"BusinessCloseTime": association.businessCloseTime,
                                         @"BusinessWorkingOpenMask": association.businessWorkingOpenMask,
                                         @"IsShowBusinessOpenTimes": [NSNumber numberWithBool: association.showBusinessOpenTimes],
                                         @"EmailAddress": association.emailAddress,
                                         @"WebAddress": association.webAddress,
                                         @"MainContactName": association.mainContactName,
                                         @"BusinessTypeId": [NSNumber numberWithInteger:association.businessTypeId],
                                         @"ProfilePictureBlogStorageUrl": association.profilePictureBlogStorageUrl,
                                         @"BackgroundPictureBlobStorageUrl": association.backgroundPictureBlobStorageUrl,
                                         @"Interests": @{@"Array" : association.interests}};
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:deviceRegistration
                                                       options:NSJSONWritingPrettyPrinted error:nil];
    
    NSLog(@"JSON registration: %@", [[NSString alloc] initWithData:jsonData
                                                          encoding:NSUTF8StringEncoding]);
    
    
    
    NSURLSession* session = [NSURLSession
                             sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil
                             delegateQueue:nil];
    
    // Pass the pns and username tag as parameters with the REST URL to the ASP.NET backend
    NSURL* requestURL = [NSURL URLWithString:[NSString
                                              stringWithFormat:@"%@api/Business/Create", kBASERESOURCEURL]];
    
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
                                              NSString* status = [NSString stringWithFormat:@"Error Status for %ld\nError: %@\n", (long)httpResponse.statusCode, error];
                                              NSLog(@"%@",status);
                                              callback(false, nil, error);
                                              
                                          }
                                          
                                          if (data != NULL)
                                          {
                                              NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                              SBJsonParser *parser = [[SBJsonParser alloc] init];
                                              NSDictionary *jsonObject = [parser objectWithString:responseString];
                                              callback(true, jsonObject, error);
                                          }
                                      }];
    [dataTask resume];

}

- (void)editAssociation:(KLAssociation *)association withCallback:(KLCompletionBlock)callback {
    [self configureRestKit];
    
    NSDictionary* deviceRegistration = @{@"Name":association.name,
                                         @"PhoneNumber": association.phoneNumber,
                                         @"MobileNumber": association.mobileNumber,
                                         @"AddressLine1": association.addressLine1,
                                         @"AddressLine2": association.addressLine2,
                                         @"Suburb": association.suburb,
                                         @"State": association.state,
                                         @"Country": association.country,
                                         @"PostCodeText": association.postCode,
                                         @"Latitude": [NSNumber numberWithFloat:association.latitude],
                                         @"Longitude": [NSNumber numberWithFloat:association.longitude],
                                         @"BusinessOpenTime": association.businessOpenTime,
                                         @"BusinessCloseTime": association.businessCloseTime,
                                         @"BusinessWorkingOpenMask": association.businessWorkingOpenMask,
                                         @"IsShowBusinessOpenTimes": [NSNumber numberWithBool: association.showBusinessOpenTimes],
                                         @"EmailAddress": association.emailAddress,
                                         @"WebAddress": association.webAddress,
                                         @"MainContactName": association.mainContactName,
                                         @"BusinessTypeId": [NSNumber numberWithInteger:association.businessTypeId],
                                         @"ProfilePictureBlogStorageUrl": association.profilePictureBlogStorageUrl,
                                         @"BackgroundPictureBlobStorageUrl": association.backgroundPictureBlobStorageUrl,
                                         @"Interests": @{@"Array" : association.interests}};
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:deviceRegistration
                                                       options:NSJSONWritingPrettyPrinted error:nil];
    
    NSLog(@"JSON registration: %@", [[NSString alloc] initWithData:jsonData
                                                          encoding:NSUTF8StringEncoding]);
    
    
    
    NSURLSession* session = [NSURLSession
                             sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil
                             delegateQueue:nil];
    
    // Pass the pns and username tag as parameters with the REST URL to the ASP.NET backend
    NSURL* requestURL = [NSURL URLWithString:[NSString
                                              stringWithFormat:@"%@api/Association/Edit/%lu", kBASERESOURCEURL, (unsigned long)association.ID]];
    
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
                                              NSString* status = [NSString stringWithFormat:@"Error Status for %ld\nError: %@\n", (long)httpResponse.statusCode, error];
                                              NSLog(@"%@",status);
                                              callback(false, nil, error);
                                              
                                          }
                                          
                                          if (data != NULL)
                                          {
                                              NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                              SBJsonParser *parser = [[SBJsonParser alloc] init];
                                              NSDictionary *jsonObject = [parser objectWithString:responseString];
                                              callback(true, jsonObject, error);
                                          }
                                      }];
    [dataTask resume];
     
}

- (void)addAssociationMemebers:(NSArray *)userIDArray association:(NSUInteger)associationID withCallback:(KLCompletionBlock)callback {
    [self configureRestKit];
    
    // Register mappings with the provider using a response descriptor
    
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [responseMapping addAttributeMappingsFromDictionary:@{@"text": @"text"}];
    
    RKResponseDescriptor *InterestResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:InterestResponseDescriptor];

    // Start doing some time consuming tasks like sending a request to the backend services
    
    [self sendRequest:[NSString stringWithFormat:@"api/Association/AddMembers/%lu", (unsigned long)associationID] Method:@"POST" Data:[self getDictionaryFromArray:userIDArray] withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)removAssociationMembers:(NSArray *)userIDArray association:(NSUInteger)associationID withCallback:(KLCompletionBlock)callback {
    [self configureRestKit];
    
    // Register mappings with the provider using a response descriptor
    
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [responseMapping addAttributeMappingsFromDictionary:@{@"text": @"text"}];
    
    RKResponseDescriptor *InterestResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:InterestResponseDescriptor];
    
    // Start doing some time consuming tasks like sending a request to the backend services
    
    [self sendRequest:[NSString stringWithFormat:@"api/Association/RemoveMembers/%lu", (unsigned long)associationID] Method:@"POST" Data:[self getDictionaryFromArray:userIDArray] withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)addAssociationInterests:(NSArray *)interests association:(NSUInteger)associationID withCallback:(KLCompletionBlock)callback {
    [self configureRestKit];
    
    // Register mappings with the provider using a response descriptor
    
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [responseMapping addAttributeMappingsFromDictionary:@{@"text": @"text"}];
    
    RKResponseDescriptor *InterestResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:InterestResponseDescriptor];
    
    // Start doing some time consuming tasks like sending a request to the backend services
    
    [self sendRequest:[NSString stringWithFormat:@"api/Association/AddInterests/%lu", (unsigned long)associationID] Method:@"POST" Data:[self getDictionaryFromArray:interests] withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)removAssociatioInterests:(NSArray *)interests association:(NSUInteger)associationID withCallback:(KLCompletionBlock)callback {
    
    [self configureRestKit];
    
    // Register mappings with the provider using a response descriptor
    
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [responseMapping addAttributeMappingsFromDictionary:@{@"text": @"text"}];
    
    RKResponseDescriptor *InterestResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:InterestResponseDescriptor];

    // Start doing some time consuming tasks like sending a request to the backend services
    
    [self sendRequest:[NSString stringWithFormat:@"api/Association/RemoveInterests/%lu", (unsigned long)associationID] Method:@"POST" Data:[self getDictionaryFromArray:interests] withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)uploadAssociationPhoto:(KLPhoto *)photo association:(NSUInteger)associationID withCallback:(KLCompletionBlock)callback {
    
}

- (void)deleteAssociationPhoto:(KLPhoto *)photo association:(NSUInteger)associationID withCallback:(KLCompletionBlock)callback {
    
}

- (void)getAssociationById:(NSUInteger)associationID withCallback:(KLCompletionBlock)callback {
    
    [self configureRestKit];
    
    // Register mappings with the provider using a response descriptor
    
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [responseMapping addAttributeMappingsFromDictionary:@{@"UserOwner": @"UserOwner",
                                                          @"PhoneNumber": @"PhoneNumber",
                                                          @"MobileNumber": @"MobileNumber",
                                                          @"AddressLine1": @"AddressLine1",
                                                          @"AddressLine2": @"AddressLine2",
                                                          @"Suburb": @"Suburb",
                                                          @"State": @"State",
                                                          @"Country": @"Country",
                                                          @"PostCodeText": @"PostCodeText",
                                                          @"Latitude": @"Latitude",
                                                          @"Longitude": @"Longitude",
                                                          @"EmailAddress": @"EmailAddress",
                                                          @"WebAddress": @"WebAddress",
                                                          @"MainContactName": @"MainContactName",
                                                          @"BackgroundPictureBlobStorageUrl": @"BackgroundPictureBlobStorageUrl",
                                                          @"PageType": @"PageType",
                                                          @"Members": @"Members",
                                                          @"Followers": @"Followers",
                                                          @"Photos": @"Photos",
                                                          @"Id": @"Id",
                                                          @"EjabberdId": @"EjabberdId",
                                                          @"Name": @"Name",
                                                          @"ProfilePictureBlogStorageUrl": @"ProfilePictureBlogStorageUrl",
                                                          @"Interests": @"Interests", }];
    
    RKResponseDescriptor *InterestResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:InterestResponseDescriptor];
    
    // Start doing some time consuming tasks like sending a request to the backend services
    
    [self sendRequest:[NSString stringWithFormat:@"api/Association/Get/%lu", (unsigned long)associationID] Method:@"GET" Data:nil withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)followAssociation:(NSUInteger)associationID withCallback:(KLCompletionBlock)callback {
    
    [self configureRestKit];
    
    // Register mappings with the provider using a response descriptor
    
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [responseMapping addAttributeMappingsFromDictionary:@{@"text": @"text"}];
    
    RKResponseDescriptor *InterestResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:InterestResponseDescriptor];

    // Start doing some time consuming tasks like sending a request to the backend services
    
    [self sendRequest:[NSString stringWithFormat:@"api/Association/Follow/%lu", (unsigned long)associationID] Method:@"POST" Data:nil withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)unfollowAssociation:(NSUInteger)associationID withCallback:(KLCompletionBlock)callback {
    
    [self configureRestKit];
    
    // Register mappings with the provider using a response descriptor
    
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [responseMapping addAttributeMappingsFromDictionary:@{@"text": @"text"}];
    
    RKResponseDescriptor *InterestResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:InterestResponseDescriptor];
    
    // Start doing some time consuming tasks like sending a request to the backend services
    
    [self sendRequest:[NSString stringWithFormat:@"api/Association/Unfollow/%lu", (unsigned long)associationID] Method:@"POST" Data:nil withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)getAssociationFriends:(NSUInteger)associationID withCallback:(KLCompletionArrayBlock)callback {
    
    [self configureRestKit];
    
    // Register mappings with the provider using a response descriptor
    
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [responseMapping addAttributeMappingsFromArray:@[@"Id", @"QuickbloxUserId", @"FullName",@"PhotoUID"]];
    
    RKResponseDescriptor *InterestResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:InterestResponseDescriptor];
    
    // Start doing some time consuming tasks like sending a request to the backend services
    
    [self sendArrayRequest:[NSString stringWithFormat:@"api/Association/GetFriendsThatFollow/%lu", (unsigned long)associationID] Method:@"GET" Data:nil withCallback:^(BOOL success, NSArray *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)getAssociationByName:(NSString *)searchText withCallback:(KLCompletionArrayBlock)callback {
    
    [self configureRestKit];
    
    // Register mappings with the provider using a response descriptor
    
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [responseMapping addAttributeMappingsFromDictionary:@{@"UserOwner": @"UserOwner",
                                                          @"PhoneNumber": @"PhoneNumber",
                                                          @"MobileNumber": @"MobileNumber",
                                                          @"AddressLine1": @"AddressLine1",
                                                          @"AddressLine2": @"AddressLine2",
                                                          @"Suburb": @"Suburb",
                                                          @"State": @"State",
                                                          @"Country": @"Country",
                                                          @"PostCodeText": @"PostCodeText",
                                                          @"Latitude": @"Latitude",
                                                          @"Longitude": @"Longitude",
                                                          @"EmailAddress": @"EmailAddress",
                                                          @"WebAddress": @"WebAddress",
                                                          @"MainContactName": @"MainContactName",
                                                          @"BackgroundPictureBlobStorageUrl": @"BackgroundPictureBlobStorageUrl",
                                                          @"PageType": @"PageType",
                                                          @"Members": @"Members",
                                                          @"Followers": @"Followers",
                                                          @"Photos": @"Photos",
                                                          @"Id": @"Id",
                                                          @"EjabberdId": @"EjabberdId",
                                                          @"Name": @"Name",
                                                          @"ProfilePictureBlogStorageUrl": @"ProfilePictureBlogStorageUrl",
                                                          @"Interests": @"Interests", }];
    
    RKResponseDescriptor *InterestResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:InterestResponseDescriptor];
    
    // Start doing some time consuming tasks like sending a request to the backend services
    
    [self sendArrayRequest:[NSString stringWithFormat:@"api/Association/GetByName?text=%@", searchText] Method:@"GET" Data:nil withCallback:^(BOOL success, NSArray *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)getAssociationInterests:(NSUInteger)associationID withCallback:(KLCompletionBlock)callback {
    
}

- (void)deleteAssociation:(NSUInteger)associationID withCallback:(KLCompletionBlock)callback {
    
}

- (void)getAssociationByText:(NSString *)searchText withCallback:(KLCompletionBlock)callback {
    [self configureRestKit];
    
    // Register mappings with the provider using a response descriptor
    
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [responseMapping addAttributeMappingsFromDictionary:@{@"UserOwner": @"UserOwner",
                                                          @"PhoneNumber": @"PhoneNumber",
                                                          @"MobileNumber": @"MobileNumber",
                                                          @"AddressLine1": @"AddressLine1",
                                                          @"AddressLine2": @"AddressLine2",
                                                          @"Suburb": @"Suburb",
                                                          @"State": @"State",
                                                          @"Country": @"Country",
                                                          @"PostCodeText": @"PostCodeText",
                                                          @"Latitude": @"Latitude",
                                                          @"Longitude": @"Longitude",
                                                          @"EmailAddress": @"EmailAddress",
                                                          @"WebAddress": @"WebAddress",
                                                          @"MainContactName": @"MainContactName",
                                                          @"BackgroundPictureBlobStorageUrl": @"BackgroundPictureBlobStorageUrl",
                                                          @"PageType": @"PageType",
                                                          @"Members": @"Members",
                                                          @"Followers": @"Followers",
                                                          @"Photos": @"Photos",
                                                          @"Id": @"Id",
                                                          @"EjabberdId": @"EjabberdId",
                                                          @"Name": @"Name",
                                                          @"ProfilePictureBlogStorageUrl": @"ProfilePictureBlogStorageUrl",
                                                          @"Interests": @"Interests", }];
    
    RKResponseDescriptor *InterestResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:InterestResponseDescriptor];
    
    // Start doing some time consuming tasks like sending a request to the backend services
    
    [self sendRequest:[NSString stringWithFormat:@"api/Association?text=%@", searchText] Method:@"GET" Data:nil withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)getAssociationByInterests:(NSArray *)interests withCallback:(KLCompletionBlock)callback {
    
}

#pragma mark - Pages APIs

- (void)addPagePhoto:(NSUInteger)pageID photoUID:(NSString *)photoUID withCallback:(KLCompletionBlock)callback {
    
    [self configureRestKit];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    
    RKObjectMapping *userRegistrationMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [userRegistrationMapping addAttributeMappingsFromDictionary:@{@"text": @"text"}];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:userRegistrationMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:responseDescriptor];
    
    [self sendRequest:[NSString stringWithFormat:@"api/page/%lu/photos/add/%@", (unsigned long)pageID, photoUID] Method:@"POST" Data:nil withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)removePagePhoto:(NSUInteger)pageID photoUID:(NSString *)photoUID withCallback:(KLCompletionBlock)callback {
    
    [self configureRestKit];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    
    RKObjectMapping *userRegistrationMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [userRegistrationMapping addAttributeMappingsFromDictionary:@{@"text": @"text"}];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:userRegistrationMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:responseDescriptor];
    
    [self sendRequest:[NSString stringWithFormat:@"api/page/%lu/photos/remove/%@", (unsigned long)pageID, photoUID] Method:@"POST" Data:nil withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)getPageFriends:(NSUInteger)pageID withCallback:(KLCompletionArrayBlock)callback {
    
    [self configureRestKit];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    
    RKObjectMapping *userRegistrationMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [userRegistrationMapping addAttributeMappingsFromDictionary:@{@"text": @"text"}];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:userRegistrationMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:responseDescriptor];
    
    [self sendArrayRequest:[NSString stringWithFormat:@"api/page/%lu/friends", (unsigned long)pageID] Method:@"GET" Data:nil withCallback:^(BOOL success, NSArray *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)searchPagesByName:(NSString *)searchText withCallback:(KLCompletionArrayBlock)callback {
    
    [self configureRestKit];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    
    RKObjectMapping *userRegistrationMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [userRegistrationMapping addAttributeMappingsFromDictionary:@{@"text": @"text"}];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:userRegistrationMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:responseDescriptor];
    
    [self sendArrayRequest:[NSString stringWithFormat:@"api/page/search/%@", searchText] Method:@"GET" Data:nil withCallback:^(BOOL success, NSArray *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)getPageByID:(NSUInteger)pageID withCallback:(KLCompletionBlock)callback {
    
    [self configureRestKit];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    
    RKObjectMapping *userRegistrationMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [userRegistrationMapping addAttributeMappingsFromDictionary:@{@"text": @"text"}];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:userRegistrationMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:responseDescriptor];
    
    [self sendRequest:[NSString stringWithFormat:@"api/Page/%lu", (unsigned long)pageID] Method:@"GET" Data:nil withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)followPage:(NSUInteger)pageID withCallback:(KLCompletionBlock)callback {
    
    [self configureRestKit];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    
    RKObjectMapping *userRegistrationMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [userRegistrationMapping addAttributeMappingsFromDictionary:@{@"text": @"text"}];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:userRegistrationMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:responseDescriptor];
    
    [self sendRequest:[NSString stringWithFormat:@"api/Page/Follow/%lu", (unsigned long)pageID] Method:@"POST" Data:nil withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)unfollowPage:(NSUInteger)pageID withCallback:(KLCompletionBlock)callback {
    
    [self configureRestKit];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    
    RKObjectMapping *userRegistrationMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [userRegistrationMapping addAttributeMappingsFromDictionary:@{@"text": @"text"}];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:userRegistrationMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:responseDescriptor];
    
    [self sendRequest:[NSString stringWithFormat:@"api/Page/Unfollow/%lu", (unsigned long)pageID] Method:@"POST" Data:nil withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)getPageByInterests:(NSArray *)interestArray withCallback:(KLCompletionArrayBlock)callback {
    [self configureRestKit];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    
    RKObjectMapping *userRegistrationMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [userRegistrationMapping addAttributeMappingsFromDictionary:@{@"text": @"text"}];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:userRegistrationMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:responseDescriptor];
    
    [self sendArrayRequest:@"api/Page/GetByInterests" Method:@"GET" Data:[self getDictionaryFromArray:interestArray]  withCallback:^(BOOL success, NSArray *response, NSError *error) {
        callback(success, response, error);
    }];
}
#pragma mark - Business Types APIs

- (void)getBusinessTypes:(KLCompletionArrayBlock)callback {
    
    [self configureRestKit];
    
    // Register mappings with the provider using a response descriptor
    
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [responseMapping addAttributeMappingsFromDictionary:@{@"id": @"id",
                                                          @"name": @"name",
                                                          @"fullDescription": @"fullDescription",
                                                          @"imageUIDStandard": @"imageUIDStandard",
                                                          @"imageUIDRetina": @"imageUIDRetina" }];
    
    RKResponseDescriptor *InterestResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:InterestResponseDescriptor];
    
    // Start doing some time consuming tasks like sending a request to the backend services
    
    [self sendArrayRequest:[NSString stringWithFormat:@"api/businesstypes"] Method:@"GET" Data:nil withCallback:^(BOOL success, NSArray *response, NSError *error) {
        callback(success, response, error);
    }];
}

#pragma mark - Business APIs

- (void)setBusinessActive:(NSUInteger)businessID isActive:(BOOL)isActive withCallback:(KLCompletionBlock)callback {
    [self configureRestKit];
    
    // Register mappings with the provider using a response descriptor
    
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [responseMapping addAttributeMappingsFromDictionary:@{@"text": @"text"}];
    
    RKResponseDescriptor *InterestResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:InterestResponseDescriptor];
    
    // Start doing some time consuming tasks like sending a request to the backend services
    
    [self sendRequest:[NSString stringWithFormat:@"api/business/%ld/set/active/%@", (unsigned long)businessID, isActive?@"true":@"false"] Method:@"POST" Data:nil withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)searchBusinessByName:(NSString *)searchText withCallback:(KLCompletionArrayBlock)callback {
    
    [self configureRestKit];
    
    // Register mappings with the provider using a response descriptor
    
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [responseMapping addAttributeMappingsFromDictionary:@{@"UserOwner": @"UserOwner",
                                                          @"PhoneNumber": @"PhoneNumber",
                                                          @"MobileNumber": @"MobileNumber",
                                                          @"AddressLine1": @"AddressLine1",
                                                          @"AddressLine2": @"AddressLine2",
                                                          @"Suburb": @"Suburb",
                                                          @"State": @"State",
                                                          @"Country": @"Country",
                                                          @"PostCodeText": @"PostCodeText",
                                                          @"Latitude": @"Latitude",
                                                          @"Longitude": @"Longitude",
                                                          @"EmailAddress": @"EmailAddress",
                                                          @"WebAddress": @"WebAddress",
                                                          @"MainContactName": @"MainContactName",
                                                          @"BackgroundPictureBlobStorageUrl": @"BackgroundPictureBlobStorageUrl",
                                                          @"PageType": @"PageType",
                                                          @"Members": @"Members",
                                                          @"Followers": @"Followers",
                                                          @"Photos": @"Photos",
                                                          @"Id": @"Id",
                                                          @"EjabberdId": @"EjabberdId",
                                                          @"Name": @"Name",
                                                          @"ProfilePictureBlogStorageUrl": @"ProfilePictureBlogStorageUrl",
                                                          @"Interests": @"Interests", }];
    
    RKResponseDescriptor *InterestResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:InterestResponseDescriptor];
    
    // Start doing some time consuming tasks like sending a request to the backend services
    
    [self sendArrayRequest:[NSString stringWithFormat:@"api/business/search/name/%@", searchText] Method:@"GET" Data:nil withCallback:^(BOOL success, NSArray *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)searchBusinessByInterests:(NSArray *)interestArray withCallback:(KLCompletionArrayBlock)callback {
    
    [self configureRestKit];
    
    // Register mappings with the provider using a response descriptor
    
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [responseMapping addAttributeMappingsFromDictionary:@{@"UserOwner": @"UserOwner",
                                                          @"PhoneNumber": @"PhoneNumber",
                                                          @"MobileNumber": @"MobileNumber",
                                                          @"AddressLine1": @"AddressLine1",
                                                          @"AddressLine2": @"AddressLine2",
                                                          @"Suburb": @"Suburb",
                                                          @"State": @"State",
                                                          @"Country": @"Country",
                                                          @"PostCodeText": @"PostCodeText",
                                                          @"Latitude": @"Latitude",
                                                          @"Longitude": @"Longitude",
                                                          @"EmailAddress": @"EmailAddress",
                                                          @"WebAddress": @"WebAddress",
                                                          @"MainContactName": @"MainContactName",
                                                          @"BackgroundPictureBlobStorageUrl": @"BackgroundPictureBlobStorageUrl",
                                                          @"PageType": @"PageType",
                                                          @"Members": @"Members",
                                                          @"Followers": @"Followers",
                                                          @"Photos": @"Photos",
                                                          @"Id": @"Id",
                                                          @"EjabberdId": @"EjabberdId",
                                                          @"Name": @"Name",
                                                          @"ProfilePictureBlogStorageUrl": @"ProfilePictureBlogStorageUrl",
                                                          @"Interests": @"Interests", }];
    
    RKResponseDescriptor *InterestResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:InterestResponseDescriptor];
    
    // Start doing some time consuming tasks like sending a request to the backend services
    
    [self sendArrayRequest:@"api/business/search/interests" Method:@"GET" Data:[self getDictionaryFromArray:interestArray]  withCallback:^(BOOL success, NSArray *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)createBusiness:(KLBusiness *)business withCallback:(KLCompletionBlock)callback {
    
    NSDictionary* deviceRegistration = @{@"Name":business.name,
                                         @"PhoneNumber": business.phoneNumber,
                                         @"MobileNumber": business.mobileNumber,
                                         @"AddressLine1": business.addressLine1,
                                         @"AddressLine2": business.addressLine2,
                                         @"Suburb": business.suburb,
                                         @"State": business.state,
                                         @"Country": business.country,
                                         @"PostCodeText": business.postCode,
                                         @"Latitude": [NSNumber numberWithFloat:business.latitude],
                                         @"Longitude": [NSNumber numberWithFloat:business.longitude],
                                         @"BusinessOpenTime": business.businessOpenTime,
                                         @"BusinessCloseTime": business.businessCloseTime,
                                         @"BusinessWorkingOpenMask": business.businessWorkingOpenMask,
                                         @"IsShowBusinessOpenTimes": [NSNumber numberWithBool: business.showBusinessOpenTimes],
                                         @"EmailAddress": business.emailAddress,
                                         @"WebAddress": business.webAddress,
                                         @"MainContactName": business.mainContactName,
                                         @"BusinessTypeId": [NSNumber numberWithInteger:business.businessTypeId],
                                         @"ProfilePictureBlogStorageUrl": business.profilePictureBlogStorageUrl,
                                         @"BackgroundPictureBlobStorageUrl": business.backgroundPictureBlobStorageUrl,
                                         @"Interests": @{@"Array" : business.interests}};
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:deviceRegistration
                                                       options:NSJSONWritingPrettyPrinted error:nil];
    
    NSLog(@"JSON registration: %@", [[NSString alloc] initWithData:jsonData
                                                          encoding:NSUTF8StringEncoding]);
    
    
    
    NSURLSession* session = [NSURLSession
                             sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil
                             delegateQueue:nil];
    
    // Pass the pns and username tag as parameters with the REST URL to the ASP.NET backend
    NSURL* requestURL = [NSURL URLWithString:[NSString
                                              stringWithFormat:@"%@api/Business/Create", kBASERESOURCEURL]];
    
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
                                              NSString* status = [NSString stringWithFormat:@"Error Status for %ld\nError: %@\n", (long)httpResponse.statusCode, error];
                                              NSLog(@"%@",status);
                                              callback(false, nil, error);
                                              
                                          }
                                          
                                          if (data != NULL)
                                          {
                                              NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                              SBJsonParser *parser = [[SBJsonParser alloc] init];
                                              NSDictionary *jsonObject = [parser objectWithString:responseString];
                                              callback(true, jsonObject, error);
                                          }
                                      }];
    [dataTask resume];
    
    
}

- (void)editBusiness:(KLBusiness *)business withCallback:(KLCompletionBlock)callback {
    
    [self configureRestKit];
    
    NSDictionary* deviceRegistration = @{@"Name":business.name,
                                         @"PhoneNumber": business.phoneNumber,
                                         @"MobileNumber": business.mobileNumber,
                                         @"AddressLine1": business.addressLine1,
                                         @"AddressLine2": business.addressLine2,
                                         @"Suburb": business.suburb,
                                         @"State": business.state,
                                         @"Country": business.country,
                                         @"PostCodeText": business.postCode,
                                         @"Latitude": [NSNumber numberWithFloat:business.latitude],
                                         @"Longitude": [NSNumber numberWithFloat:business.longitude],
                                         @"BusinessOpenTime": business.businessOpenTime,
                                         @"BusinessCloseTime": business.businessCloseTime,
                                         @"BusinessWorkingOpenMask": business.businessWorkingOpenMask,
                                         @"IsShowBusinessOpenTimes": [NSNumber numberWithBool: business.showBusinessOpenTimes],
                                         @"EmailAddress": business.emailAddress,
                                         @"WebAddress": business.webAddress,
                                         @"MainContactName": business.mainContactName,
                                         @"BusinessTypeId": [NSNumber numberWithInteger:business.businessTypeId],
                                         @"ProfilePictureBlogStorageUrl": business.profilePictureBlogStorageUrl,
                                         @"BackgroundPictureBlobStorageUrl": business.backgroundPictureBlobStorageUrl,
                                         @"Interests": @{@"Array" : business.interests}};
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:deviceRegistration
                                                       options:NSJSONWritingPrettyPrinted error:nil];
    
    NSLog(@"JSON registration: %@", [[NSString alloc] initWithData:jsonData
                                                          encoding:NSUTF8StringEncoding]);
    
    
    
    NSURLSession* session = [NSURLSession
                             sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil
                             delegateQueue:nil];
    
    // Pass the pns and username tag as parameters with the REST URL to the ASP.NET backend
    NSURL* requestURL = [NSURL URLWithString:[NSString
                                              stringWithFormat:@"%@api/Business/Edit/%lu", kBASERESOURCEURL, business.ID]];
    
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
                                              NSString* status = [NSString stringWithFormat:@"Error Status for %ld\nError: %@\n", (long)httpResponse.statusCode, error];
                                              NSLog(@"%@",status);
                                              callback(false, nil, error);
                                              
                                          }
                                          
                                          if (data != NULL)
                                          {
                                              NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                              SBJsonParser *parser = [[SBJsonParser alloc] init];
                                              NSDictionary *jsonObject = [parser objectWithString:responseString];
                                              callback(true, jsonObject, error);
                                          }
                                      }];
    [dataTask resume];
    
}

- (void)addBusinessStaffs:(NSMutableArray *)staffs business:(NSUInteger)businessID withCallback:(KLCompletionBlock)callback {
    
    [self configureRestKit];
    
    // Register mappings with the provider using a response descriptor
    
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [responseMapping addAttributeMappingsFromDictionary:@{@"text": @"text"}];
    
    RKResponseDescriptor *InterestResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:InterestResponseDescriptor];
    
    // Start doing some time consuming tasks like sending a request to the backend services
    
    [self sendRequest:[NSString stringWithFormat:@"api/Business/AddStaffs/%lu", (unsigned long)businessID] Method:@"POST" Data:[self getDictionaryFromArray:staffs] withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)removeBusinessStaffs:(NSMutableArray *)staffs business:(NSUInteger)businessID withCallback:(KLCompletionBlock)callback {
    
    [self configureRestKit];
    
    // Register mappings with the provider using a response descriptor
    
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [responseMapping addAttributeMappingsFromDictionary:@{@"text": @"text"}];
    
    RKResponseDescriptor *InterestResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:InterestResponseDescriptor];
    
    // Start doing some time consuming tasks like sending a request to the backend services
    
    [self sendRequest:[NSString stringWithFormat:@"api/Business/RemoveStaffs/%lu", (unsigned long)businessID] Method:@"POST" Data:[self getDictionaryFromArray:staffs] withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)addBusinessInterests:(NSMutableArray *)interests business:(NSUInteger)businessID withCallback:(KLCompletionBlock)callback {
    
    [self configureRestKit];
    
    // Register mappings with the provider using a response descriptor
    
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [responseMapping addAttributeMappingsFromDictionary:@{@"text": @"text"}];
    
    RKResponseDescriptor *InterestResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:InterestResponseDescriptor];
    
    // Start doing some time consuming tasks like sending a request to the backend services
    
    [self sendRequest:[NSString stringWithFormat:@"api/Business/AddInterests/%lu", (unsigned long)businessID] Method:@"POST" Data:[self getDictionaryFromArray:interests] withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)removeBusinessInterests:(NSMutableArray *)interests business:(NSUInteger)businessID withCallback:(KLCompletionBlock)callback {
    
    [self configureRestKit];
    
    // Register mappings with the provider using a response descriptor
    
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [responseMapping addAttributeMappingsFromDictionary:@{@"text": @"text"}];
    
    RKResponseDescriptor *InterestResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:InterestResponseDescriptor];
    
    // Start doing some time consuming tasks like sending a request to the backend services
    
    [self sendRequest:[NSString stringWithFormat:@"api/Business/RemoveInterests/%lu", (unsigned long)businessID] Method:@"POST" Data:[self getDictionaryFromArray:interests] withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)getBusinessByInterests:(NSMutableArray *)interests withCallback:(KLCompletionArrayBlock)callback {
    
    [self configureRestKit];
    
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [responseMapping addAttributeMappingsFromArray:@[@"UserOwner", @"PhoneNumber", @"MobileNumber",  @"AddressLine1", @"AddressLine2",  @"Suburb", @"State",  @"Country", @"PostCodeText",  @"Latitude", @"Longitude", @"EmailAddress", @"WebAddress", @"MainContactName", @"BackgroundPictureBlobStorageUrl", @"PageType", @"Members", @"Followers", @"Photos", @"Id", @"EjabberdId", @"Name", @"ProfilePictureBlogStorageUrl", @"Interests"]];
    
    // register mappings with the provider using a response descriptor
    
    RKResponseDescriptor *InterestResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:InterestResponseDescriptor];
    
    
    // Start doing some time consuming tasks like sending a request to the backend services
    
    // To see your callback in action uncomment the line below
    
    [self sendArrayRequest:@"api/Business/GetByInterests" Method:@"GET" Data:[self getDictionaryFromArray:interests] withCallback:^(BOOL success, NSArray *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)getBusinessByID:(NSUInteger)ID withCallback:(KLCompletionBlock)callback {
    [self configureRestKit];
    
    // Register mappings with the provider using a response descriptor
    
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [responseMapping addAttributeMappingsFromDictionary:@{@"UserOwner": @"UserOwner",
                                                          @"PhoneNumber": @"PhoneNumber",
                                                          @"MobileNumber": @"MobileNumber",
                                                          @"AddressLine1": @"AddressLine1",
                                                          @"AddressLine2": @"AddressLine2",
                                                          @"Suburb": @"Suburb",
                                                          @"State": @"State",
                                                          @"Country": @"Country",
                                                          @"PostCodeText": @"PostCodeText",
                                                          @"Latitude": @"Latitude",
                                                          @"Longitude": @"Longitude",
                                                          @"EmailAddress": @"EmailAddress",
                                                          @"WebAddress": @"WebAddress",
                                                          @"MainContactName": @"MainContactName",
                                                          @"BackgroundPictureBlobStorageUrl": @"BackgroundPictureBlobStorageUrl",
                                                          @"PageType": @"PageType",
                                                          @"Members": @"Members",
                                                          @"Followers": @"Followers",
                                                          @"Photos": @"Photos",
                                                          @"Id": @"Id",
                                                          @"EjabberdId": @"EjabberdId",
                                                          @"Name": @"Name",
                                                          @"ProfilePictureBlogStorageUrl": @"ProfilePictureBlogStorageUrl",
                                                          @"Interests": @"Interests", }];
    
    RKResponseDescriptor *InterestResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:InterestResponseDescriptor];
    
    // Start doing some time consuming tasks like sending a request to the backend services

    [self sendRequest:[NSString stringWithFormat:@"api/Business/Get/%lu", (unsigned long)ID] Method:@"GET" Data:nil withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)followBusiness:(NSUInteger)businessID withCallback:(KLCompletionBlock)callback {
    
    [self configureRestKit];
    
    // Register mappings with the provider using a response descriptor
    
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [responseMapping addAttributeMappingsFromDictionary:@{@"text": @"text"}];
    
    RKResponseDescriptor *InterestResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:InterestResponseDescriptor];
    
    // Start doing some time consuming tasks like sending a request to the backend services
    
    [self sendRequest:[NSString stringWithFormat:@"api/Business/Follow/%lu", (unsigned long)businessID] Method:@"POST" Data:nil withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)unfollowBusiness:(NSUInteger)businessID withCallback:(KLCompletionBlock)callback {
    
    [self configureRestKit];
    
    // Register mappings with the provider using a response descriptor
    
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [responseMapping addAttributeMappingsFromDictionary:@{@"text": @"text"}];
    
    RKResponseDescriptor *InterestResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:InterestResponseDescriptor];
    
    // Start doing some time consuming tasks like sending a request to the backend services
    
    [self sendRequest:[NSString stringWithFormat:@"api/Business/Unfollow/%lu", (unsigned long)businessID] Method:@"POST" Data:nil withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
}
- (void)uploadBusinessPhoto:(KLPhoto *)photo business:(NSUInteger)businessID withCallback:(KLCompletionBlock)callback {
    
}

- (void)deleteBusinessPhoto:(KLPhoto *)photo business:(NSUInteger)businessID withCallback:(KLCompletionBlock)callback {
    
}

- (void)getBusinessFriends:(NSUInteger)associationID withCallback:(KLCompletionArrayBlock)callback {
    
    [self configureRestKit];
    
    // Register mappings with the provider using a response descriptor
    
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [responseMapping addAttributeMappingsFromArray:@[@"Id", @"QuickbloxUserId", @"FullName",@"PhotoUID"]];
    
    RKResponseDescriptor *InterestResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:InterestResponseDescriptor];
    
    // Start doing some time consuming tasks like sending a request to the backend services
    
    [self sendArrayRequest:[NSString stringWithFormat:@"api/Business/GetFriendsThatFollow/%lu", (unsigned long)associationID] Method:@"GET" Data:nil withCallback:^(BOOL success, NSArray *response, NSError *error) {
        callback(success, response, error);
    }];
}

#pragma mark - Group APIs

- (void)getGroupByID:(NSUInteger)groupID withCallback:(KLCompletionBlock)callback {
    [self configureRestKit];
    
    // Register mappings with the provider using a response descriptor
    
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [responseMapping addAttributeMappingsFromDictionary:@{@"UserOwner": @"UserOwner",
                                                          @"PhoneNumber": @"PhoneNumber",
                                                          @"MobileNumber": @"MobileNumber",
                                                          @"AddressLine1": @"AddressLine1",
                                                          @"AddressLine2": @"AddressLine2",
                                                          @"Suburb": @"Suburb",
                                                          @"State": @"State",
                                                          @"Country": @"Country",
                                                          @"PostCodeText": @"PostCodeText",
                                                          @"Latitude": @"Latitude",
                                                          @"Longitude": @"Longitude",
                                                          @"EmailAddress": @"EmailAddress",
                                                          @"WebAddress": @"WebAddress",
                                                          @"MainContactName": @"MainContactName",
                                                          @"BackgroundPictureBlobStorageUrl": @"BackgroundPictureBlobStorageUrl",
                                                          @"PageType": @"PageType",
                                                          @"Members": @"Members",
                                                          @"Followers": @"Followers",
                                                          @"Photos": @"Photos",
                                                          @"Id": @"Id",
                                                          @"EjabberdId": @"EjabberdId",
                                                          @"Name": @"Name",
                                                          @"ProfilePictureBlogStorageUrl": @"ProfilePictureBlogStorageUrl",
                                                          @"Interests": @"Interests", }];
    
    RKResponseDescriptor *InterestResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:InterestResponseDescriptor];
    
    // Start doing some time consuming tasks like sending a request to the backend services
    
    [self sendRequest:[NSString stringWithFormat:@"api/Group/Get/%lu", (unsigned long)groupID] Method:@"GET" Data:nil withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)followGroup:(NSUInteger)groupID withCallback:(KLCompletionBlock)callback {
    [self configureRestKit];
    
    // Register mappings with the provider using a response descriptor
    
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [responseMapping addAttributeMappingsFromDictionary:@{@"text": @"text"}];
    
    RKResponseDescriptor *InterestResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:InterestResponseDescriptor];
    
    // Start doing some time consuming tasks like sending a request to the backend services
    
    [self sendRequest:[NSString stringWithFormat:@"api/Group/Follow/%lu", (unsigned long)groupID] Method:@"POST" Data:nil withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)unfollowGroup:(NSUInteger)groupID withCallback:(KLCompletionBlock)callback {
    
    [self configureRestKit];
    
    // Register mappings with the provider using a response descriptor
    
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [responseMapping addAttributeMappingsFromDictionary:@{@"text": @"text"}];
    
    RKResponseDescriptor *InterestResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:InterestResponseDescriptor];
    
    // Start doing some time consuming tasks like sending a request to the backend services
    
    [self sendRequest:[NSString stringWithFormat:@"api/Group/Unfollow/%lu", (unsigned long)groupID] Method:@"POST" Data:nil withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)addGroupPhoto:(NSUInteger)groupID photoUID:(NSString *)photoUID withCallback:(KLCompletionBlock)callback {
    
}

- (void)deleteGroupPhoto:(NSUInteger)groupID photoUID:(NSString *)photoUID withCallback:(KLCompletionBlock)callback {
    
}

- (void)getGroupFriends:(NSUInteger)groupID withCallback:(KLCompletionArrayBlock)callback {
    [self configureRestKit];
    
    // Register mappings with the provider using a response descriptor
    
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [responseMapping addAttributeMappingsFromArray:@[@"Id", @"QuickbloxUserId", @"FullName",@"PhotoUID"]];
    
    RKResponseDescriptor *InterestResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:InterestResponseDescriptor];
    
    // Start doing some time consuming tasks like sending a request to the backend services
    
    [self sendArrayRequest:[NSString stringWithFormat:@"api/Group/GetFriendsThatFollow/%lu", (unsigned long)groupID] Method:@"GET" Data:nil withCallback:^(BOOL success, NSArray *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)searchGroupsByName:(NSString *)searchText withCallback:(KLCompletionArrayBlock)callback {
    
    [self configureRestKit];
    
    // Register mappings with the provider using a response descriptor
    
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [responseMapping addAttributeMappingsFromDictionary:@{@"UserOwner": @"UserOwner",
                                                          @"PhoneNumber": @"PhoneNumber",
                                                          @"MobileNumber": @"MobileNumber",
                                                          @"AddressLine1": @"AddressLine1",
                                                          @"AddressLine2": @"AddressLine2",
                                                          @"Suburb": @"Suburb",
                                                          @"State": @"State",
                                                          @"Country": @"Country",
                                                          @"PostCodeText": @"PostCodeText",
                                                          @"Latitude": @"Latitude",
                                                          @"Longitude": @"Longitude",
                                                          @"EmailAddress": @"EmailAddress",
                                                          @"WebAddress": @"WebAddress",
                                                          @"MainContactName": @"MainContactName",
                                                          @"BackgroundPictureBlobStorageUrl": @"BackgroundPictureBlobStorageUrl",
                                                          @"PageType": @"PageType",
                                                          @"Members": @"Members",
                                                          @"Followers": @"Followers",
                                                          @"Photos": @"Photos",
                                                          @"Id": @"Id",
                                                          @"EjabberdId": @"EjabberdId",
                                                          @"Name": @"Name",
                                                          @"ProfilePictureBlogStorageUrl": @"ProfilePictureBlogStorageUrl",
                                                          @"Interests": @"Interests", }];
    
    RKResponseDescriptor *InterestResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:InterestResponseDescriptor];
    
    // Start doing some time consuming tasks like sending a request to the backend services
    
    [self sendArrayRequest:[NSString stringWithFormat:@"api/Group/GetByName?text=%@", searchText] Method:@"GET" Data:nil withCallback:^(BOOL success, NSArray *response, NSError *error) {
        callback(success, response, error);
    }];
}

- (void)searchGroupsByInterests:(NSArray *)interestArray withCallback:(KLCompletionArrayBlock)callback {
    [self configureRestKit];
    
    // Register mappings with the provider using a response descriptor
    
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [responseMapping addAttributeMappingsFromDictionary:@{@"UserOwner": @"UserOwner",
                                                          @"PhoneNumber": @"PhoneNumber",
                                                          @"MobileNumber": @"MobileNumber",
                                                          @"AddressLine1": @"AddressLine1",
                                                          @"AddressLine2": @"AddressLine2",
                                                          @"Suburb": @"Suburb",
                                                          @"State": @"State",
                                                          @"Country": @"Country",
                                                          @"PostCodeText": @"PostCodeText",
                                                          @"Latitude": @"Latitude",
                                                          @"Longitude": @"Longitude",
                                                          @"EmailAddress": @"EmailAddress",
                                                          @"WebAddress": @"WebAddress",
                                                          @"MainContactName": @"MainContactName",
                                                          @"BackgroundPictureBlobStorageUrl": @"BackgroundPictureBlobStorageUrl",
                                                          @"PageType": @"PageType",
                                                          @"Members": @"Members",
                                                          @"Followers": @"Followers",
                                                          @"Photos": @"Photos",
                                                          @"Id": @"Id",
                                                          @"EjabberdId": @"EjabberdId",
                                                          @"Name": @"Name",
                                                          @"ProfilePictureBlogStorageUrl": @"ProfilePictureBlogStorageUrl",
                                                          @"Interests": @"Interests", }];
    
    RKResponseDescriptor *InterestResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:InterestResponseDescriptor];
    
    // Start doing some time consuming tasks like sending a request to the backend services
    
    [self sendArrayRequest:@"api/Group/GetByInterests" Method:@"GET" Data:[self getDictionaryFromArray:interestArray]  withCallback:^(BOOL success, NSArray *response, NSError *error) {
        callback(success, response, error);
    }];
}

@end

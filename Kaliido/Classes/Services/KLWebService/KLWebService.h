//
//  KLAuthWebService.h
//  Kaliido
//
//  Created by Robbie Tapping on 8/08/2015.
//  Copyright (c) 2015 Kaliido. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KLAccessTokenResponse.h"
#import <RestKit/RestKit.h>
#import "KLStumblerModel.h"
#import "DirectoryViewModel.h"
#import "KLAssociation.h"
#import "KLPhoto.h"
#import "KLBusiness.h"
#import "KLInterestID.h"
@interface KLWebService : NSObject

//#define kBASEAUTHURL @"https://kaliido-resource.azurewebsites.net/"
#define kBASERESOURCEURL @"http://kaliido-test-resource-api.azurewebsites.net/"
#define kCLIENTID @"KaliidoIOSClient"
#define kCLIENTSECRET @""

@property (nonatomic, strong) KLAccessTokenResponse *sessionInformation;
@property (nonatomic, strong) NSDictionary *userDictionary;
@property (nonatomic, strong) RKObjectManager *objectManager;
@property (nonatomic, strong) NSArray *users;


typedef void (^KLCompletionBlock)(BOOL success, NSDictionary *response, NSError *error);
typedef void (^KLCompletionArrayBlock)(BOOL success, NSArray *response, NSError *error);
typedef void(^KLContentProgressBlock)(float progress);

+ (KLWebService*)getInstance;

- (void)configureRestKit;
- (void)sendRequest:(NSString*)url Method:(NSString*)method Data:(NSDictionary *)data withCallback:(KLCompletionBlock) callback;
- (void)sendArrayRequest:(NSString*)url Method:(NSString*)method Data:(NSDictionary *)data withCallback:(KLCompletionArrayBlock) callback;

// User Profile APIs

- (void)getProfile:(NSString*)token withCallback:(KLCompletionBlock)callback;
- (void)updateProfile:(NSDictionary *)userProfile withCallback:(KLCompletionBlock)callback;
- (void)setPassword:(NSString *)password withCallback:(KLCompletionBlock)callback;
- (void)changePassword:(NSString *)password oldPassword:(NSString *)oldPassword withCallback:(KLCompletionBlock)callback;
- (void)updateUserFullName:(NSString *)username withCallback:(KLCompletionBlock)callback;
- (void)updateUserAboutMe:(NSString *)aboutme withCallback:(KLCompletionBlock)callback;
- (void)updateUserHeadLine:(NSString *)headLine withCallback:(KLCompletionBlock)callback;
- (void)updateUserAge:(int)age isShown:(BOOL)isShow withCallback:(KLCompletionBlock)callback;
- (void)updateUserBirthDate:(NSString*)birthDate isShown:(BOOL)isShow withCallback:(KLCompletionBlock)callback;
- (void)updateUserRelationShip:(int)Id withCallback:(KLCompletionBlock)callback;
- (void)addUserInterest:(int)Id withCallback:(KLCompletionBlock)callback;
- (void)deleteUserInterest:(int)Id withCallback:(KLCompletionBlock)callback;
- (void)addUserLookingFor:(int)Id withCallback:(KLCompletionBlock)callback;
- (void)deleteUserLookingFor:(int)Id withCallback:(KLCompletionBlock)callback;
- (void)updateUserPhotoUID:(NSString *)photoUID withCallback:(KLCompletionBlock)callback;
- (void)updateUserMakeDelux:(NSString *)makeDelux withCallback:(KLCompletionBlock)callback;
- (void)updateUserCharity:(int)Id withCallback:(KLCompletionBlock)callback;
- (void)removeUserCharity:(int)Id withCallback:(KLCompletionBlock)callback;
- (void)updatePersonalityType:(int)personalityType withCallback:(KLCompletionBlock)callback;
- (void)getUserCharities:(KLCompletionArrayBlock)callback;

// User APIs

- (void)getLookingFors:(KLCompletionArrayBlock)callback;
- (void)getRelationshipTypes:(KLCompletionArrayBlock)callback;

- (void)blockUser:(int)userId withCallback:(KLCompletionBlock)callback;
- (void)updateUserNote:(NSString*)note UserId:(int)userId withCallback:(KLCompletionBlock)callback;
- (void)updateUserLocation:(NSMutableDictionary*)location  withCallback:(KLCompletionBlock)callback;

- (void)getUsersClosestByDistance:(int)distance latitude:(double)lat longitude:(double)lng withCallback:(KLCompletionArrayBlock)callback;
- (void)getUsersClosestByDistance:(int)distance withCallback:(KLCompletionArrayBlock)callback;
- (void)getUserSearchByInterests:(NSArray*)IdArray withCallback:(KLCompletionArrayBlock)callback;
- (void)getAllFavourites:(KLCompletionArrayBlock)callback;
- (void)getUsersByName:(NSString*)name withCallback:(KLCompletionArrayBlock)callback;
- (void)getUsersByName:(NSString*)name searchArea:(NSString*)area withCallback:(KLCompletionArrayBlock)callback;
- (void)getUserById:(int)userId withCallback:(KLCompletionBlock)callback;
- (void)getFullInfoByEjabberdUserIds:(NSArray*)IdArray withCallback:(KLCompletionArrayBlock)callback;
- (void)getFullInfoByUserIds:(NSArray*)IdArray withCallback:(KLCompletionArrayBlock)callback;
- (void)getShortInfoByUserIds:(NSArray*)IdArray withCallback:(KLCompletionArrayBlock)callback;
- (void)addFavorite:(int)userId withCallback:(KLCompletionBlock)callback;
- (void)removeFavorite:(int)userId withCallback:(KLCompletionBlock)callback;
- (void)sendFriendRequest:(NSUInteger)friendID message:(NSString *)message withCallback:(KLCompletionBlock)callback;
- (void)acceptFriendRequest:(NSUInteger)requesterID message:(NSString *)message withCallback:(KLCompletionBlock)callback;
- (void)declineFriendRequest:(NSUInteger)requesterID message:(NSString *)message withCallback:(KLCompletionBlock)callback;
- (void)getUserListWithFriendRequest:(KLCompletionArrayBlock)callback;

// Stumbler APIs

- (void)getStumblerById:(int)Id withCallback:(KLCompletionBlock)callback;
- (void)getMyStumbler:(KLCompletionArrayBlock)callback;
- (void)getStumblerByName:(NSString*)name withCallback:(KLCompletionArrayBlock)callback;

- (void)createStumbler:(KLStumblerModel*)stumbler withCallback:(KLCompletionBlock)callback;

- (void)addAttendee:(int)Id withCallback:(KLCompletionBlock)callback;
- (void)removeAttendee:(int)Id withCallback:(KLCompletionBlock)callback;
- (void)inviteStumbler:(int)Id withCallback:(KLCompletionBlock)callback;
- (void)gotoStumbler:(int)Id withCallback:(KLCompletionBlock)callback;
- (void)maybeGotoStumbler:(int)Id withCallback:(KLCompletionBlock)callback;
- (void)likeAttendee:(int)Id withCallback:(KLCompletionBlock)callback;
- (void)addCommentAttendee:(int)Id comment:(NSString*)comment withCallback:(KLCompletionBlock)callback;

- (void)getSearchByCategoryId:(int)Id withCallback:(KLCompletionArrayBlock)callback;
- (void)getSearchByCategories:(NSArray*)IdArray withCallback:(KLCompletionArrayBlock)callback;
- (void)getSearchBySubCategories:(NSArray*)IdArray withCallback:(KLCompletionArrayBlock)callback;
- (void)getFutureByStatus:(int)status withCallback:(KLCompletionArrayBlock)callback;
- (void)getStumblerAllPast:(KLCompletionArrayBlock)callback;
- (void)getStumblerAllPastHosted:(KLCompletionArrayBlock)callback;
- (void)getStumblerAllFutureHosted:(KLCompletionArrayBlock)callback;
- (void)addStumblerId:(int)stumblerId attendeeId:(int)Id withCallback:(KLCompletionBlock)callback;
- (void)getStumblerCategoryAll:(KLCompletionArrayBlock)callback;
- (void)getStumblerSubCategory:(int)Id withCallback:(KLCompletionArrayBlock)callback;

// Charity APIs

- (void)getCharity:(KLCompletionArrayBlock)callback;

// PersonalityTypes API

- (void)getPersonalityTypes:(KLCompletionArrayBlock)callback;

// Interests API

- (void)getInterests:(KLCompletionArrayBlock)callback;
- (void)getCategory:(int)Id withCallback:(KLCompletionArrayBlock)callback;

// Storage APIs

- (void)fileUpload:(NSData*) data storageName:(NSString*)storageName progress:(KLContentProgressBlock)progress withCallback:(KLCompletionBlock)callback;
- (void)fileUploadVideo:(NSData*) data storageName:(NSString*)storageName progress:(KLContentProgressBlock)progress withCallback:(KLCompletionBlock)callback;

// Notification APIs

- (void)getNotificationId:(NSString *)pushHandle withCallback:(KLCompletionBlock)callback;
- (void)registserNotification:(NSString *)registrationId pushHandle:(NSString *)handle tags:(NSArray *)tags withCallback:(KLCompletionBlock)callback;
- (void)testNotificationToTags:(NSString *)message tags:(NSArray *)tags;
- (void)testNotificationToSelf:(NSString *)message tags:(NSArray *)tags;

// Association APIs

- (void)setAssociationActive:(NSUInteger)associationId isActive:(BOOL)isActive withCallback:(KLCompletionBlock)callback;
- (void)createAssociation:(KLAssociation *)association withCallback:(KLCompletionBlock)callback;
- (void)editAssociation:(KLAssociation *)association withCallback:(KLCompletionBlock)callback;
- (void)addAssociationMemebers:(NSArray *)userIDArray association:(NSUInteger)associationID withCallback:(KLCompletionBlock)callback;
- (void)removAssociationMembers:(NSArray *)userIDArray association:(NSUInteger)associationID withCallback:(KLCompletionBlock)callback;
- (void)addAssociationInterests:(NSArray *)interests association:(NSUInteger)associationID withCallback:(KLCompletionBlock)callback;
- (void)removAssociatioInterests:(NSArray *)interests association:(NSUInteger)associationID withCallback:(KLCompletionBlock)callback;
- (void)uploadAssociationPhoto:(KLPhoto *)photo association:(NSUInteger)associationID withCallback:(KLCompletionBlock)callback;
- (void)deleteAssociationPhoto:(KLPhoto *)photo association:(NSUInteger)associationID withCallback:(KLCompletionBlock)callback;
- (void)getAssociationById:(NSUInteger)associationID withCallback:(KLCompletionBlock)callback;
- (void)followAssociation:(NSUInteger)associationID withCallback:(KLCompletionBlock)callback;
- (void)unfollowAssociation:(NSUInteger)associationID withCallback:(KLCompletionBlock)callback;
- (void)getAssociationFriends:(NSUInteger)associationID withCallback:(KLCompletionArrayBlock)callback;
- (void)getAssociationByName:(NSString *)searchText withCallback:(KLCompletionArrayBlock)callback ;
- (void)getAssociationInterests:(NSUInteger)associationID withCallback:(KLCompletionBlock)callback;
- (void)deleteAssociation:(NSUInteger)associationID withCallback:(KLCompletionBlock)callback;
- (void)getAssociationByInterests:(NSArray *)interests withCallback:(KLCompletionBlock)callback;

// Page APIs

- (void)addPagePhoto:(NSUInteger)pageID photoUID:(NSString *)photoUID withCallback:(KLCompletionBlock)callback;
- (void)removePagePhoto:(NSUInteger)pageID photoUID:(NSString *)photoUID withCallback:(KLCompletionBlock)callback;
- (void)getPageFriends:(NSUInteger)pageID withCallback:(KLCompletionArrayBlock)callback;
- (void)searchPagesByName:(NSString *)searchText withCallback:(KLCompletionArrayBlock)callback;
- (void)getPageByID:(NSUInteger)pageID withCallback:(KLCompletionBlock)callback;
- (void)followPage:(NSUInteger)pageID withCallback:(KLCompletionBlock)callback;
- (void)unfollowPage:(NSUInteger)pageID withCallback:(KLCompletionBlock)callback;
- (void)getPageByInterests:(NSArray *)interestArray withCallback:(KLCompletionArrayBlock)callback;
//Business type API
- (void)getBusinessTypes:(KLCompletionArrayBlock)callback ;
// Business APIs

- (void)setBusinessActive:(NSUInteger)businessID isActive:(BOOL)isActive withCallback:(KLCompletionBlock)callback;
- (void)searchBusinessByName:(NSString *)searchText withCallback:(KLCompletionArrayBlock)callback;
- (void)searchBusinessByInterests:(NSArray *)interestArray withCallback:(KLCompletionArrayBlock)callback;
- (void)createBusiness:(KLBusiness *)business withCallback:(KLCompletionBlock)callback;
- (void)editBusiness:(KLBusiness *)business withCallback:(KLCompletionBlock)callback;
- (void)addBusinessStaffs:(NSMutableArray *)staffs business:(NSUInteger)businessID withCallback:(KLCompletionBlock)callback;
- (void)removeBusinessStaffs:(NSMutableArray *)staffs business:(NSUInteger)businessID withCallback:(KLCompletionBlock)callback;
- (void)addBusinessInterests:(NSMutableArray *)interests business:(NSUInteger)businessID withCallback:(KLCompletionBlock)callback;
- (void)removeBusinessInterests:(NSMutableArray *)interests business:(NSUInteger)businessID withCallback:(KLCompletionBlock)callback;
- (void)getBusinessByInterests:(NSMutableArray *)interests withCallback:(KLCompletionArrayBlock)callback;
- (void)getBusinessByID:(NSUInteger)businessID withCallback:(KLCompletionBlock)callback;
- (void)followBusiness:(NSUInteger)businessID withCallback:(KLCompletionBlock)callback;
- (void)unfollowBusiness:(NSUInteger)businessID withCallback:(KLCompletionBlock)callback;
- (void)uploadBusinessPhoto:(KLPhoto *)photo business:(NSUInteger)businessID withCallback:(KLCompletionBlock)callback;
- (void)deleteBusinessPhoto:(KLPhoto *)photo business:(NSUInteger)businessID withCallback:(KLCompletionBlock)callback;
- (void)getBusinessFriends:(NSUInteger)associationID withCallback:(KLCompletionArrayBlock)callback;


// Group APIs

- (void)getGroupByID:(NSUInteger)groupID withCallback:(KLCompletionBlock)callback;
- (void)followGroup:(NSUInteger)groupID withCallback:(KLCompletionBlock)callback;
- (void)unfollowGroup:(NSUInteger)groupID withCallback:(KLCompletionBlock)callback;
- (void)addGroupPhoto:(NSUInteger)groupID photoUID:(NSString *)photoUID withCallback:(KLCompletionBlock)callback;
- (void)deleteGroupPhoto:(NSUInteger)groupID photoUID:(NSString *)photoUID withCallback:(KLCompletionBlock)callback;
- (void)getGroupFriends:(NSUInteger)groupID withCallback:(KLCompletionArrayBlock)callback;
- (void)searchGroupsByName:(NSString *)searchText withCallback:(KLCompletionArrayBlock)callback;
- (void)searchGroupsByInterests:(NSArray *)interestArray withCallback:(KLCompletionArrayBlock)callback;


@end

//
//  KLServicesFacade.m
//  Kaliido
//
//  Created by Daron on 01.07.14.
//  Copyright (c) 2014 Kaliido. All rights reserved.
//

#import "KLApi.h"

#import "KLSettingsManager.h"
//#import "KLUsersService.h"
//#import "KLChatDialogsService.h"
//#import "KLContentService.h"
//#import "KLAVCallManager.h"
//#import "KLMessagesService.h"
#import "REAlertView+KLSuccess.h"
//#import "KLChatReceiver.h"
#import "Reachability.h"
//#import "KLPopoversFactory.h"
#import "MainTabBarController.h"
//#import "ChatViewController.h"
#import "ECSlidingViewController.h"

const NSTimeInterval kKLPresenceTime = 30;

@interface KLApi()


@property (strong, nonatomic) KLSettingsManager *settingsManager;
//@property (strong, nonatomic) KLUsersService *usersService;
//@property (strong, nonatomic) KLAVCallManager *avCallManager;
//@property (strong, nonatomic) KLChatDialogsService *chatDialogsService;
//@property (strong, nonatomic) KLMessagesService *messagesService;
//@property (strong, nonatomic) KLChatReceiver *responceService;
//@property (strong, nonatomic) KLContentService *contentService;
@property (strong, nonatomic) Reachability *internetConnection;
@property (strong, nonatomic) NSTimer *presenceTimer;

@property (nonatomic) dispatch_group_t group;

@end

@implementation KLApi

static KLApi *servicesFacade = nil;
+ (instancetype)instance {
    
    

    if (servicesFacade != nil) {
        return servicesFacade;
    }
    
    servicesFacade = [[self alloc] init];
    
    
    
    return servicesFacade;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        
        
        self.settingsManager = [[KLSettingsManager alloc] init];
        
        self.internetConnection = [Reachability reachabilityForInternetConnection];
    
        __weak typeof(self)weakSelf = self;
        
        void (^internetConnectionBlock)(Reachability *reachability) = ^(Reachability *reachability) {
            dispatch_async(dispatch_get_main_queue(), ^{
//                [[KLChatReceiver instance] internetConnectionIsActive:reachability.isReachable];
            });
        };
        
        self.internetConnection.reachableBlock = internetConnectionBlock;
        self.internetConnection.unreachableBlock = internetConnectionBlock;
//        
//        [[KLChatReceiver instance] chatDidFailWithTarget:self block:^(NSError *error) {
//            // some
//            [REAlertView showAlertWithMessage:NSLocalizedString(@"KL_STR_CHECK_INTERNET_CONNECTION", nil) actionSuccess:NO];
//        }];
//        
        
        // XMPP Chat messaging handling
        
//        void (^updateHistory)(QBChatMessage *) = ^(QBChatMessage *message) {
//            
//            if (message.cParamNotificationType == KLMessageNotificationTypeSendContactRequest) {
//                return;
//            }
//            if (message.recipientID != message.senderID) {
//                if (message.cParamNotificationType == KLMessageNotificationTypeCreateGroupDialog && !message.cParamSaveToHistory) {
//                    return;
//                }
//                [weakSelf.messagesService addMessageToHistory:message withDialogID:message.cParamDialogID];
//            }
//        };
        
//        [[KLChatReceiver instance] chatDidReceiveMessageWithTarget:self block:^(QBChatMessage *message) {
//            // message service update:
//            updateHistory(message);
//            
//            // dialogs service update:
//            [weakSelf.chatDialogsService updateOrCreateDialogWithMessage:message isMine:(message.senderID == weakSelf.currentUser.ID)];
//            
//            // fire chatAfterDidReceiveMessage for other cases:
//            if (message.cParamNotificationType == KLMessageNotificationTypeSendContactRequest) {
//                [weakSelf retriveUsersForNotificationIfNeeded:message];
//            }
//            
//            // users
//            if (message.cParamNotificationType == KLMessageNotificationTypeDeleteContactRequest) {
//                BOOL contactWasDeleted = [weakSelf.usersService deleteContactRequestUserID:message.senderID];
//                if (contactWasDeleted) {
//                    [[KLChatReceiver instance] contactRequestUsersListChanged];
//                }
//            }
//        }];
        
//        [[KLChatReceiver instance] chatRoomDidReceiveMessageWithTarget:self block:^(QBChatMessage *message, NSString *roomJID) {
//
//            
//            if (message.cParamNotificationType == KLMessageNotificationTypeCreateGroupDialog) {
//                void (^DeliveryBlock)(NSError *error) = weakSelf.messagesService.messageDeliveryBlockList[roomJID];
//                if (DeliveryBlock) {
//                    [weakSelf.messagesService.messageDeliveryBlockList removeObjectForKey:roomJID];
//                    DeliveryBlock(nil);
//                }
//            }
//            updateHistory(message);
//            
//            // check for chat dialog:
//            [weakSelf.chatDialogsService updateOrCreateDialogWithMessage:message isMine:(message.senderID == weakSelf.currentUser.ID)];
//            
//            // check users if needed:
//            if (message.cParamNotificationType == KLMessageNotificationTypeCreateGroupDialog) {
//                [weakSelf retriveUsersForNotificationIfNeeded:message];
//            } else if (message.cParamNotificationType == KLMessageNotificationTypeUpdateGroupDialog) {
//                if (message.cParamDialogOccupantsIDs.count > 0) {
//                    [weakSelf retriveUsersForNotificationIfNeeded:message];
//                    return;
//                }
//                [weakSelf.messagesService addMessageToHistory:message withDialogID:message.cParamDialogID];
//                [[KLChatReceiver instance] chatAfterDidReceiveMessage:message];
//            }
//        }];
    }
    
    [self.internetConnection startNotifier];
    
    return self;
}

- (void)setCurrentUser:(KLUser *)currentUser {
//    self.messagesService.currentUser = currentUser;
    if (!currentUser) {
        self.userAuthObject = currentUser;
    } else {
        self.userAuthObject = currentUser;
    }
}

- (KLUser *)currentUser {
    
    if(self.userAuthObject != nil)
    return self.userAuthObject;

    return nil;
}

- (void)startServices {
    
    
//    [self.messagesService start];
//    [self.usersService start];
//    [self.chatDialogsService start];
//    [self.avCallManager start];
}

- (void)stopServices {
    
    
//    [self.usersService stop];
//    [self.chatDialogsService stop];
//    [self.messagesService stop];
//    [self.avCallManager stop];
}

- (void)fetchAllHistory:(void(^)(void))completion {
//    /**
//     Feach Dialogs
//     */
//    __weak __typeof(self)weakSelf = self;
//    [self fetchAllDialogs:^{
//        
//        NSArray *allOccupantIDs = [weakSelf allOccupantIDsFromDialogsHistory];
//        
//        [weakSelf.usersService retrieveUsersWithIDs:allOccupantIDs completion:^(BOOL updated) {
//            completion();
//        }];
//    }];
}

//- (void)retriveUsersForNotificationIfNeeded:(QBChatMessage *)notification
//{
//    __weak typeof(self)weakSelf = self;
//    NSArray *idsToFetch = nil;
//    if (notification.cParamNotificationType == KLMessageNotificationTypeSendContactRequest) {
//        idsToFetch = @[@(notification.senderID)];
//    } else {
//        idsToFetch = notification.cParamDialogOccupantsIDs;
//    }
//    [self retriveIfNeededUsersWithIDs:idsToFetch completion:^(BOOL retrieveWasNeeded) {
//        [weakSelf.messagesService addMessageToHistory:notification withDialogID:notification.cParamDialogID];
//        [[KLChatReceiver instance] chatAfterDidReceiveMessage:notification];
//    }];
//}
//
//- (BOOL)checkResult:(NSResult *)result {
//
//    if (!result.success) {
//		if( [result isKindOfClass:[KLUserLogInResult class]] ){
//			[REAlertView showAlertWithMessage:@"Incorrect Username or Password" actionSuccess:NO];
//		}
//		else{
//			[REAlertView showAlertWithMessage:result.errors.lastObject actionSuccess:NO];
//		}
//    }
//    
//    return result.success;
//}

- (BOOL)isInternetConnected
{
    return self.internetConnection.isReachable;
}



@end

//
//  KLXMPPTool.h
//  Kaliido
//
//  Created by Learco R on 8/6/2016.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"
@interface KLXMPPTool : NSObject<XMPPStreamDelegate,UIAlertViewDelegate,XMPPRosterDelegate,XMPPRosterMemoryStorageDelegate>

@property (nonatomic, strong) XMPPStream *xmppStream;

@property (nonatomic, strong) XMPPAutoPing *xmppAutoPing;
@property (nonatomic, strong) XMPPReconnect *xmppReconnect;

@property (nonatomic, strong) XMPPRoster *xmppRoster;
@property (nonatomic, strong) XMPPRosterMemoryStorage *xmppRosterMemoryStorage;

@property (nonatomic, strong) XMPPUserCoreDataStorageObject *userCoreDataStorage;

@property (nonatomic, strong) XMPPMessageArchiving *xmppMessageArchiving;
@property (nonatomic, strong) XMPPMessageArchivingCoreDataStorage *xmppMessageArchivingCoreDataStorage;

@property (nonatomic, strong) NSMutableDictionary* friendOnlineDict;


@property (nonatomic, assign) BOOL  xmppNeedRegister;
@property (nonatomic, copy)   NSString *myPassword;

@property (nonatomic, strong) XMPPPresence *receivePresence;

+ (instancetype)sharedInstance;
- (void)loginWithJID:(XMPPJID *)JID andPassword:(NSString *)password;
- (void)registerWithJID:(XMPPJID *)JID andPassword:(NSString *)password;
- (NSManagedObjectContext *)managedObjectContext_roster;
- (void)addFriend:(XMPPJID *)aJID;

- (void)goOnline;
- (void)goOffline ;
- (void) disconnectXMPP;
@end
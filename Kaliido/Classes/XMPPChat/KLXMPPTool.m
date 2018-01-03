//
//  KLXMPPTool.m
//  Kaliido
//
//  Created by Learco R on 8/6/2016.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "KLXMPPTool.h"
#import "MPGNotification.h"
#import "NSString+Utils.h"

@implementation KLXMPPTool

static KLXMPPTool *_instance;
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [KLXMPPTool new];
        
    });
    
    return _instance;
}

- (XMPPStream *)xmppStream
{
    if (!_xmppStream) {
        _xmppStream = [[XMPPStream alloc] init];
        
        // Socket when connected to know host port and then connect
        [self.xmppStream setHostName:kXMPP_HOST];
        [self.xmppStream setHostPort:kXMPP_PORT];
        //Why is addDelegate? Because xmppFramework extensive use of multicast proxy multicast-delegate, the agent is generally 1 to 1, but the multicast proxy is too many, and can be added or removed at any time
        [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        //Add-On Modules
        //1.autoPing When sending a stream: ping each other if you want to indicate that they are active and should return a pong
        _xmppAutoPing = [[XMPPAutoPing alloc] init];
        //All Module module must activate the active
        [_xmppAutoPing activate:self.xmppStream];
        
        //autoPing because it will periodically send a ping, ask for the return of pong, so this time we need to set
        [_xmppAutoPing setPingInterval:1000];
        //Not just in response to the server; if an ordinary user, they would respond
        [_xmppAutoPing setRespondsToQueries:YES];
        //This process is C ----> S; observe S ---> C (need server settings)
        
        //2.autoReconnect automatically reconnect when we were disconnected, reconnect automatically go up, and the last time the information is automatically added to
        _xmppReconnect = [[XMPPReconnect alloc] init];
        [_xmppReconnect activate:self.xmppStream];
        [_xmppReconnect setAutoReconnect:YES];
        
        
        // 3.Friends module support our management, synchronization, application, delete friends
        _xmppRosterMemoryStorage = [[XMPPRosterMemoryStorage alloc] init];
        
        _xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:_xmppRosterMemoryStorage];
        
        [_xmppRoster activate:self.xmppStream];
        
        //While giving _xmppRoster MemoryStorage agent are added and xmppRoster
        [_xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
        //Friends synchronization policy setting, XMPP Once connected, synchronized to the local Friends
        [_xmppRoster setAutoFetchRoster:YES]; //
        //Turn off automatically receive friend requests enabled by default automatically agree
        [_xmppRoster setAutoAcceptKnownPresenceSubscriptionRequests:YES];
        [_xmppRoster setAutoClearAllUsersAndResources:NO];
        
        
       
        

        //4. The message module, where a single example, can not switch account login, otherwise there will be data problems.
        _xmppMessageArchivingCoreDataStorage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
        _xmppMessageArchiving = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:_xmppMessageArchivingCoreDataStorage dispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 9)];
        [_xmppMessageArchiving activate:self.xmppStream];
        
        _friendOnlineDict = [NSMutableDictionary dictionary];
    }
    return _xmppStream;
}

- (void)loginWithJID:(XMPPJID *)JID andPassword:(NSString *)password
{
    // 1. Establish a TCP connection
         // 2. My own jid bind to this TCP connection
         // 3. Authentication (login: Verification jid and password are correct encryption can not be sent in clear text) - (attendance: How do I tell the server on-line, on-line and I have to state
         // This sentence will in future xmppStream send XML when adding <message from = "JID">
    [self.xmppStream setMyJID:JID];
    self.myPassword = password;
    self.xmppNeedRegister = YES;
    
    [self.xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:nil];
}

// There is no registration method call auth method
- (void)registerWithJID:(XMPPJID *)JID andPassword:(NSString *)password
{
    [self.xmppStream setMyJID:JID];
    self.myPassword = password;
    self.xmppNeedRegister = YES;
    
    
    
    
    
    [self.xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:nil];
}

- (void)addFriend:(XMPPJID *)aJID
{
    //Here is my nickname it notes, he was not too nickname profile
    [self.xmppRoster addUser:aJID withNickname:@"Friends"];
}



- (void)goOnline {
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"available"];
    [[self xmppStream] sendElement:presence];
}

- (void)goOffline {
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [[self xmppStream] sendElement:presence];
}

- (void)disconnect {
    
    [self goOffline];
    [self.xmppStream disconnect];
    
}


#pragma mark ===== XMPPStream delegate =======
//socket The connection is established
- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket
{
    NSLog(@"%s",__func__);
}

//This is the xml stream initialization is successful
- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    if (self.xmppNeedRegister) {
        BOOL result = [self.xmppStream registerWithPassword:self.myPassword error:nil];
        NSNumber *number = [NSNumber numberWithBool:result];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kREGIST_RESULT object:number];
        
        double delayInSeconds = 1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.xmppStream authenticateWithPassword:self.myPassword error:nil];
        });
        
        
    } else {
        [self.xmppStream authenticateWithPassword:self.myPassword error:nil];
    }
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    NSLog(@"%s",__func__);
}

//Login failed
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    NSLog(@"%s",__func__);
}

//login successful
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    [self goOnline];
    
    NSLog(@"=========== XMPP LOGIN SUCCESS ==============");
    [[NSNotificationCenter defaultCenter] postNotificationName:kLOGIN_SUCCESS object:nil];
}

#pragma mark ===== Friends module commission=======
/** Received attend subscription request (on behalf of the other party want to add yourself as a friend) */
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
    //Add Friend will subscribe to each other, but do not have to accept the subscription add each other as friends
    self.receivePresence = presence;
//    
//    NSString *message = [NSString stringWithFormat:@"【%@】I want to add you as a friend",presence.from.bare];
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"Refuse" otherButtonTitles:@"agree", nil];
//    [alertView show];
    
    [self.xmppRoster acceptPresenceSubscriptionRequestFrom:_receivePresence.from andAddToRoster:YES];
    
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
    
    
    NSString *presenceType = [presence type]; // online/offline
    NSString *myUsername = [[sender myJID] user];
    NSString *presenceFromUser = [[presence from] user];
    
    if (![presenceFromUser isEqualToString:myUsername]) {
        
        if ([presenceType isEqualToString:@"available"]) {
            
            [_friendOnlineDict setObject:@"online" forKey:presenceFromUser];
            
        } else if ([presenceType isEqualToString:@"unavailable"]) {
            
            [_friendOnlineDict setObject:@"offline" forKey:presenceFromUser];
            
        } else if ([presenceType isEqualToString:@"unsubscribe"])
        {
            [self.xmppRoster removeUser:presence.from];
            [_friendOnlineDict removeObjectForKey:presenceFromUser];
        }
        
    }

    
}

/**
 * Start the synchronization server sends back its own buddy list
 **/
- (void)xmppRosterDidBeginPopulating:(XMPPRoster *)sender
{
    
}

/**
 * End synchronization
 **/
//IQ will receive buddy list entry method, and has been stored in my memory
- (void)xmppRosterDidEndPopulating:(XMPPRoster *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kXMPP_ROSTER_CHANGE object:nil];
}

//Each received a friend
- (void)xmppRoster:(XMPPRoster *)sender didReceiveRosterItem:(NSXMLElement *)item
{
    
}

//If not the initial synchronization to roster, it will be automatically stored in the memory of my friend
- (void)xmppRosterDidChange:(XMPPRosterMemoryStorage *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kXMPP_ROSTER_CHANGE object:nil];
}

#pragma mark - Message
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    NSLog(@"%s--%@",__FUNCTION__, message);
    //XEP - 0136 has been realized with coreData receiving and storing data
    NSString *msg = [[message elementForName:@"body"] stringValue];
    NSString *from = [[message attributeForName:@"from"] stringValue];
    if (from == nil || msg == nil) {
        return;
    }
    NSMutableDictionary *m = [[NSMutableDictionary alloc] init];
    
    [m setObject:msg forKey:@"msg"];
    [m setObject:from forKey:@"sender"];
    [m setValue:[message name] forKey:@"name"];
    [m setValue:[message nick] forKey:@"nick"];
   [m setValue:[message subject] forKey:@"subject"];
     [m setValue:[message body] forKey:@"body"];
    [m setValue:[[message from] bareJID] forKey:@"fromJid"];

    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kMESSAGE_RECEIVED object:nil userInfo:m];
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
    NSXMLElement *queryElement = [iq elementForName: @"query" xmlns: @"jabber:iq:roster"];
    if (queryElement)
    {
        NSArray *itemElements = [queryElement elementsForName: @"item"];
        for (int i=0; i<[itemElements count]; i++)
        {
            NSLog(@"Friend: %@",[[itemElements[i] attributeForName:@"jid"]stringValue]);
            
        }
    }
    return NO;
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"0000");
        [self.xmppRoster rejectPresenceSubscriptionRequestFrom:_receivePresence.from];
    } else {
        [self.xmppRoster acceptPresenceSubscriptionRequestFrom:_receivePresence.from andAddToRoster:YES];
    }
}
- (void) disconnectXMPP
{
    [self.xmppStream removeDelegate:self];
    [self.xmppReconnect deactivate];
    [_xmppAutoPing deactivate];
    [_xmppRoster removeDelegate:self];
    [_xmppRoster deactivate];
    [_xmppMessageArchiving removeDelegate:self];
    [_xmppMessageArchiving deactivate];
    
    [self.xmppStream disconnect];
    
    _xmppStream = nil;
    _xmppReconnect = nil;
    _xmppRoster = nil;
    _xmppReconnect = nil;
    _xmppAutoPing = nil;
    _xmppMessageArchiving = nil;
    
}

@end

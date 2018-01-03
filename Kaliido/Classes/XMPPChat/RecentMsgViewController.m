//
//  RecentMsgViewController.m
//  XMPPChat
//
//  Hiba on 6/20/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "RecentMsgViewController.h"
#import "ChatViewController.h"
#import "KLRecentChatListCell.h"
#import "XMPPMessageArchiving_Contact_CoreDataObject.h"
#import "XMPPRosterCoreDataStorage.h"
#import "KLXMPPTool.h"
#import "UIViewController+ECSlidingViewController.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "KLWebService.h"
@interface RecentMsgViewController ()
<UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate>
{
    NSFetchedResultsController *_fetchedResultsController;
    NSFetchedResultsController *_fetchedUserResultsController;
    
}
@property (retain, nonatomic) UIRefreshControl *refreshControl ;
@end

@implementation RecentMsgViewController

- (void)FetchFriends
{
    NSString* userId = [NSString stringWithFormat:@"%@", [[KLUser.currentUser getUserDic] objectForKey:@"quickbloxUserId"]];
    XMPPJID *ejabberdUserID = [XMPPJID jidWithUser:userId domain:@"klsocial.404la.be" resource:@"Kaliido-App-iOS-v1.0"];
    
    
    NSError *error = [[NSError alloc] init];
    NSXMLElement *query = [[NSXMLElement alloc] initWithXMLString:@"<query xmlns='jabber:iq:roster'/>"error:&error];
    NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
    [iq addAttributeWithName:@"type" stringValue:@"get"];
    [iq addAttributeWithName:@"id" stringValue:ejabberdUserID.bareJID.user];
    [iq addAttributeWithName:@"from" stringValue:ejabberdUserID.bare];
    [iq addChild:query];
    [[KLXMPPTool sharedInstance].xmppStream sendElement:iq];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}




#pragma mark -
#pragma mark loadView



- (void)initRightBarButton
{
    UIImage *image = [UIImage imageNamed:@"Add"];
    UIButton *buton = [UIButton buttonWithType:UIButtonTypeCustom];
    [buton setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [buton setBackgroundImage:image forState:UIControlStateNormal];
    [buton addTarget:self action:@selector(clickToChatWithBuddy) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:buton];
}

//
//-(XMPPUserCoreDataStorageObject*) getUserProfileFromXMPPCoreData:(XMPPJID*) jid
//{
//    XMPPUserCoreDataStorageObject *user = [[KLXMPPTool sharedInstance].xmppRosterStorage userForJID:jid
//                                                             xmppStream:[KLXMPPTool sharedInstance].xmppStream
//                                                   managedObjectContext:[[KLXMPPTool sharedInstance] managedObjectContext_roster]];
//    
//    return user;
//
//}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (nil != _fetchedResultsController)
    {
        return _fetchedResultsController;
    }
    
    XMPPMessageArchivingCoreDataStorage *storage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
    NSManagedObjectContext *moc = [storage mainThreadManagedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Contact_CoreDataObject"
                                                         inManagedObjectContext:moc];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    [fetchRequest setEntity:entityDescription];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"mostRecentMessageTimestamp" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    
    
    
    NSString *streamBareJidStr = [KLXMPPTool sharedInstance].xmppStream.myJID.bare;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"streamBareJidStr == %@",streamBareJidStr];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setFetchBatchSize:20];
    
    //    NSArray *array = [moc executeFetchRequest:fetchRequest error:nil];
    //    NSLog(@"---%s--%@",__FUNCTION__,array);
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                    managedObjectContext:moc
                                                                      sectionNameKeyPath:nil
                                                                               cacheName:nil];
    _fetchedResultsController.delegate = self;
    
    NSError *error = nil;
    if (![_fetchedResultsController performFetch:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    return _fetchedResultsController;
}
- (int)getUnreadMessageCount:(NSString*) chatWithUser
{
    if (chatWithUser == nil) {
        return 0;
    }
    XMPPMessageArchivingCoreDataStorage *storage = [KLXMPPTool sharedInstance].xmppMessageArchivingCoreDataStorage;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:storage.messageEntityName inManagedObjectContext:storage.mainThreadManagedObjectContext];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSString* jidstring = [NSString stringWithFormat:@"%@@klsocial.404la.be", chatWithUser];
    
    XMPPJID *jid = [XMPPJID jidWithString:jidstring];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bareJidStr = %@", jid.bare];
    [fetchRequest setPredicate:predicate];
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [storage.mainThreadManagedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    NSUserDefaults* d = [NSUserDefaults standardUserDefaults];
    NSDate* mostRecentReadTimeStamp = [d objectForKey:chatWithUser];
    
    if (mostRecentReadTimeStamp == nil) {
        mostRecentReadTimeStamp = [NSDate date];
    }
    
    int countofUnread = 0;
    if (fetchedObjects != nil) {
        NSMutableArray* coredatamessages = [[NSMutableArray alloc] initWithArray:fetchedObjects];
    
        for (int i = coredatamessages.count - 1; i >=0 ; i--) {
            XMPPMessageArchiving_Message_CoreDataObject *messageobject = coredatamessages[i];
            
            NSMutableDictionary *messageContent = [NSMutableDictionary dictionary];
            
            if ([messageobject.timestamp isEqualToDate:mostRecentReadTimeStamp]) {
                return countofUnread;
            }
            NSString *m = messageobject.body;
            if ([messageobject isOutgoing]) {
                
            }else{
                countofUnread++;
            }
            
            
        }
        //        [NSMutableArray arrayWithArray:fetchedObjects];
    }
    return countofUnread;
}
- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(receiveRefreshMsg)
                                                name:@"EVENT_CONTACT_REFRESH_NOTIFY" object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self FetchFriends];
    [self initRightBarButton];
    [self registerNotification];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor grayColor];
    [self.refreshControl addTarget:self action:@selector(refershControlAction) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    self.tableView.alwaysBounceVertical = YES;
    
}
-(void) viewWillAppear:(BOOL)animated
{
    [self receiveRefreshMsg];
}

- (void)receiveRefreshMsg
{
    _fetchedResultsController = nil;
    [self.tableView reloadData];
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    //    NSLog(@"---%s---",__FUNCTION__);
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    //    NSLog(@"---%s---",__FUNCTION__);
    [self.tableView reloadData];
}



- (void)clickToChatWithBuddy
{
    
}

#pragma mark -
#pragma mark UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"RecentChatCell";
    KLRecentChatListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[KLRecentChatListCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    XMPPMessageArchiving_Contact_CoreDataObject *contactObject = [self.fetchedResultsController objectAtIndexPath:indexPath];


    
    NSString* message = contactObject.mostRecentMessageBody;
    
    NSData* jsonData = [message dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError* error;
    NSDictionary* messageDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    if (messageDict == nil) {
        cell.descriptionLabel.text = message;
        
        
    }else
    {
        
        NSString* messageType = [messageDict objectForKey:@"type"];
        NSString* messageData = [messageDict objectForKey:@"data"];
        
        
        
        if ([messageType isEqualToString:@"text"]) {
            
            cell.descriptionLabel.text = messageData;
            
            
        }else if( [messageType isEqualToString:@"image"])
        {
            cell.descriptionLabel.text = @"sent a photo";
        }else if( [messageType isEqualToString:@"video"])
        {
            cell.descriptionLabel.text = @"sent a video";
            
            
        }else if( [messageType isEqualToString:@"location"])
        {
            cell.descriptionLabel.text = @"share location";
            
        }else if( [messageType isEqualToString:@"gift"])
        {
            
            cell.descriptionLabel.text = @"sent a gift";
            
        }
        
    }
    
    __weak __typeof(KLRecentChatListCell*)weakcell = cell;
    
    NSArray* ejabberdIdArray = [NSArray arrayWithObjects:contactObject.bareJid.user, nil];
    //group_placeholder
    [cell setUserImage:[UIImage imageNamed:@"group_placeholder"]];
    [[KLWebService getInstance] getFullInfoByEjabberdUserIds:ejabberdIdArray withCallback:^(BOOL success, NSArray *response, NSError *error) {
        if (response.count > 0) {
            NSDictionary* userInfo = [response objectAtIndex:0];
            weakcell.titleLabel.text = [userInfo objectForKey:@"fullName"];
            
            NSString* photoUID = [userInfo objectForKey:@"photoUID"];
            
            if (![photoUID isEqual:[NSNull null]] &&  photoUID != nil) {
                [weakcell setUserImageWithUrl:[NSURL URLWithString:photoUID]];
            }

        }
    }];
    
    
    int unreadMsgCount = [self getUnreadMessageCount:contactObject.bareJid.user];
    if (unreadMsgCount > 0) {
        cell.unreadMsgNumb.hidden = false;
        cell.unreadMsgBackground.hidden = false;
        cell.unreadMsgNumb.text = [NSString stringWithFormat:@"%d", unreadMsgCount];
    }else
    {
        cell.unreadMsgNumb.hidden = true;
        cell.unreadMsgBackground.hidden = true;
        
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XMPPMessageArchiving_Contact_CoreDataObject *contactObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if (contactObject.bareJid)
    {
        
        ChatViewController *chatVC =
        [self.storyboard instantiateViewControllerWithIdentifier:@"ChatViewController"];
        chatVC.chatWithUser = contactObject.bareJid.user;
        [self.navigationController pushViewController:chatVC animated:true];
        
        chatVC.hidesBottomBarWhenPushed = YES;
        chatVC = nil;
    }
}



//MARK action menu
- (IBAction) actionMenu:(id)sender
{
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

-(void)refershControlAction
{
    [self receiveRefreshMsg];
    [self.refreshControl endRefreshing];
}
@end

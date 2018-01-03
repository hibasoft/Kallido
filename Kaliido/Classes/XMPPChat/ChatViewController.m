//
//  KLChatViewController.m
//  Kaliido
//
//  Created by Hiba R on 6/6/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "ChatViewController.h"

#import "AppDelegate.h"
#import "MessageCell.h"
#import "NSString+Utils.h"
#import "KLWebService.h"
#import "KLImagePicker.h"
#import "MPGNotification.h"
#import <UIKit/UIKit.h>
#import "MainTabBarController.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "IDMPhotoBrowser.h"
#import <AudioToolbox/AudioToolbox.h>
@interface ChatViewController ()

@end

@implementation ChatViewController

@synthesize messageField, buddyChatTable;


#pragma mark -
#pragma mark Actions

- (IBAction) closeChat {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)makeSound{
    
    SystemSoundID soundID;
    
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"message-send" ofType:@"wav"];
    NSURL *soundUrl = [NSURL fileURLWithPath:soundPath];
    
    AudioServicesCreateSystemSoundID ((__bridge CFURLRef)soundUrl, &soundID);
    AudioServicesPlaySystemSound(soundID);
    
}

-(IBAction)sendText:(id)sender
{
    NSString * messageText = self.messageField.text;
    if (messageText.length == 0) {
        return;
    }
    selectedType = KLMessageTypeText;
    [self sendMessage];
    [self makeSound];

}

-(IBAction)sendImage:(id)sender
{
    [self.view endEditing:true];
    __weak __typeof(self)weakSelf = self;
    [KLImagePicker chooseSourceTypeInVC:self allowsEditing:YES result:^(UIImage *image) {
        
        [SVProgressHUD showProgress:0.f status:nil maskType:SVProgressHUDMaskTypeClear];
        
        [[KLWebService getInstance] fileUpload:UIImagePNGRepresentation(image) storageName:@"Profilepic" progress:^(float progress) {
            [SVProgressHUD showProgress:progress status:nil maskType:SVProgressHUDMaskTypeClear];
        } withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
            [SVProgressHUD dismiss];
            if (success)
            {
                
                fileUrl = [response valueForKey:@"fileurl"];
                selectedType = KLMessageTypeImage;
                [self sendMessage];
                [self makeSound];
                
                
                
            }
        }];
    }];
    
    
}

-(IBAction)sendVideo:(id)sender
{
    [self.view endEditing:true];
    
    [KLImagePicker chooseVideoSourceTypeInVC:self allowsEditing:YES result:^(NSURL *videoURL) {
        
        [SVProgressHUD showProgress:0.f status:nil maskType:SVProgressHUDMaskTypeClear];
        NSData *videoData = [NSData dataWithContentsOfURL:videoURL];
        [[KLWebService getInstance] fileUploadVideo:videoData storageName:@"Profilepic" progress:^(float progress) {
            [SVProgressHUD showProgress:progress status:nil maskType:SVProgressHUDMaskTypeClear];
        } withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
            [SVProgressHUD dismiss];
            if (success)
            {
                
                fileUrl = [response valueForKey:@"fileurl"];
                selectedType = KLMessageTypeVideo;
                [self sendMessage];
                [self makeSound];

                
                
            }
        }];
    }];
}

-(IBAction)sendLocation:(id)sender
{
    ChatMapViewController *viewController =
    [self.storyboard instantiateViewControllerWithIdentifier:@"ChatMapViewController"];
    viewController.delegate = self;
    [self.navigationController pushViewController:viewController animated:true];

    
    [self.view endEditing:true];
}
- (void)didAttachLocation:(CLLocation*)location
{
    fileUrl = [NSString stringWithFormat:@"%f,%f", location.coordinate.latitude, location.coordinate.longitude];
    selectedType = KLMessageTypeLocation;
    [self sendMessage];
}
-(IBAction)sendGift:(id)sender
{
    [self.view endEditing:true];
    [self makeSound];

}


- (void)sendMessage {
    
    XMPPJID *chatJID = [XMPPJID jidWithUser:self.chatWithUser domain:@"klsocial.404la.be" resource:@"Kaliido-App-iOS-v1.0"];
    
    NSString *messageStr;
    NSString* pushString;
    NSString * messageText = self.messageField.text;
    
    
    
    if (selectedType == KLMessageTypeText) {
    
        
    
        NSDictionary* dict = @{@"type":@"text" , @"data":messageText};
        NSError* error;
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
        
        messageStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
        self.messageField.text = @"";
        
        
        
        pushString  = [NSString stringWithFormat:@"{\\\"type\\\":\\\"text\\\", \\\"data\\\":\\\"%@\\\", \\\"sender\\\":\\\"%@\\\"}", messageText, [KLApi instance].ejabberdUserId];
        
        
        
    }else if (selectedType == KLMessageTypeImage)
    {
        NSDictionary* dict = @{@"type":@"image" , @"data":fileUrl};
        NSError* error;
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
        
        messageStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        
        pushString = [NSString stringWithFormat:@"{\\\"type\\\":\\\"image\\\", \\\"data\\\":\\\"%@\\\", \\\"sender\\\":\\\"%@\\\"}", fileUrl, [KLApi instance].ejabberdUserId];
        
        
    }else if (selectedType == KLMessageTypeVideo)
    {
        NSDictionary* dict = @{@"type":@"video" , @"data":fileUrl};
        NSError* error;
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
        
        messageStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        pushString = [NSString stringWithFormat:@"{\\\"type\\\":\\\"video\\\", \\\"data\\\":\\\"%@\\\", \\\"sender\\\":\\\"%@\\\"}", fileUrl, [KLApi instance].ejabberdUserId];
        
    }else if (selectedType == KLMessageTypeLocation)
    {
        NSDictionary* dict = @{@"type":@"location" , @"data":fileUrl};
        NSError* error;
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
        
        messageStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        pushString = [NSString stringWithFormat:@"{\\\"type\\\":\\\"location\\\", \\\"data\\\":\\\"%@\\\", \\\"sender\\\":\\\"%@\\\"}", fileUrl, [KLApi instance].ejabberdUserId];
        
    }else if (selectedType == KLMessageTypeGift)
    {
        NSDictionary* dict = @{@"type":@"gift" , @"data":fileUrl};
        NSError* error;
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
        
        messageStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        pushString = [NSString stringWithFormat:@"{\\\"type\\\":\\\"gift\\\", \\\"data\\\":\\\"%@\\\", \\\"sender\\\":\\\"%@\\\"}", fileUrl, [KLApi instance].ejabberdUserId];
        
    }
    

    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:messageStr];
    
    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    [message addAttributeWithName:@"to" stringValue:chatJID.bare];
    
    [message addChild:body];
    
    [[KLXMPPTool sharedInstance].xmppStream sendElement:message];
    
    
    
    
    NSMutableDictionary *m = [[NSMutableDictionary alloc] init];
    [m setObject:messageStr forKey:@"msg"];
    [m setObject:@"you" forKey:@"sender"];
    [m setObject:[NSString getCurrentTime] forKey:@"time"];
    
    [messages addObject:m];
    [self.buddyChatTable reloadData];
    
    
    [self tableViewScrollToBottom];

    NSSet *tags = [NSSet setWithArray:@[@{@"Name": @0, @"Value" : self.chatWithUser}]];
//    [[KLApi instance] SendNotificationASPNETBackend:tags message:message];
}


#pragma mark -
#pragma mark Table view delegates

static CGFloat padding = 20.0;


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSDictionary *s = (NSDictionary *) [messages objectAtIndex:indexPath.row];
  
    NSString *sender = [s objectForKey:@"sender"];
    NSString *message = [s objectForKey:@"msg"];
    NSString *time = [s objectForKey:@"time"];
    
    NSString *CellIdentifier =  @"inmessage";
    if ([sender isEqualToString:@"you"]) {
        CellIdentifier = @"outmessage";
    }
    
    MessageCell *cell = (MessageCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.btnViewContent.tag = indexPath.row;
    [cell.btnViewContent addTarget:self action:@selector(onTapViewContent:) forControlEvents:UIControlEventTouchUpInside];
    NSData* jsonData = [message dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError* error;
    NSDictionary* messageDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    if (messageDict == nil) {
        cell.messageContentView.text = message;
        
        cell.fileImageView.hidden = true;
        cell.messageContentView.hidden = true;
        
    }else
    {
    
        NSString* messageType = [messageDict objectForKey:@"type"];
        NSString* messageData = [messageDict objectForKey:@"data"];
        
        
        
        if ([messageType isEqualToString:@"text"]) {
            
            cell.messageContentView.text = messageData;
            
            cell.fileImageView.hidden = true;
            cell.messageContentView.hidden = false;
            cell.mapView.hidden = true;
        }else if( [messageType isEqualToString:@"image"])
        {
            [cell.fileImageView setImageWithURL:[NSURL URLWithString:messageData] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            
            cell.fileImageView.hidden = false;
            cell.messageContentView.hidden = true;
            cell.mapView.hidden = true;
        }else if( [messageType isEqualToString:@"video"])
        {
            
            UIImage* image =  [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:messageData.lastPathComponent];
            if (image) {
                [cell.fileImageView setImage:image];
                
            }else
            {
                [cell.fileImageView setImage:[UIImage imageNamed:@"default_avatar_thumbnail"]];
                [cell.fileImageView setContentMode:UIViewContentModeScaleToFill];
                
                //                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:imageView , @"imageView", messageString, @"itemurl", nil];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                  
                    
                    NSURL *url = [NSURL URLWithString:messageData];
                    
                    //    NSURL *url = [NSURL URLWithString:@"http://media.w3.org/2010/05/sintel/trailer.mp4"];
                    AVURLAsset *asset=[[AVURLAsset alloc] initWithURL:url options:nil];
                    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
                    imageGenerator.maximumSize = CGSizeMake(100, 100);
                    Float64 durationSeconds = CMTimeGetSeconds([asset duration]);
                    CMTime midpoint = CMTimeMakeWithSeconds(durationSeconds/2.0, 600);
                    NSError* error = nil;
                    CMTime actualTime;
                    
                    CGImageRef halfWayImage = [imageGenerator copyCGImageAtTime:midpoint actualTime:&actualTime error:&error];
                    
                    UIImage* resultUIImage = nil;
                    if (halfWayImage != NULL) {
                        resultUIImage = [UIImage imageWithCGImage:halfWayImage];
                        
                        CGImageRelease(halfWayImage);
                        
                        //resize image (use some code for resize)
                        //<>
                        //TODO: call some method to resize image
                        UIImage* resizedImage = resultUIImage;
                        //<>
                        
                        
                        
                        if (cell.fileImageView != nil) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [cell.fileImageView setImage:resizedImage];
                                [[SDImageCache sharedImageCache] storeImage:resizedImage forKey:messageData.lastPathComponent];
                            });
                        }
                        
                        
                    }
                    else
                    {
                        
                        
                    }
                });
                
                
            }
            
            
            cell.fileImageView.hidden = false;
            cell.messageContentView.hidden = true;
            cell.mapView.hidden = true;
        }else if( [messageType isEqualToString:@"location"])
        {
            NSArray *locationArray = [messageData componentsSeparatedByString:@","];
            CLLocationCoordinate2D locCoord = CLLocationCoordinate2DMake([[locationArray objectAtIndex:0] floatValue], [[locationArray objectAtIndex:1] floatValue]);
            
            MKCoordinateRegion region;
            region.center.latitude = locCoord.latitude;
            region.center.longitude = locCoord.longitude;
            region.span.latitudeDelta = 0.2;
            region.span.longitudeDelta = 0.2;
            [cell.mapView setRegion:region animated:NO];
            //---------------------------------------------------------------------------------------------------------------------------------------------
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            [cell.mapView addAnnotation:annotation];
            [annotation setCoordinate:locCoord];
            
            cell.fileImageView.hidden = true;
            cell.messageContentView.hidden = true;
            cell.mapView.hidden = false;
        }else if( [messageType isEqualToString:@"gift"])
        {
            
            [cell.fileImageView setImageWithURL:[NSURL URLWithString:messageData] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            
            cell.fileImageView.hidden = false;
            cell.messageContentView.hidden = true;
            cell.mapView.hidden = true;
        }
        
    }
    
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    cell.messageContentView.textContainerInset = UIEdgeInsetsZero;
    cell.messageContentView.textContainer.lineFragmentPadding = 0;
    
    UIImage *bgImage = nil;
    
    
    if ([sender isEqualToString:@"you"]) { // left aligned
        
        bgImage = [[UIImage imageNamed:@"outgoing.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(35, 3, 3, 14)];
        
        cell.messageContentView.textColor = [UIColor whiteColor];
        [cell.profileImageView setImageWithURL:[NSURL URLWithString:KLUser.currentUser.photoUID] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    } else {
        
        
        bgImage = [[UIImage imageNamed:@"incoming.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(35, 14, 3, 3)];
        
        
    }
    
    cell.bgImageView.image = bgImage;
    cell.senderAndTimeLabel.text = [NSString stringWithFormat:@"%@ %@", sender, time];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *s = (NSDictionary *) [messages objectAtIndex:indexPath.row];
    
    NSString *sender = [s objectForKey:@"sender"];
    NSString *message = [s objectForKey:@"msg"];
    NSString *time = [s objectForKey:@"time"];
    
    
    
    NSData* jsonData = [message dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError* error;
    NSDictionary* messageDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    if (messageDict == nil) {
        return 80;
    }else
    {
        
        NSString* messageType = [messageDict objectForKey:@"type"];
        NSString* messageData = [messageDict objectForKey:@"data"];
        
        
        
        if ([messageType isEqualToString:@"text"]) {
            
            
            CGSize  textSize = { SCREEN_WIDTH- 105, 10000.0 };
            CGSize size = [messageData sizeWithFont:[UIFont systemFontOfSize:14]
                          constrainedToSize:textSize
                              lineBreakMode:UILineBreakModeWordWrap];
            
            //size.height += padding*2;
            size.height += 51;
            CGFloat height = size.height < 65 ? 65 : size.height;
            
            return height;
        }else if( [messageType isEqualToString:@"image"])
        {
            
            return SCREEN_WIDTH- 75;
        }else if( [messageType isEqualToString:@"video"])
        {
            
            return SCREEN_WIDTH- 75;
        }else if( [messageType isEqualToString:@"location"])
        {
            return SCREEN_WIDTH- 75;
        }else if( [messageType isEqualToString:@"gift"])
        {
            return SCREEN_WIDTH- 75;
        }
        
    }
    return 80;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [messages count];
    
}
-(IBAction)onTapViewContent:(id)sender
{
    UIButton* tmpButton = sender;
    
    NSDictionary *s = (NSDictionary *) [messages objectAtIndex:tmpButton.tag];
    
    NSString *sender1 = [s objectForKey:@"sender"];
    NSString *message = [s objectForKey:@"msg"];
    NSString *time = [s objectForKey:@"time"];
    
    NSData* jsonData = [message dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError* error;
    NSDictionary* messageDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    if (messageDict == nil) {
    
        
    }else
    {
        
        NSString* messageType = [messageDict objectForKey:@"type"];
        NSString* messageData = [messageDict objectForKey:@"data"];
        
        
        
        if ([messageType isEqualToString:@"text"]) {
            
        }else if( [messageType isEqualToString:@"image"])
        {
            IDMPhoto *photo = [IDMPhoto photoWithURL:[NSURL URLWithString:messageData]];
            IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:@[photo]];
            browser.displayToolbar = NO;
            [self presentViewController:browser animated:YES completion:nil];
        }else if( [messageType isEqualToString:@"video"])
        {
            
            if (self.moviePlayer != nil) {
                [self.moviePlayer dismissMoviePlayerViewControllerAnimated];
                self.moviePlayer = nil;
            }
            self.moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:messageData]];
            
            [self presentMoviePlayerViewControllerAnimated:self.moviePlayer];
        }else if( [messageType isEqualToString:@"location"])
        {
            
            NSArray *locationArray = [messageData componentsSeparatedByString:@","];
            CLLocationCoordinate2D locCoord = CLLocationCoordinate2DMake([[locationArray objectAtIndex:0] floatValue], [[locationArray objectAtIndex:1] floatValue]);

            
            ChatMapViewController *viewController =
            [self.storyboard instantiateViewControllerWithIdentifier:@"ChatMapViewController"];
            viewController.location = [[CLLocation alloc] initWithLatitude:locCoord.latitude longitude:locCoord.longitude];
            viewController.nMode = 1;
            viewController.delegate = self;
            [self.navigationController pushViewController:viewController animated:true];
            
            
            [self.view endEditing:true];
        }else if( [messageType isEqualToString:@"gift"])
        {
            
            
            
        }
        
    }
    
   
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}


#pragma mark -
#pragma mark Chat delegates


- (void)newMessageReceived:(NSNotification *) notification {
    
    NSDictionary *messageContent = notification.userInfo;
    
    NSString *m = [messageContent objectForKey:@"msg"];
    NSString* sender = [messageContent objectForKey:@"sender"];
    
    NSString* ejabberdUserId = [NSString stringWithFormat:@"%@@klsocial.404la.be",[KLUser.currentUser.getUserDic objectForKey:@"quickbloxUserId"] ];
    if ([sender isEqualToString:ejabberdUserId]) {
        return;
    }
    
//    MainTabBarController* controller = (MainTabBarController*)self.parentViewController;
//    [controller changeBadgeValue:YES increaseAmount:1];
    
    [messageContent setValue:[m substituteEmoticons] forKey:@"msg"];
    [messageContent setValue:[NSString getCurrentTime] forKey:@"time"];
    
    [messages addObject:messageContent];
    [self.buddyChatTable reloadData];
    
    NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:messages.count-1 
                                                   inSection:0];
    
    [self.buddyChatTable scrollToRowAtIndexPath:topIndexPath
                      atScrollPosition:UITableViewScrollPositionMiddle 
                              animated:YES];
    
    int count = [self.tabBarItem.badgeValue intValue] + 1;
    
    [self.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%d", count]];
    
    
    SystemSoundID soundID;
    
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"message-receive" ofType:@"wav"];
    NSURL *soundUrl = [NSURL fileURLWithPath:soundPath];
    
    AudioServicesCreateSystemSoundID ((__bridge CFURLRef)soundUrl, &soundID);
    AudioServicesPlaySystemSound(soundID);
    
    
 
    
    
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kXMPP_MESSAGE_CHANGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
-(void)viewDidDisappear:(BOOL)animated
{
   

    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[KLXMPPTool sharedInstance] addFriend:[XMPPJID jidWithUser:self.chatWithUser domain:@"klsocial.404la.be" resource:@"Kaliido-App-iOSv1.0"]];
    [self.messageField setPlaceHolder:@"Type a message..."];
 
    self.buddyChatTable.delegate = self;
    self.buddyChatTable.dataSource = self;
    [self.buddyChatTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    messages = [[NSMutableArray alloc ] init];
    
    
    [self.messageField becomeFirstResponder];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotifierShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotifierHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getChatHistory) name:kXMPP_MESSAGE_CHANGE object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(newMessageReceived:)
                                                 name:kMESSAGE_RECEIVED
                                               object:nil];
    
    
    
    
    [self getChatHistory];
}

- (void)getChatHistory
{
    XMPPMessageArchivingCoreDataStorage *storage = [KLXMPPTool sharedInstance].xmppMessageArchivingCoreDataStorage;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:storage.messageEntityName inManagedObjectContext:storage.mainThreadManagedObjectContext];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSString* jidstring = [NSString stringWithFormat:@"%@@klsocial.404la.be", self.chatWithUser];
    
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
    
    if (fetchedObjects != nil) {
        NSMutableArray* coredatamessages = [[NSMutableArray alloc] initWithArray:fetchedObjects];
        messages = [NSMutableArray array];
        for (int i = 0; i < coredatamessages.count; i++) {
            XMPPMessageArchiving_Message_CoreDataObject *messageobject = coredatamessages[i];
            
            
            
            NSMutableDictionary *messageContent = [NSMutableDictionary dictionary];
            
            NSString *m = messageobject.body;
            if ([messageobject isOutgoing]) {
            
                [messageContent setValue:@"you" forKey:@"sender"];
            }else{
                [d setObject:messageobject.timestamp forKey:self.chatWithUser];
                [d synchronize];
            }
            
            [messageContent setValue:[m substituteEmoticons] forKey:@"msg"];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
            [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
            [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
            NSString* sentTime = [dateFormatter stringFromDate:messageobject.timestamp];

            
            [messageContent setValue:sentTime forKey:@"time"];
            [messages addObject:messageContent];
            
        }
        //        [NSMutableArray arrayWithArray:fetchedObjects];
    }
    
    [self.buddyChatTable reloadData];
    
    [self tableViewScrollToBottom];
}

- (void)tableViewScrollToBottom
{
    if (messages.count > 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(messages.count-1) inSection:0];
        [self.buddyChatTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

/* Notification will be called prior to Keyboard being seen */
-(void)keyboardNotifierShow:(NSNotification *)notification
{
    
    CGRect tempKeyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect convertedFrame = [self.view convertRect:tempKeyboardFrame fromView:self.view.window];
    
    self.tableViewToBottom.constant = convertedFrame.size.height;
    [buddyChatTable updateConstraintsIfNeeded];
    [buddyChatTable layoutIfNeeded];
    
    if ([messages count] != 0) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[messages count]-1 inSection:0];
        [buddyChatTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

/* Notification will be called prior to Keyboard being seen */
-(void)keyboardNotifierHide:(NSNotification *)notification
{
    
    
    self.tableViewToBottom.constant = 0;
    
    [buddyChatTable updateConstraintsIfNeeded];
    [buddyChatTable layoutIfNeeded];
    
    if ([messages count] != 0) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[messages count]-1 inSection:0];
        [buddyChatTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

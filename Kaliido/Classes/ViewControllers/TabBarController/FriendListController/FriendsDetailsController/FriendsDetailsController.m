//
//  FriendsDetailsController.m
//  Kaliido
//
//  Created by Daron28/02/2014.
//  Copyright (c) 2014 Kaliido. All rights reserved.
//

#import "FriendsDetailsController.h"
//#import "VideoCallController.h"
#import "ChatViewController.h"
//#import "UsersUtils.h"
#import "KLImageView.h"
//#import "KLAlertsFactory.h"
#import "REAlertView.h"

#import "KLApi.h"
//#import "ChatReceiver.h"

typedef NS_ENUM(NSUInteger, KLCallType) {
    KLCallTypePhone,
    KLCallTypeVideo,
    KLCallTypeAudio,
    KLCallTypeChat
};

@interface FriendsDetailsController () <UIActionSheetDelegate>
{
    UIView *viewGraph[5];
}
@property (weak, nonatomic) IBOutlet UITableViewCell *phoneCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *videoChatCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *audioChatCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *chatCell;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *deleteContactButton;
@property (weak, nonatomic) IBOutlet KLImageView *userAvatar;
@property (weak, nonatomic) IBOutlet UILabel *fullName;
@property (strong, nonatomic) IBOutlet UILabel *ageLabel;
@property (strong, nonatomic) IBOutlet UILabel *zodiacLabel;
@property (strong, nonatomic) IBOutlet UILabel *personalityLabel;
@property (strong, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UILabel *userDetails;
@property (weak, nonatomic) IBOutlet UITextView *profileInformation;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIImageView *onlineCircle;
@property (weak, nonatomic) IBOutlet UILabel *userRelationshipStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblFollowing;
@property (weak, nonatomic) IBOutlet UILabel *lblFollwers;
@property (weak, nonatomic) IBOutlet UILabel *userLookingFor;
@property (weak, nonatomic) IBOutlet UILabel *lblEvents;
@property (weak, nonatomic) IBOutlet UIView *makeRoundContentCell;
@end

@implementation FriendsDetailsController

- (void)dealloc {

    NSLog(@"%@ - %@",  NSStringFromSelector(_cmd), self);
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
//    if (self.selectedUser.phone.length == 0) {
//        [self.phoneLabel setText:NSLocalizedString(@"KL_STR_NONE", nil)];
//    } else {
//        self.phoneLabel.text = self.selectedUser.phone;
//    }
    
//    self.userDetails.text = self.selectedUser.status;
    self.fullName.text = [self getValueFromDictionary:self.userDic forKey:@"fullName"];
    if([self getValueFromDictionary:self.userDic forKey:@"age"])
        self.ageLabel.text = [NSString stringWithFormat:@"%@",[self getValueFromDictionary:self.userDic forKey:@"age"]];
    else
        self.ageLabel.text = @"";
    
    self.zodiacLabel.text = [self getValueFromDictionary:self.userDic forKey:@"zodiac"];
    NSArray *lookingForsArray = (NSArray*)[self getValueFromDictionary:self.userDic forKey:@"lookingFors"];
    if (lookingForsArray != nil)
    {
        NSString *lookingForsString=@"";
        for(NSDictionary *dic in lookingForsArray)
        {
            lookingForsString = [NSString stringWithFormat:@"%@,%@",lookingForsString, [dic valueForKey:@"name"]];
        }
        self.userLookingFor.text = [lookingForsString substringFromIndex:1];
    }else
    {
        self.userLookingFor.text = @"";
    }
    NSDictionary *relationDic = (NSDictionary*)[self getValueFromDictionary:self.userDic forKey:@"relationship"];
    if(relationDic != nil)
        self.userRelationshipStatus.text = [relationDic valueForKey:@"name"];
    else
        self.userRelationshipStatus.text = @"";
    self.profileInformation.text = [self getValueFromDictionary:self.userDic forKey:@"aboutMe"];
    
    NSDictionary *dic = (NSDictionary*)[self getValueFromDictionary:self.userDic forKey:@"relations"];
    if (dic != nil)
        self.addButton.selected = [[dic valueForKey:@"isFriend"] boolValue];
    
    self.userAvatar.imageViewType = KLImageViewTypeCircle;
    
    NSURL *url = [NSURL URLWithString:[self getValueFromDictionary:self.userDic forKey:@"photoUID"]];//[KLUsersUtils userAvatarURL:self.selectedUser];
    UIImage *placeholder = [UIImage imageNamed:@"upic-placeholder"];
    [self.userAvatar setImageWithURL:url
                         placeholder:placeholder
                             options:SDWebImageHighPriority
                            progress:
     ^(NSInteger receivedSize, NSInteger expectedSize) {
         
     }
     
                      completedBlock:
     ^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
         
     }];
    
 
    
    
    [self updateUserStatus];
    
    [self disableDeleteContactButtonIfNeeded];
    
#if !KL_AUDIO_VIDEO_ENABLED
    
//    UITableViewCell *videoChatCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
//    UITableViewCell *audioChatCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
//    [self cells:@[videoChatCell, audioChatCell] setHidden:YES];
    
#endif
    //self.hidesBottomBarWhenPushed = NO;
    [[[UIApplication sharedApplication] keyWindow] makeKeyAndVisible];
    
    self.lblEvents.layer.borderWidth = 1.0f;
    self.lblFollowing.layer.borderWidth = 1.0f;
    self.lblFollwers.layer.borderWidth = 1.0f;
    self.lblEvents.layer.borderColor = [UIColor blackColor].CGColor;
    self.lblFollowing.layer.borderColor = [UIColor blackColor].CGColor;
    self.lblFollwers.layer.borderColor = [UIColor blackColor].CGColor;
    self.lblEvents.layer.cornerRadius = 10.0f;
    self.lblFollowing.layer.cornerRadius = 10.0f;
    self.lblFollwers.layer.cornerRadius = 10.0f;
    
    for (UIView *view in self.makeRoundContentCell.subviews)
    {
        if ([view isKindOfClass:[UIView class]])
        {
            view.layer.cornerRadius = view.frame.size.height/2;
        }
    }
}

- (void)updateUserStatus {
    
//    ContactListItem *item = [[KLApi instance] contactItemWithUserID:[[self getValueFromDictionary:self.userDic forKey:@"id"] integerValue]];
//    
//    if (item) { //friend if YES
//        self.status.text = NSLocalizedString(item.online ? @"KL_STR_ONLINE": @"KL_STR_OFFLINE", nil);
//        self.onlineCircle.hidden = item.online ? NO : YES;
//    }
}

- (NSString *)getValueFromDictionary:(NSDictionary*)dic forKey:(NSString*)key
{
    NSString *retString = [dic valueForKey:key];
    if ([retString isEqual:[NSNull null]])
        retString = nil;
    return retString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:kVideoCallSegueIdentifier]) {
        
//        VideoCallController *videoCallVC = segue.destinationViewController;
//        [videoCallVC setOpponent:self.selectedUser];
        
    } else if ([segue.identifier isEqualToString:kAudioCallSegueIdentifier]) {
        
//        VideoCallController *audioCallVC = segue.destinationViewController;
//        [audioCallVC setOpponent:self.selectedUser];
        
    } else if ([segue.identifier isEqualToString:kChatViewSegueIdentifier]) {
        
        
        
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case KLCallTypeChat: {
            
            
            ChatViewController *viewController =
            [self.storyboard instantiateViewControllerWithIdentifier:@"ChatViewController"];
            viewController.chatWithUser = [NSString stringWithFormat:@"%@", [self.userDic objectForKey:@"quickbloxUserId"]];
            [self.navigationController pushViewController:viewController animated:true];
        
        } break;
            
        default:break;
    }
}

#pragma mark - Actions

- (IBAction)removeFromFriends:(id)sender {
    
//    __weak __typeof(self)weakSelf = self;
//    [REAlertView presentAlertViewWithConfiguration:^(REAlertView *alertView) {
//        
//        alertView.message = [NSString stringWithFormat:NSLocalizedString(@"KL_STR_CONFIRM_DELETE_CONTACT", @"{User Full Name}"), self.selectedUser.fullName];
//        [alertView addButtonWithTitle:NSLocalizedString(@"KL_STR_CANCEL", nil) andActionBlock:^{}];
//        [alertView addButtonWithTitle:NSLocalizedString(@"KL_STR_DELETE", nil) andActionBlock:^{
//            
//            [[KLApi instance] removeUserFromContactList:weakSelf.selectedUser completion:^(BOOL success, QBChatMessage *notification) {}];
//            [weakSelf.navigationController popViewControllerAnimated:YES];
//        }];
//    }];
}
- (void)disableDeleteContactButtonIfNeeded
{
//    BOOL isContact = [[KLApi instance] isFriend:self.selectedUser];
//    self.deleteContactButton.enabled = isContact;
}

    - (IBAction)addButtonClicked:(id)sender {
    }
@end

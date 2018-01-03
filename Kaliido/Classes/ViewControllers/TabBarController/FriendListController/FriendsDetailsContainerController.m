//
//  FriendsDetailsContainerController.m
//  Kaliido
//
//  Created by  Kaliido on 1/20/15.
//  Copyright (c) 2015 Kaliido. All rights reserved.
//

#import "FriendsDetailsContainerController.h"
#import "FriendsDetailsController.h"
#import "KLImageView.h"
//#import "ChatReceiver.h"
#import "KLApi.h"
#import "KLWebService.h"

#import "ChatViewController.h"

//#import "UsersService.h"
//#import "MessagesService.h"
#import "UIViewController+ECSlidingViewController.h"
#import "NoteInputViewController.h"

@interface FriendsDetailsContainerController ()
{
    UIView *viewAlertPane;
    UIView *viewAlert;
    IBOutlet UIView *viewTabBar;
}

@property (strong, nonatomic) IBOutlet KLImageView *userTblAvatar;
@property (strong, nonatomic) IBOutlet UILabel *tblFullName;
@property (strong, nonatomic) IBOutlet UILabel *tblHeadLineLabel;
@property (strong, nonatomic) IBOutlet UILabel *ageLabel;
@property (strong, nonatomic) IBOutlet UIButton *tblAddButton;
@property (strong, nonatomic) IBOutlet UITextView *profileInformation;
@property (strong, nonatomic) IBOutlet UILabel *userRelationshipStatus;
@property (strong, nonatomic) IBOutlet UILabel *userLookingFor;
@property (strong, nonatomic) IBOutlet UIButton *tblOnlineCircleButton;

@property (nonatomic) BOOL bOwnerProfile;
@property (strong, nonatomic) NSMutableDictionary *interestDic;
@property (strong, nonatomic) NSArray             *interestCategoryArray;
@end

@implementation FriendsDetailsContainerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.bOwnerProfile = NO;
    if (self.userDic == nil)
        self.bOwnerProfile = YES;
    
    if (!self.bOwnerProfile)
        [self updateProfileData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    if (self.bOwnerProfile)
    {
        self.userDic = [self dictionaryFromString:KLUser.currentUser.customData];
        [self updateProfileData];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void) updateProfileData
{
    
    self.tblFullName.text = [self getValueFromDictionary:self.userDic forKey:@"fullName"];
    
    
    self.tblHeadLineLabel.text = [self getValueFromDictionary:self.userDic forKey:@"headLine"];
    
    if([self getValueFromDictionary:self.userDic forKey:@"age"])
        self.ageLabel.text = [NSString stringWithFormat:@"%@",[self getValueFromDictionary:self.userDic forKey:@"age"]];
    else
        self.ageLabel.text = @"";
    
    NSArray *lookingForsArray = (NSArray*)[self getValueFromDictionary:self.userDic forKey:@"lookingFors"];
    if (lookingForsArray != nil && lookingForsArray.count)
    {
        NSString *lookingForsString=@"";
        for(NSDictionary *dic in lookingForsArray)
        {
            lookingForsString = [NSString stringWithFormat:@"%@,%@",lookingForsString, [self getValueFromDictionary:dic forKey:@"name"]];
        }
        self.userLookingFor.text = [lookingForsString substringFromIndex:1];
    }else
    {
        self.userLookingFor.text = @"";
    }
    NSDictionary *relationDic = (NSDictionary*)[self getValueFromDictionary:self.userDic forKey:@"relationship"];
    if(relationDic != nil)
        self.userRelationshipStatus.text = [self getValueFromDictionary:relationDic forKey:@"name"];
    else
        self.userRelationshipStatus.text = @"";
    self.profileInformation.text = [self getValueFromDictionary:self.userDic forKey:@"aboutMe"];
    
    NSDictionary *dic = (NSDictionary*)[self getValueFromDictionary:self.userDic forKey:@"relations"];
    if (dic != nil)
    {
        self.tblAddButton.selected = [[self getValueFromDictionary:dic forKey:@"isFavorite"] boolValue];
    }
    
    
    self.userTblAvatar.imageViewType = KLImageViewTypeCircle;
    
    NSURL *url = [NSURL URLWithString:[self getValueFromDictionary:self.userDic forKey:@"photoUID"]];//[KLUsersUtils userAvatarURL:self.selectedUser];
    UIImage *placeholder = [UIImage imageNamed:@"upic-placeholder"];
    
    
    [self.userTblAvatar setImageWithURL:url
                         placeholder:placeholder
                             options:SDWebImageHighPriority
                            progress:
     ^(NSInteger receivedSize, NSInteger expectedSize) {
         
     }
     
                      completedBlock:
     ^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
         
     }];

    self.interestDic = [[NSMutableDictionary alloc] init];

    NSMutableArray *interestArray = (NSMutableArray*)[self getValueFromDictionary:self.userDic forKey:@"interests"];
    for(NSDictionary *dic in interestArray)
    {
        int interestId = (int)[[dic valueForKey:@"id"] integerValue];
    
    }
    
    [self updateUserStatus];
}
- (void)updateUserStatus {
    
    
    self.tblOnlineCircleButton.selected = YES;

}

- (NSMutableDictionary *)dictionaryFromString:(NSString *)string
{
    NSMutableDictionary *customParams = nil;
    NSError *error = nil;
    
    NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
    if (jsonData == nil) {
        return [[NSMutableDictionary alloc] init];
    }
    customParams = [[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error] mutableCopy];
    if (customParams == nil) {
        customParams = [[NSMutableDictionary alloc] init];
    }
    return customParams;
}

- (NSString *)getValueFromDictionary:(NSDictionary*)dic forKey:(NSString*)key
{
    NSString *retString = [dic valueForKey:key];
    if ([retString isEqual:[NSNull null]])
        retString = nil;
    return retString;
}

- (IBAction) actionComment:(id)sender{
    [viewAlertPane removeFromSuperview];
    // show alert
    CGRect screenSize = [UIScreen mainScreen].bounds;
    CGFloat scale = screenSize.size.width/320;
    UIView *pane = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize.size.width, screenSize.size.height)];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320*scale, 380*scale)];
    int y = 0;

    
    
    NSArray *actionButtonArray = [NSArray arrayWithObjects:NSLocalizedString(@"KL_STR_MAKEANOTE", nil), NSLocalizedString(@"KL_STR_REPORTTHISMEMBER", nil), NSLocalizedString(@"KL_STR_BLOCKTHISMEMBER", nil), nil];
    for ( int i = 1; i <=(int)actionButtonArray.count; i++)
    {
        NSString *strName = [actionButtonArray objectAtIndex:i-1];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(10, y, view.frame.size.width-20, 44)];
        btn.tag = i;
        y = y + 44+1;
        [btn setBackgroundColor:[UIColor colorWithRed:(float)0xec/0xff green:(float)0xec/0xff blue:(float)0xec/0xff alpha:1.0]];
        [btn setTitle:strName forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:(float)0x46/0xff green:(float)0x39/0xff blue:(float)0x8b/0xff alpha:1.0] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:(float)0xc1/0xff green:(float)0xbf/0xff blue:(float)0xc8/0xff alpha:1.0] forState:UIControlStateHighlighted];
        [view addSubview:btn];
        [btn addTarget:self action:@selector(dismissPane:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    NSString *strName = [NSString stringWithFormat:NSLocalizedString(@"KL_STR_CANCEL", nil)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(10, y+10, view.frame.size.width-20,44)];
    btn.tag = 0;
    [btn addTarget:self action:@selector(dismissPane:) forControlEvents:UIControlEventTouchUpInside];
    y = y + 44+10;
    [btn setBackgroundColor:[UIColor colorWithRed:(float)0xec/0xff green:(float)0xec/0xff blue:(float)0xec/0xff alpha:1.0]];
    [btn setTitle:strName forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithRed:(float)0x46/0xff green:(float)0x39/0xff blue:(float)0x8b/0xff alpha:1.0] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithRed:(float)0xc1/0xff green:(float)0xbf/0xff blue:(float)0xc8/0xff alpha:1.0] forState:UIControlStateHighlighted];
    [view addSubview:btn];
    
    view.center = CGPointMake(160*scale, screenSize.size.height + 250);
    [pane addSubview:view];
    pane.backgroundColor = [UIColor clearColor];
    [self.view addSubview:pane];
    viewAlertPane = pane;
    [UIView animateWithDuration:0.3 animations:^{
        pane.backgroundColor = [UIColor colorWithRed:70/255.0f green:57/255.0f blue:139/255.0f alpha:0.65f];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 animations:^{
            view.center = CGPointMake(160*scale, screenSize.size.height - 20 - 44);
        }];
    }];
    viewAlert = view;
    UIButton *btnFirst = (UIButton*)[viewTabBar viewWithTag:1];
    btnFirst.selected = TRUE;
}
- (IBAction)addButtonClicked:(UIButton*)sender {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    if (!sender.selected)
    {
        [[KLWebService getInstance] addFavorite:(int)[[self.userDic valueForKey:@"id"] integerValue] withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
            sender.selected = !sender.selected;
            [SVProgressHUD dismiss];
        }];
    }else
    {
        [[KLWebService getInstance] removeFavorite:(int)[[self.userDic valueForKey:@"id"] integerValue] withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
            sender.selected = !sender.selected;
            [SVProgressHUD dismiss];
        }];
    }
}

- (IBAction) tabSelected:(id) sender
{
    UIButton *btnSel = (UIButton*) sender;
    for (int i =1; i<=4; i++)
    {
        UIButton *btn = (UIButton*)[viewTabBar viewWithTag:i];
        btn.selected = FALSE;
    }
    btnSel.selected = TRUE;

    if (btnSel.tag == 3)
    {

        
        XMPPJID *chatJID = [XMPPJID jidWithUser:[NSString stringWithFormat:@"%@", [self.userDic objectForKey:@"quickbloxUserId"]] domain:@"klsocial.404la.be" resource:@"Kaliido-App-iOS-v1.0"];
        [[KLXMPPTool sharedInstance].xmppRoster addUser:chatJID withNickname:[self.userDic objectForKey:@"fullName"]];
        
        ChatViewController *viewController =
        [self.storyboard instantiateViewControllerWithIdentifier:@"ChatViewController"];
        viewController.chatWithUser = [NSString stringWithFormat:@"%@", [self.userDic objectForKey:@"quickbloxUserId"]];
        [self.navigationController pushViewController:viewController animated:true];
        
        
        
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:kChatViewSegueIdentifier]) {
        
//        ChatViewController *chatController = segue.destinationViewController;
//        chatController.dialog = sender;
//        
//        NSAssert([sender isKindOfClass:QBChatDialog.class], @"Need update this case");
    }else if ([[segue identifier] isEqualToString:@"NoteHeadInput"]){
        NoteInputViewController *vc = [segue destinationViewController];
        vc.userId = (int)[[self.userDic valueForKey:@"id"] integerValue];
    }

}

- (IBAction) actionMakeNote:(id)sender
{
    [self dismissPane:sender];
}
- (IBAction) actionMailToFriend:(id)sender
{
    [self dismissPane:sender];
}
- (IBAction) actionSMSToFriend:(id)sender
{
    [self dismissPane:sender];
}
- (IBAction) actionReportThisMemeber:(id)sender
{
    [self dismissPane:sender];
}
- (IBAction) actionBlockThisMember:(id)sender
{
    [self dismissPane:sender];
}
- (IBAction) actionSomethingElse:(id)sender
{
    [self dismissPane:sender];
}

- (IBAction) actionCancel:(id)sender
{
    [self dismissPane:sender];
}

- (void) dismissPane:(UIButton*) sender
{
    CGRect screenSize = [UIScreen mainScreen].bounds;
    CGFloat scale = screenSize.size.width/320;
    
    [UIView animateWithDuration:0.4 animations:^{
        viewAlert.center = CGPointMake(160*scale, screenSize.size.height + 250);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            viewAlertPane.backgroundColor = [UIColor clearColor];
        }
        completion:^(BOOL finished) {
            viewAlertPane.hidden = YES;
        }
         ];
    }];
    
    if (sender.tag == 1)
    {
        NoteInputViewController *viewController =
        [self.storyboard instantiateViewControllerWithIdentifier:@"NoteInputViewController"];
        [self.navigationController pushViewController:viewController animated:true];
        
        
    }else if (sender.tag == 3)
    {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        [[KLWebService getInstance] blockUser:(int)[[self.userDic valueForKey:@"id"] integerValue] withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
            [SVProgressHUD dismiss];
        }];
    }
}

- (IBAction) actionBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:TRUE];
}

- (IBAction) actionMenu:(id)sender
{
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}


@end

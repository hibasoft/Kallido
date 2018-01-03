//
//  KLDefinitions.h
//  Kaliido
//
//  Created by Daron 14/02/2014.
//  Copyright (c) 2014 Kaliido. All rights reserved.
//

#ifndef Q_municate_Definitions_h
#define Q_municate_Definitions_h

#define KL_TEST 0

#define KL_AUDIO_VIDEO_ENABLED 1

#define DELETING_DIALOGS_ENABLED 0

#define IS_HEIGHT_GTE_568 [[UIScreen mainScreen ] bounds].size.height >= 568.0f
#define $(...)  [NSSet setWithObjects:__VA_ARGS__, nil]

#define CHECK_OVERRIDE()\
@throw\
[NSException exceptionWithName:NSInternalInconsistencyException \
reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]\
userInfo:nil]


#define APP_DELEGATE  ((AppDelegate*)[[UIApplication sharedApplication] delegate])
#define INTERFACE_IS_PAD     ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define INTERFACE_IS_PHONE   ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
 

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)


//////////color

#define KLLIGHTBLUE [UIColor colorWithHex:0x13a4e0]
#define KLLIGHTPURPLE [UIColor colorWithHex:0x554ea8]
#define KLLIGHTGREEN [UIColor colorWithHex:0x8ec33c]
/////////

typedef enum {
    KLMessageTypeText, // Default
    KLMessageTypeImage,
    KLMessageTypeVideo,
    KLMessageTypeLocation,
    KLMessageTypeGift
} KLMessageType;

//************** Segue Identifiers *************************
static NSString *const kTabBarSegueIdnetifier         = @"TabBarSegue";
static NSString *const kSplashSegueIdentifier         = @"SplashSegue";
static NSString *const kWelcomeScreenSegueIdentifier  = @"WelcomeScreenSegue";
static NSString *const kSignUpSegueIdentifier         = @"SignUpSegue";
static NSString *const kLogInSegueSegueIdentifier     = @"LogInSegue";
static NSString *const kDetailsSegueIdentifier        = @"DetailsSegue";
static NSString *const kVideoCallSegueIdentifier      = @"VideoCallSegue";
static NSString *const kAudioCallSegueIdentifier      = @"AudioCallSegue";
static NSString *const kGoToDuringAudioCallSegueIdentifier = @"goToDuringAudioCallSegueIdentifier";
static NSString *const kGoToDuringVideoCallSegueIdentifier = @"goToDuringVideoCallSegueIdentifier";
static NSString *const kChatViewSegueIdentifier       = @"ChatViewSegue";
static NSString *const kIncomingCallIdentifier        = @"IncomingCallIdentifier";
static NSString *const kProfileSegueIdentifier        = @"ProfileSegue";
static NSString *const kCreateNewChatSegueIdentifier  = @"CreateNewChatSegue";
static NSString *const kContentPreviewSegueIdentifier = @"ContentPreviewIdentifier";
static NSString *const kGroupDetailsSegueIdentifier   = @"GroupDetailsSegue";
static NSString *const kKLAddMembersToGroupControllerSegue = @"KLAddMembersToGroupControllerSegue";
static NSString *const KTermsAndConditionsSegue   = @"TermsAndConditionsSegue";

static NSString *const kSettingsCellBundleVersion = @"CFBundleVersion";

//******************** USER DEFAULTS KEYS *****************
static NSString *const kMailSubjectString               = @"Kaliido";
static NSString *const kMailBodyString                  = @"<a href='http://www.kaliido.com/'>Join us @ Kaliido!</a>";

#endif

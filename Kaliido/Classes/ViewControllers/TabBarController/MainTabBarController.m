//
//  MainTabBarController.m
//  Kaliido
//
//  Created by Daron21/02/2014.
//  Copyright (c) 2014 Kaliido. All rights reserved.
//

#import "MainTabBarController.h"

#import "KLApi.h"
#import "KLImageView.h"
#import "MPGNotification.h"
#import "KLSettingsManager.h"
#import "UIViewController+ECSlidingViewController.h"
#import "MEDynamicTransition.h"
#import "METransitions.h"
#import "KLAccessTokenResponse.h"
#import "KLAuthWebService.h"
#import "KLWebService.h"
#import "AppDelegate.h"
#import "REAlertView.h"
#import <AudioToolbox/AudioToolbox.h>
#import "REAlertView+KLSuccess.h"
#import <UIKit/UIKit.h>
@interface MainTabBarController ()
    @property (nonatomic, strong) METransitions *transitions;
    @property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;
    @property (nonatomic) int badgeValue;
@end


@implementation MainTabBarController


- (void)dealloc
{
//    [[ChatReceiver instance] unsubscribeForTarget:self];
}


-(void)makeRecieveSound{
    
    SystemSoundID soundID;
    
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"message-receive" ofType:@"wav"];
    NSURL *soundUrl = [NSURL fileURLWithPath:soundPath];
    
    AudioServicesCreateSystemSoundID ((__bridge CFURLRef)soundUrl, &soundID);
    AudioServicesPlaySystemSound(soundID);
    
}

- (void)changeBadgeValue:(BOOL)increase increaseAmount:(int)value
{
    if(increase)
    {
        self.badgeValue = self.badgeValue + value;
    }else{
        self.badgeValue = self.badgeValue - value;
    }
    
    NSString* badgeString = [NSString stringWithFormat:@"%d", self.badgeValue];
   
    UITabBarItem* item = [[self.tabBar items] objectAtIndex:1];
    
    [item setBadgeValue:badgeString];
    
    
}


- (void)newMessageReceived:(NSNotification *) notification {
    
    NSDictionary *messageContent = notification.userInfo;
    
    NSString *m = [messageContent objectForKey:@"msg"];
    NSString* sender = [messageContent objectForKey:@"sender"];
    
    
    NSString* ejabberdUserId = [NSString stringWithFormat:@"%@@klsocial.404la.be",[KLUser.currentUser.getUserDic objectForKey:@"quickbloxUserId"] ];
    if ([sender isEqualToString:ejabberdUserId]) {
        return;
    }

    
    
    //[self changeBadgeValue:YES increaseAmount:1];
    
    MPGNotification *localNotification =
    [MPGNotification notificationWithTitle:@"Chat Message:"
                                  subtitle:m
                           backgroundColor:[UIColor purpleColor]
                                 iconImage:nil];
    
    // auto-dismiss after desired time in seconds
    localNotification.duration = 3.0;
    
    // button & touch handling
    localNotification.backgroundTapsEnabled = YES;
    [localNotification setButtonConfiguration:MPGNotificationButtonConfigrationOneButton withButtonTitles:@[@"Reply"]];
    
    // set animation type
    localNotification.animationType = MPGNotificationAnimationTypeDrop;
    
    // show the notification and handle button taps
    // (self.firstButton is the Reply button, self.backgroundView is the background tap)
    [localNotification show];
    [self makeRecieveSound];
    int count = [[self.tabBarItem badgeValue] intValue] + 1;
    
    [self.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%d", count]];
    
}




- (void)viewDidLoad {
    [super viewDidLoad];
    

//    self.chatDelegate = self;
    self.badgeValue = 0;
  //  NSLog(@"%@", tokenResponse);
    
    [self customizeTabBar];

    [self subscribeToNotifications];
    __weak __typeof(self)weakSelf = self;
    
    NSDictionary *push = [[KLApi instance] pushNotification];
    
    if (push != nil) {
               if( push[@"dialog_id"] ){
                   //[self changeBadgeValue:YES increaseAmount:1];
            [SVProgressHUD show];
            
            [[KLApi instance] openChatPageForPushNotification:push completion:^(BOOL completed) {
                [SVProgressHUD dismiss];
            }];
            
            [[KLApi instance] setPushNotification:nil];
        }
    }
    
    // subscribe to push notifications
    [[KLApi instance] subscribeToPushNotificationsForceSettings:YES complete:^(BOOL subscribeToPushNotificationsSuccess) {
        
        if (!subscribeToPushNotificationsSuccess) {
            [KLApi instance].settingsManager.pushNotificationsEnabled = NO;
        }
        [KLApi instance].settingsManager.pushNotificationsEnabled = YES;
    }];
    

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(newMessageReceived:)
                                                 name:kMESSAGE_RECEIVED
                                               object:nil];
    
    
    
    [[KLApi instance] fetchAllHistory:^{
        [weakSelf loginToChat];
    }];

    // cofigure transition
    {
        NSDictionary *transitionData = self.transitions.all[0];
        id<ECSlidingViewControllerDelegate> transition = transitionData[@"transition"];
        if (transition == (id)[NSNull null]) {
            self.slidingViewController.delegate = nil;
        } else {
            self.slidingViewController.delegate = transition;
        }
        
        NSString *transitionName = transitionData[@"name"];
        if ([transitionName isEqualToString:METransitionNameDynamic]) {
            self.slidingViewController.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping | ECSlidingViewControllerAnchoredGestureCustom;
            self.slidingViewController.customAnchoredGestures = @[self.dynamicTransitionPanGesture];
            [self.navigationController.view removeGestureRecognizer:self.slidingViewController.panGesture];
            [self.navigationController.view addGestureRecognizer:self.dynamicTransitionPanGesture];
        } else {
            self.slidingViewController.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping | ECSlidingViewControllerAnchoredGesturePanning;
            self.slidingViewController.customAnchoredGestures = @[];
            [self.navigationController.view removeGestureRecognizer:self.dynamicTransitionPanGesture];
            [self.navigationController.view addGestureRecognizer:self.slidingViewController.panGesture];
        }
    }
    self.slidingViewController.anchorRightRevealAmount = 240;
}

- (void)loginToChat
{
    
    
    [[KLXMPPTool sharedInstance] loginWithJID:[XMPPJID jidWithUser:[NSString stringWithFormat:@"%lu", (unsigned long)KLUser.currentUser.quickbloxUserId] domain:@"klsocial.404la.be" resource:@"Kaliido-App-iOSv1.0"] andPassword:[[KLApi instance] settingsManager].password];
  
    
}

- (void) viewWillAppear:(BOOL)animated
{
    if ([(NSObject *)self.slidingViewController.delegate isKindOfClass:[MEDynamicTransition class]]) {
        MEDynamicTransition *dynamicTransition = (MEDynamicTransition *)self.slidingViewController.delegate;
        if (!self.dynamicTransitionPanGesture) {
            self.dynamicTransitionPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:dynamicTransition action:@selector(handlePanGesture:)];
        }
        
        [self.view removeGestureRecognizer:self.slidingViewController.panGesture];
        [self.view addGestureRecognizer:self.dynamicTransitionPanGesture];
    } else {
        [self.view removeGestureRecognizer:self.dynamicTransitionPanGesture];
        [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    }
    
    [self.selectedViewController viewWillAppear:animated];
}

- (void) viewDidAppear:(BOOL)animated
{
    [self.selectedViewController viewDidAppear:animated];
}

#pragma mark configure
- (METransitions *)transitions {
    if (_transitions) return _transitions;
    
    _transitions = [[METransitions alloc] init];
    
    return _transitions;
}

- (UIPanGestureRecognizer *)dynamicTransitionPanGesture {
    if (_dynamicTransitionPanGesture) return _dynamicTransitionPanGesture;
    
    _dynamicTransitionPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.transitions.dynamicTransition action:@selector(handlePanGesture:)];
    
    return _dynamicTransitionPanGesture;
}

- (IBAction) actionMenu:(id)sender
{
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)subscribeToNotifications
{
    
}

- (void)customizeTabBar {
    
}


#pragma mark - TabBarDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    UITabBarItem *neededTab = tabBar.items[0];
    if ([item isEqual:neededTab]) {
        if ([self.tabDelegate respondsToSelector:@selector(friendsListTabWasTapped:)]) {
            [self.tabDelegate friendsListTabWasTapped:item];
        }
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end

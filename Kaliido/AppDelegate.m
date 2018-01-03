//
//  AppDelegate.m
//  Kaliido
//
//  Created by Daron on 5/30/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//kjhkjhk

#import "AppDelegate.h"

//#import "KLPopoversFactory.h"
#import "REAlertView+KLSuccess.h"
#import "KLApi.h"
//#import "SCTwitter.h"
#import <RestKit/RestKit.h>
#import "KLUserRegistration.h"
#import "KLAuthWebService.h"

#define DEVELOPMENT 0

#if DEVELOPMENT



#else



#endif

/* ==================================================================== */

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else{
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
    }
#else
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
#endif
    // Override point for customization after application launch.
    //    [SCTwitter initWithConsumerKey:@"bZJfIDOISHyaHFzvqKGRZkRew" consumerSecret:@"JFxuFMnvYyy2MGw0e44BHaxUZTZ4nFGrN2NqWQYVX7EiS8RWxS"];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    UIApplication.sharedApplication.applicationIconBadgeNumber = 0;
    
//    [[SVProgressHUD appearance] setHudBackgroundColor:[UIColor colorWithRed:70.0f/255.0f green:57.0f/255.0f blue:139.0f/255.0f alpha:0.5]];
//    [[SVProgressHUD appearance] setHudForegroundColor: [UIColor colorWithWhite:0.935 alpha:0.260]];
//    [[SVProgressHUD appearance] setHudStatusShadowColor:[UIColor greenColor]];
//    [[SVProgressHUD appearance] setAlpha:0.6];
    
    /*Configure app appearance*/
    NSDictionary *normalAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithWhite:1.000 alpha:0.750]};
    NSDictionary *disabledAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithWhite:0.935 alpha:0.260]};
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:normalAttributes forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setTitleTextAttributes:disabledAttributes forState:UIControlStateDisabled];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil] setTitleTextAttributes:nil forState:UIControlStateNormal];
    [[UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil] setTitleTextAttributes:nil forState:UIControlStateDisabled];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:(float)0x46/0xff green:(float)0x39/0xff blue:(float)0x8B/0xff alpha:1.0f]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:normalAttributes];
    
    [[SVProgressHUD appearance] setBackgroundColor:[UIColor colorWithRed:0.046 green:0.377 blue:0.633 alpha:1.000]];
    
    // Fire services:
    [KLApi instance];
    
    if (launchOptions != nil) {
        NSDictionary *notification = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];

    }
    
    UIAlertView * alert;
    if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusDenied){
        
        alert = [[UIAlertView alloc]initWithTitle:@""
                                          message:@"The app doesn't work without the Background App Refresh enabled. To turn it on, go to Settings > General > Background App Refresh"
                                         delegate:nil
                                cancelButtonTitle:@"Ok"
                                otherButtonTitles:nil, nil];
        [alert show];
        
    }else if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusRestricted){
        
        alert = [[UIAlertView alloc]initWithTitle:@""
                                          message:@"The functions of this app are limited because the Background App Refresh is disable."
                                         delegate:nil
                                cancelButtonTitle:@"Ok"
                                otherButtonTitles:nil, nil];
        [alert show];
        
    } else{
        
        self.locationTracker = [[LocationTracker alloc]init];
        [self.locationTracker startLocationTracking];
        
        //Send the best location to server every 60 seconds
        //You may adjust the time interval depends on the need of your app.
        NSTimeInterval time = 120.0;
        self.locationUpdateTimer =
        [NSTimer scheduledTimerWithTimeInterval:time
                                         target:self
                                       selector:@selector(updateLocation)
                                       userInfo:nil
                                        repeats:YES];
        
        [NSTimer scheduledTimerWithTimeInterval:15.0
                                         target:self
                                       selector:@selector(updateLocation)
                                       userInfo:nil
                                        repeats:NO];
    }
    
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    return YES;
}

void uncaughtExceptionHandler(NSException *exception)
{
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
}
-(void)updateLocation {
    NSLog(@"updateLocation");
    
    [self.locationTracker updateLocationToServer];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    
    NSLog(@"Push war received. User info: %@", userInfo);
    UIApplication.sharedApplication.applicationIconBadgeNumber += 1;
    [[KLApi instance] setPushNotification:userInfo];
    
    
}






- (void)applicationDidEnterBackground:(UIApplication *)application {
   // UIApplication.sharedApplication.applicationIconBadgeNumber = 0;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    if (!KLApi.instance.isInternetConnected) {
        [REAlertView showAlertWithMessage:NSLocalizedString(@"KL_STR_CHECK_INTERNET_CONNECTION", nil) actionSuccess:NO];
        return;
    }
    if (!KLUser.currentUser) {
        return;
    }

}

- (void)applicationWillResignActive:(UIApplication *)application {
    [[KLXMPPTool sharedInstance] goOffline];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
     
    [[KLXMPPTool sharedInstance] goOnline];
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[KLXMPPTool sharedInstance] goOffline];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:sourceApplication
                                                               annotation:annotation
                    ];
    // Add any custom logic here.
    return handled;
}


#pragma mark - PUSH NOTIFICATIONS REGISTRATION

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    if (deviceToken) {
        [[KLApi instance] setDeviceToken:deviceToken];
        NSString *tokenString = [NSString stringWithUTF8String:[deviceToken bytes]]; //[[NSString alloc]initWithData:newDeviceToken encoding:NSUTF8StringEncoding];
        NSLog(@"%@", tokenString);
        NSLog(@"%@", deviceToken);;
        [self setDeviceToken:tokenString];
        [[KLApi instance] registerWithDeviceToken:self.userId  completion:^(BOOL success) {
            if(success)
            {
                [REAlertView showAlertWithMessage:@"Push Notifications has been enabled for your device" actionSuccess:true];
                
            }else{
                [REAlertView showAlertWithMessage:@"Push Notifications could not be enabled on your device" actionSuccess:false];

            }
        }];

        
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{

    
    NSLog(@" Recievied Local Notification : %@", notification);
    
    
    
}


- (void) logout
{
    
    
    [[KLApi instance] unSubscribeToPushNotifications:^(BOOL success) {
        if(success)
        {
            [[KLApi instance] setDeviceToken:nil];
        }else{

        }
        
        self.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SplashViewController"];
        [REAlertView presentAlertViewWithConfiguration:^(REAlertView *alertView) {
            alertView.title = @"";
            alertView.message = @"Your account has expired, or your password has been reset. Please login with your details again.";
            [alertView addButtonWithTitle:NSLocalizedString(@"KL_STR_OK", nil) andActionBlock:^{}];
        }];
    }];

    
    
    
}







@end

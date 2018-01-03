//
//  AppDelegate.h
//  Kaliido
//
//  Created by Daron on 5/30/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationTracker.h"
#import "KLAuthWebService.h"


@class ECSlidingViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    
    NSString *password;
    int userId;
    NSString *ejabberdDomain;
    BOOL isOpen;
    NSString* deviceToken;
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) id rootViewController;
@property (strong, nonatomic) id slideoutController;
@property (strong, nonatomic) UIViewController *viewControllerTabbar;
@property LocationTracker * locationTracker;
@property (nonatomic) NSTimer* locationUpdateTimer;
@property (strong, nonatomic) KLAuthWebService *authenticationService;

@property (strong, nonatomic) KLAccessTokenResponse* token;

@property (strong, nonatomic) NSString* deviceToken;

@property (strong, nonatomic) NSString* userName;

@property (strong, nonatomic) NSString* password;

@property (nonatomic) int userId;

@property (strong, nonatomic) NSString* ejabberdDomain;

@property (weak, nonatomic) ECSlidingViewController *slidingViewController;




- (void) logout;


@end

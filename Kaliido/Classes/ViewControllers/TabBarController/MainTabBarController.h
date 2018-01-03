//
//  MainTabBarController.h
//  Kaliido
//
//  Created by Daron21/02/2014.
//  Copyright (c) 2014 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FriendsTabDelegate <NSObject>
@optional
- (void)friendsListTabWasTapped:(UITabBarItem *)tab;
@end


@interface MainTabBarController : UITabBarController


@property (nonatomic, weak) id <FriendsTabDelegate> tabDelegate;
@property (nonatomic, weak) id slideoutController;


- (void)changeBadgeValue:(BOOL)increase increaseAmount:(int)value;
- (void)newMessageReceived:(NSNotification *) notification;

@end

//
//  FriendsDetailsController.h
//  Kaliido
//
//  Created by Daron28/02/2014.
//  Copyright (c) 2014 Kaliido. All rights reserved.
//0

#import <UIKit/UIKit.h>
#import "StaticDataTableViewController.h"

@interface FriendsDetailsController : StaticDataTableViewController

@property (strong, nonatomic) KLUser *selectedUser;
@property (strong, nonatomic) NSDictionary *userDic;
- (IBAction)addButtonClicked:(id)sender;
- (IBAction) actionComment:(id)sender;
@end

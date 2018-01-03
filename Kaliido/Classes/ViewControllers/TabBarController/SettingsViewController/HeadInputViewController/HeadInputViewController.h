//
//  HeadInputViewController.h
//  Kaliido
//
//  Created by  Kaliido on 8/31/15.
//  Copyright (c) 2015 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLPlaceholderTextView.h"
#import "ProfileViewController.h"
#import "YourDetailsViewController.h"

@interface HeadInputViewController : UIViewController
@property (strong, nonatomic) IBOutlet KLPlaceholderTextView *viewEdit;
@property (strong, nonatomic) ProfileViewController *parent;
@property (strong, nonatomic) YourDetailsViewController *detailParent;
@end

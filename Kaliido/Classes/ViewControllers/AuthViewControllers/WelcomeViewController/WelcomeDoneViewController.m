//
//  WelcomeDoneViewController.m
//  Kaliido
//
//  Created by  Kaliido on 10/29/15.
//  Copyright © 2015 Kaliido. All rights reserved.
//

#import "WelcomeDoneViewController.h"
#import "AppDelegate.h"
#import "ECSlidingViewController.h"

@interface WelcomeDoneViewController ()

@end

@implementation WelcomeDoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ECSlidingViewController *vc = [segue destinationViewController];
    UITabBarController *tabVC = (UITabBarController*)vc.topViewController;
    [tabVC setSelectedIndex:0];
}
@end

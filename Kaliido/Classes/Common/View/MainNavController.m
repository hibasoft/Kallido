//
//  MainNavController.m
//  Kaliido
//
//  Created by Phoenix on 6/25/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "MainNavController.h"
#import "UIColor+Hex.h"
#import "MEMenuViewController.h"
@interface MainNavController ()

@end

@implementation MainNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configureView];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //change left side bar to "Main" Mode
    NSDictionary* userInfo = @{@"MenuMode": [NSNumber numberWithInt:KLMenuMain]};
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"updateLeftMenu"
     object:self userInfo:userInfo];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods

- (void)configureView
{
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

#pragma mark - Status Bar

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

#pragma mark - Interface Orientation

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if([self.topViewController respondsToSelector:@selector(supportedInterfaceOrientations)])
    {
        return(NSInteger)[self.topViewController performSelector:@selector(supportedInterfaceOrientations) withObject:nil];
    }
    
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    if([self.visibleViewController respondsToSelector:@selector(shouldAutorotate)])
    {
        BOOL autoRotate = (BOOL)[self.visibleViewController
                                 performSelector:@selector(shouldAutorotate)
                                 withObject:nil];
        return autoRotate;
        
    }
    return NO;
}

@end

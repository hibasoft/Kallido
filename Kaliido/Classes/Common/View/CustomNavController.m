//
//  CustomNavController.m
//  Kaliido
//
//  Created by Vadim Budnik on 6/21/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "CustomNavController.h"
#import "UIColor+Hex.h"

@interface CustomNavController ()

@end

@implementation CustomNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configureView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods

- (void)configureView
{
//    [self.navigationBar setTintColor:COLOR_PRIMARY];
}

#pragma mark - Status Bar

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
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

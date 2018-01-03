//
//  SlideMenuNavViewController.m
//  Kaliido
//
//  Created by  Kaliido on 1/19/15.
//  Copyright (c) 2015 Kaliido. All rights reserved.
//

#import "SlideMenuNavViewController.h"
#import "UIViewController+ECSlidingViewController.h"
#import "MEDynamicTransition.h"
#import "MEMenuViewController.h"

@interface SlideMenuNavViewController ()
@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;

@end

@implementation SlideMenuNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
}

-(void) viewWillAppear:(BOOL)animated
{
    
    //change left side bar to "Me" Mode
    NSDictionary* userInfo = @{@"MenuMode": [NSNumber numberWithInt:KLMenuMe]};

    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"updateLeftMenu"
     object:self userInfo:userInfo];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end

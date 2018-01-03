//
//  LeftSlideViewController.m
//  Kaliido
//
//  Created by  Kaliido on 1/19/15.
//  Copyright (c) 2015 Kaliido. All rights reserved.
//

#import "LeftSlideViewController.h"
#import "UIViewController+ECSlidingViewController.h"
#import "MEDynamicTransition.h"

@interface LeftSlideViewController ()

@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;

@end

@implementation LeftSlideViewController

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction) actionMenu:(id)sender
{
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

@end

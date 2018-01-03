//
//  DirectoryPageViewController.m
//  Kaliido
//
//  Created by Vadim Budnik on 6/21/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "DirectoryPageViewController.h"

@interface DirectoryPageViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>
{
    NSMutableArray *arPageIdentifiers;
}

@end

@implementation DirectoryPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods

- (void)configureView
{
    self.delegate = self;
    self.dataSource = self;
    
    arPageIdentifiers = [@[] mutableCopy];
    [arPageIdentifiers addObject:@"DHFeaturedViewController"];
    [arPageIdentifiers addObject:@"DHDirectoryViewController"];
    
    
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    UIViewController *childViewController = [[SharedManager sharedManager] loadViewControllerFromStoryboard:@"Directory" ViewControllerIdentifier:[arPageIdentifiers objectAtIndex:index]];
    
    return childViewController;
}

- (NSUInteger)indexOfViewController:(UIViewController *)viewController {
    
    NSString *restorationId = viewController.restorationIdentifier;
    return [arPageIdentifiers indexOfObject:restorationId];
}

#pragma mark - Actions

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - UIPageViewControllerDelegate & UIPageViewControllerDataSource

- (UIViewController*)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(UIViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController*)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(UIViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [arPageIdentifiers count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

@end

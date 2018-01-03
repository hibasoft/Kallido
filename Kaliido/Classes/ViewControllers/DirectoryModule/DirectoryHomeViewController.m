//
//  DirectoryHomeViewController.m
//  Kaliido
//
//  Created by Vadim Budnik on 6/21/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "DirectoryHomeViewController.h"
#import "DirectoryContainerViewController.h"
#import "DirectorySubViewController.h"
#import "CategoryViewModel.h"

#import "UIViewController+ECSlidingViewController.h"

#define SegueIdentifierFeatured     @"embedFeatured"
#define SegueIdentifierDirectory    @"embedDirectory"

@interface DirectoryHomeViewController () <DirectoryContainerDelegate>
{
    DirectoryContainerViewController *containerViewController;
}

@end

@implementation DirectoryHomeViewController

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
    [self.navigationItem setTitle:@"LIFESTYLE"];
    
    UIBarButtonItem *btMenu = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu_item"] style:UIBarButtonItemStylePlain target:self action:@selector(didRequestToOpenMenu:)];
    [self.navigationItem setLeftBarButtonItem:btMenu];
    
    btFeatured.backgroundColor = [UIColor lightGrayColor];
    btDirectory.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

#pragma mark - Actions

- (void)didRequestToOpenMenu:(id)sender
{
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

- (IBAction)didRequestToSwitchToFeatured:(id)sender
{
    if (![containerViewController.currentSegueIdentifier isEqualToString:SegueIdentifierFeatured])
    {
        btFeatured.backgroundColor = [UIColor groupTableViewBackgroundColor];
        btDirectory.backgroundColor = [UIColor lightGrayColor];
        [containerViewController swapViewControllers];
    }
}

- (IBAction)didRequestToSwitchToDirectory:(id)sender
{
    if (![containerViewController.currentSegueIdentifier isEqualToString:SegueIdentifierDirectory])
    {
        btFeatured.backgroundColor = [UIColor lightGrayColor];
        btDirectory.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [containerViewController swapViewControllers];
    }
}

#pragma mark - Navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqual:@"Container"])
    {
        containerViewController = (DirectoryContainerViewController *)[segue destinationViewController];
        containerViewController.delegate = self;
    }
}

#pragma mark - DirectoryContainerViewController Delegate

- (void)didSelectDirectoryCategory:(CategoryViewModel *)selectedCategory
{
    DirectorySubViewController *subViewController = (DirectorySubViewController*)[[SharedManager sharedManager] loadViewControllerFromStoryboard:@"Directory" ViewControllerIdentifier:@"DirectorySubViewController"];
    subViewController.selectedCategory = selectedCategory;
    
    [self.navigationController pushViewController:subViewController animated:YES];
}


@end

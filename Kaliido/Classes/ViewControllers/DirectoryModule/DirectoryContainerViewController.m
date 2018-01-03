//
//  DirectoryContainerViewController.m
//  Kaliido
//
//  Created by Vadim Budnik on 6/23/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "DirectoryContainerViewController.h"
#import "DHFeaturedViewController.h"
#import "DHDirectoryViewController.h"
#import "CategoryViewModel.h"
#define SegueIdentifierFeatured     @"embedFeatured"
#define SegueIdentifierDirectory    @"embedDirectory"

@interface DirectoryContainerViewController () <DHFeaturedVCProtocol, DHDirectoryVCProtocol>

@property (strong, nonatomic) DHFeaturedViewController *featuredViewController;
@property (strong, nonatomic) DHDirectoryViewController *directoryViewController;
@property (assign, nonatomic) BOOL transitionInProgress;

@end

@implementation DirectoryContainerViewController

@synthesize delegate;

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
    self.transitionInProgress = NO;
    self.currentSegueIdentifier = SegueIdentifierFeatured;
    [self performSegueWithIdentifier:self.currentSegueIdentifier sender:nil];
}

- (void)swapViewControllers
{
    if (self.transitionInProgress) {
        return;
    }
    
    self.transitionInProgress = YES;
    self.currentSegueIdentifier = ([self.currentSegueIdentifier isEqualToString:SegueIdentifierFeatured]) ? SegueIdentifierDirectory : SegueIdentifierFeatured;
    
    if (([self.currentSegueIdentifier isEqualToString:SegueIdentifierFeatured]) && self.featuredViewController) {
        [self swapFromViewController:self.directoryViewController toViewController:self.featuredViewController];
        return;
    }
    
    if (([self.currentSegueIdentifier isEqualToString:SegueIdentifierDirectory]) && self.directoryViewController) {
        [self swapFromViewController:self.featuredViewController toViewController:self.directoryViewController];
        return;
    }
    
    [self performSegueWithIdentifier:self.currentSegueIdentifier sender:nil];
}

- (void)swapFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController
{
    toViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [fromViewController willMoveToParentViewController:nil];
    [self addChildViewController:toViewController];
    
    [self transitionFromViewController:fromViewController toViewController:toViewController duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
        [fromViewController removeFromParentViewController];
        [toViewController didMoveToParentViewController:self];
        self.transitionInProgress = NO;
    }];
}

#pragma mark - Actions

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:SegueIdentifierFeatured]) {
        self.featuredViewController = segue.destinationViewController;
        self.featuredViewController.delegate = self;
    }
    
    if ([segue.identifier isEqualToString:SegueIdentifierDirectory]) {
        self.directoryViewController = segue.destinationViewController;
        self.directoryViewController.delegate = self;
    }
    
    // If we're going to the featured view controller.
    if ([segue.identifier isEqualToString:SegueIdentifierFeatured]) {
        // If this is not the first time we're loading this.
        if (self.childViewControllers.count > 0) {
            [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:self.featuredViewController];
        }
        else {
            // If this is the very first time we're loading this we need to do
            // an initial load and not a swap.
            [self addChildViewController:segue.destinationViewController];
            UIView* destView = ((UIViewController *)segue.destinationViewController).view;
            destView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            destView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            [self.view addSubview:destView];
            [segue.destinationViewController didMoveToParentViewController:self];
        }
    }
    // By definition the directory view controller will always be swapped with the
    // featured one.
    else if ([segue.identifier isEqualToString:SegueIdentifierDirectory]) {
        [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:self.directoryViewController];
    }
}

#pragma mark - DHFeaturedViewController Delegate


#pragma mark - DHDirectoryViewController Delegate

- (void)didSelectCategory:(CategoryViewModel *)selectedItem
{
    if ([(id)delegate respondsToSelector:@selector(didSelectDirectoryCategory:)])
    {
        [delegate didSelectDirectoryCategory:selectedItem];
    }
}


@end

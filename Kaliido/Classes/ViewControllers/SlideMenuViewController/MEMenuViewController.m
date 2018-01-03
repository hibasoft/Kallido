
#import "MEMenuViewController.h"
#import "UIViewController+ECSlidingViewController.h"
#import "KLApi.h"
#import "KLLocationService.h"
#import "AppDelegate.h"

#import "SharedManager.h"
#import "CustomNavController.h"
#import "DirectoryHomeViewController.h"

static NSString *CellIdentifier = @"MenuCell";

@interface MEMenuViewController ()

@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, strong) NSArray *iconItems;
@property (nonatomic, strong) UINavigationController *transitionsNavigationController;

@end

@implementation MEMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // topViewController is the transitions navigation controller at this point.
    // It is initially set as a User Defined Runtime Attributes in storyboards.
    // We keep a reference to this instance so that we can go back to it without losing its state.
    self.transitionsNavigationController = (UINavigationController *)self.slidingViewController.topViewController;
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    delegate.viewControllerTabbar = self.transitionsNavigationController;
    self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.width/2;
    self.lblNotification.layer.cornerRadius = self.lblNotification.frame.size.width/2;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProfile) name:@"updateCurrentUser" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLeftMenubyMode:) name:@"updateLeftMenu" object:nil];
    
    delegate.slidingViewController = self.slidingViewController;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateProfile];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

#pragma mark - Properties

- (NSArray *)menuItems {
    
    if (self.nMenuMode == KLMenuMain)
    {
    
        _menuItems = @[NSLocalizedString(@"KL_STR_CONNECT", nil) ,     NSLocalizedString(@"KL_STR_VENUES", nil),      NSLocalizedString(@"KL_STR_STUMBLER", nil),    NSLocalizedString(@"KL_STR_LIFESTYLE", nil),       NSLocalizedString(@"KL_STR_COMMUNITY", nil),       NSLocalizedString(@"KL_STR_SETTINGS", nil)];
        _iconItems = @[@"mnuicon1",     @"mnuicon6",    @"mnuicon2",    @"mnuicon3",        @"mnuicon4",        @"mnuicon5"];
    }else if (self.nMenuMode == KLMenuMe){
        _menuItems = @[NSLocalizedString(@"KL_STR_ACTIVITIES", nil),  NSLocalizedString(@"KL_STR_CREATEPAGE", nil), NSLocalizedString(@"KL_STR_LABS", nil),        NSLocalizedString(@"KL_STR_SETTINGS", nil)];
        _iconItems = @[@"mnuicon2",     @"mnuicon6",    @"labs",    @"mnuicon5"];
    }
    
    return _menuItems;
}
#pragma mark - Notification

- (void) updateProfile
{
    self.lblProfileName.text = [KLUser.currentUser.getUserDic objectForKey:@"fullName"];
    self.lblEmailAddress.text = KLUser.currentUser.email;
    UIImage *placeholder = [UIImage imageNamed:@"upic-placeholder"];
    NSURL *url = [KLUsersUtils userAvatarURL:KLUser.currentUser];
    
    [self.imgProfile setImageWithURL:url
                         placeholder:placeholder
                             options:SDWebImageHighPriority
                            progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                NSLog(@"r - %d; e - %d", receivedSize, expectedSize);
                            } completedBlock:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.width/2;
                                self.imgProfile.clipsToBounds = YES;
                                self.imgProfile.layer.masksToBounds = YES;
                            }];
    self.lblNotification.hidden = YES;
}

#pragma mark - Update Menu by name
- (void) updateLeftMenubyMode:(NSNotification *) notification
{
    NSDictionary *userInfo = notification.userInfo;
    self.nMenuMode = [[userInfo objectForKey:@"MenuMode"] intValue];
    
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (self.nMenuMode) {
        case KLMenuMain:
            return 6;
            
        case KLMenuMe:
            return 4;
            
        default:
            return 0;
            
    }
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    //view.backgroundColor = [UIColor clearColor];
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SlideMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    view.backgroundColor = [UIColor colorWithRed:96/255.0f green:84/255.0f blue:157/255.0f alpha:1.0f];
    cell.selectedBackgroundView = view;
    
    NSString *menuItem = self.menuItems[indexPath.row];
    NSString *iconName = self.iconItems[indexPath.row];
    cell.imgCategoryIcon.image = [UIImage imageNamed:iconName];
    cell.lblCategoryName.text = menuItem;
    [cell setBackgroundColor:[UIColor clearColor]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    
    NSString *menuItem = self.menuItems[indexPath.row];
    
    self.slidingViewController.topViewController.view.layer.transform = CATransform3DMakeScale(1, 1, 1);
    
    if ([menuItem isEqualToString:@"Connect"])
    {
        UITabBarController *controller = (UITabBarController*) self.transitionsNavigationController;
        self.slidingViewController.topViewController = controller;        
    }
    else if ([menuItem isEqualToString:@"Venues"])
    {
        self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Venues"];
    }
    else if ([menuItem isEqualToString:@"Stumbler"])
    {
        UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Stumbler"];
        self.slidingViewController.topViewController = controller;
    }
    else if ([menuItem isEqualToString:@"Lifestyle"])
    {
        DirectoryHomeViewController *directoryHomeController = (DirectoryHomeViewController*)[[SharedManager sharedManager] loadViewControllerFromStoryboard:@"Directory" ViewControllerIdentifier:@"DirectoryHomeViewController"];
        CustomNavController *navController = [[CustomNavController alloc] initWithRootViewController:directoryHomeController];
        self.slidingViewController.topViewController = navController;
    }
    else if ( [menuItem isEqualToString:@"Community"])
    {
        self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Halo"];
    }
    else if ( [menuItem isEqualToString:@"Settings"])
    {
        self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingController"];
    }else if ([menuItem isEqualToString:@"Activities"])
    {
//        UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Stumbler"];
//        self.slidingViewController.topViewController = controller;
    }else if ([menuItem isEqualToString:@"Create Page"])
    {
//        UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Stumbler"];
//        self.slidingViewController.topViewController = controller;
    }else if ([menuItem isEqualToString:@"Labs"])
    {
//        UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Stumbler"];
//        self.slidingViewController.topViewController = controller;
    }

        
    [self.slidingViewController resetTopViewAnimated:YES];
    
//    if ([menuItem isEqualToString:@"SIGNOUT"])
//    {
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userID"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        [self.slidingViewController.navigationController popToRootViewControllerAnimated:TRUE];
//    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


@end

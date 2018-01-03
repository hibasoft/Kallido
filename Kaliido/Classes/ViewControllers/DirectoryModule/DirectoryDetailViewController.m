//
//  DirectoryDetailViewController.m
//  Kaliido
//
//  Created by Vadim Budnik on 6/21/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "DirectoryDetailViewController.h"
#import "DirectoryDetailHeader.h"
#import "Directory.h"
#import "DirectoryViewModel.h"
#import "DirectoryPerkCell.h"
#import "PerksViewModel.h"
#import "Perk.h"
#import "DirectoryFollowerCell.h"
#import "Follower.h"
#import "FollowerViewModel.h"
#import "FollowersViewModel.h"
#import "DirectoryStumblerCell.h"
#import "Stumbler.h"
#import "StumblerViewModel.h"
#import "StumblersViewModel.h"
#import "DirectoryAboutCell.h"
#import "DirectoryPostCell.h"
#import "PostPagesViewModel.h"
#import "PostPage.h"

static NSString *aboutCellIdentifier = @"DirectoryAboutCell";
static NSString *perkCellIdentifier = @"DirectoryPerkCell";
static NSString *followerCellIdentifier = @"DirectoryFollowerCell";
static NSString *stumblerCellIdentifier = @"DirectoryStumblerCell";
static NSString *postCellIdentifier = @"DirectoryPostCell";

@interface DirectoryDetailViewController () <UITableViewDelegate, UITableViewDataSource, DirectoryDetailHeaderDelegate, DirectoryAboutCellDelegate, DirectoryFollowerCellDelegate, DirectoryPerkCellDelegate, DirectoryStumblerCellDelegate, DirectoryPostCellDelegate>
{
    NSMutableArray *arPerks;
    NSMutableArray *arFollowers;
    NSMutableArray *arStumblers;
    NSMutableArray *arPosts;
}

@end

@implementation DirectoryDetailViewController

@synthesize selectedDirectory;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configureView];
    [self formDemoData];
    
    [tbContentList reloadData];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self sizeHeaderToFit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods

- (void)configureView
{
    if (selectedDirectory)
    {
        [self.navigationItem setTitle:selectedDirectory.directoryName];
    }
    else
    {
        [self.navigationItem setTitle:@"LIFESTYLE"];
    }
    
    UIBarButtonItem *btBack = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icoArrowBack"] style:UIBarButtonItemStylePlain target:self action:@selector(didRequestToBack:)];
    [self.navigationItem setLeftBarButtonItem:btBack];
    
    tbContentList.clipsToBounds = YES;
    
    [vwDetailHeader configureViewWithViewModel:selectedDirectory];
    vwDetailHeader.delegate = self;
    
    [tbContentList registerNib:[UINib nibWithNibName:aboutCellIdentifier bundle:nil] forCellReuseIdentifier:aboutCellIdentifier];
    [tbContentList registerNib:[UINib nibWithNibName:perkCellIdentifier bundle:nil] forCellReuseIdentifier:perkCellIdentifier];
    [tbContentList registerNib:[UINib nibWithNibName:followerCellIdentifier bundle:nil] forCellReuseIdentifier:followerCellIdentifier];
    [tbContentList registerNib:[UINib nibWithNibName:stumblerCellIdentifier bundle:nil] forCellReuseIdentifier:stumblerCellIdentifier];
    [tbContentList registerNib:[UINib nibWithNibName:postCellIdentifier bundle:nil] forCellReuseIdentifier:postCellIdentifier];
    tbContentList.separatorStyle = UITableViewCellSeparatorStyleNone;
    tbContentList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    tbContentList.rowHeight = UITableViewAutomaticDimension;
    tbContentList.estimatedRowHeight = 44.0;
}

- (void)formDemoData
{
    // Perks
    arPerks = [@[] mutableCopy];
    Perk *perk = nil;
    
    perk = [[Perk alloc] initWithID:1 Name:@"Perk1" Thumbnail:@"imgSample7"];
    [arPerks addObject:perk];
    
    perk = [[Perk alloc] initWithID:2 Name:@"Perk2" Thumbnail:@"imgSample8"];
    [arPerks addObject:perk];
    
    perk = [[Perk alloc] initWithID:3 Name:@"Perk3" Thumbnail:@"imgSample9"];
    [arPerks addObject:perk];
    
    perk = [[Perk alloc] initWithID:4 Name:@"Perk4" Thumbnail:@"imgSample10"];
    [arPerks addObject:perk];
    
    perk = [[Perk alloc] initWithID:5 Name:@"Perk5" Thumbnail:@"imgSample11"];
    [arPerks addObject:perk];
    
    // Followers
    arFollowers = [@[] mutableCopy];
    Follower *follower = nil;
    
    follower = [[Follower alloc] initWithID:1 Name:@"Follower1" AvatarURL:@"imgSample31"];
    [arFollowers addObject:follower];
    
    follower = [[Follower alloc] initWithID:2 Name:@"Follower2" AvatarURL:@"imgSample32"];
    [arFollowers addObject:follower];
    
    follower = [[Follower alloc] initWithID:3 Name:@"Follower3" AvatarURL:@"imgSample33"];
    [arFollowers addObject:follower];
    
    follower = [[Follower alloc] initWithID:4 Name:@"Follower4" AvatarURL:@"imgSample34"];
    [arFollowers addObject:follower];
    
    follower = [[Follower alloc] initWithID:5 Name:@"Follower5" AvatarURL:@"imgSample35"];
    [arFollowers addObject:follower];
    
    follower = [[Follower alloc] initWithID:6 Name:@"Follower6" AvatarURL:@"imgSample36"];
    [arFollowers addObject:follower];
    
    // Stumblers
    arStumblers = [@[] mutableCopy];
    Stumbler *stumbler = nil;
    
    stumbler = [[Stumbler alloc] initWithID:1 Name:@"Stumbler1" AvatarURL:@"imgSample12"];
    [arStumblers addObject:stumbler];
    
    stumbler = [[Stumbler alloc] initWithID:1 Name:@"Stumbler2" AvatarURL:@"imgSample7"];
    [arStumblers addObject:stumbler];
    
    stumbler = [[Stumbler alloc] initWithID:1 Name:@"Stumbler3" AvatarURL:@"imgSample10"];
    [arStumblers addObject:stumbler];
    
    stumbler = [[Stumbler alloc] initWithID:1 Name:@"Stumbler4" AvatarURL:@"imgSample16"];
    [arStumblers addObject:stumbler];
    
    stumbler = [[Stumbler alloc] initWithID:1 Name:@"Stumbler5" AvatarURL:@"imgSample14"];
    [arStumblers addObject:stumbler];
    
    stumbler = [[Stumbler alloc] initWithID:1 Name:@"Stumbler6" AvatarURL:@"imgSample8"];
    [arStumblers addObject:stumbler];
    
    stumbler = [[Stumbler alloc] initWithID:1 Name:@"Stumbler7" AvatarURL:@"imgSample15"];
    [arStumblers addObject:stumbler];
    
    // Posts
    arPosts = [@[] mutableCopy];
    PostPage *page = nil;
    
    page = [[PostPage alloc] initWithID:1 Comment:@"Join us for Oxygin8 outdoor sesh today at 6pm!" CreatedAt:@"2016-06-28 10:40" UpdatedAt:@"2016-06-28 10:40" UserID:1 UserName:@"Mark Moon" AvatarURL:@"imgSample36"];
    [arPosts addObject:page];
    
    page = [[PostPage alloc] initWithID:1 Comment:@"Join us for Oxygin8 outdoor sesh today at 6pm!" CreatedAt:@"2016-06-29 17:40" UpdatedAt:@"2016-06-29 17:40" UserID:1 UserName:@"Mark Moon" AvatarURL:@"imgSample35"];
    [arPosts addObject:page];
    
    page = [[PostPage alloc] initWithID:1 Comment:@"Join us for Oxygin8 outdoor sesh today at 6pm!" CreatedAt:@"2016-07-01 15:29" UpdatedAt:@"2016-07-01 15:29" UserID:1 UserName:@"Mark Moon" AvatarURL:@"imgSample31"];
    [arPosts addObject:page];
    
    page = [[PostPage alloc] initWithID:1 Comment:@"Join us for Oxygin8 outdoor sesh today at 6pm!" CreatedAt:@"2016-07-01 19:26" UpdatedAt:@"2016-07-01 19:26" UserID:1 UserName:@"Mark Moon" AvatarURL:@"imgSample33"];
    [arPosts addObject:page];
}

- (void)sizeHeaderToFit
{
    UIView *header = tbContentList.tableHeaderView;
    
    [header setNeedsLayout];
    [header layoutIfNeeded];
    
    CGRect frame = header.frame;
    
//    CGFloat newHeight = tbContentList.frame.size.width;
    CGFloat newHeight = [header systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    frame.size.height = newHeight;
    header.frame = frame;
    
    tbContentList.tableHeaderView = header;
}

#pragma mark - Actions

- (void)didRequestToBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (selectedDirectory.directoryType == 1)
    {
        return 4;
    }
    else
    {
        return 3;
    }
    
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DHDirectoryDetailTableViewCell"];
    
    if (selectedDirectory.directoryType == 1)
    {
        if (indexPath.row == 0)
        {
            DirectoryAboutCell *aboutCell = [tableView dequeueReusableCellWithIdentifier:aboutCellIdentifier];
            
            DirectoryViewModel *directoryViewModel = [[DirectoryViewModel alloc] initWithDirectory:selectedDirectory];
            [aboutCell configureCellWithDirectoryViewModel:directoryViewModel];
            aboutCell.delegate = self;
            
            cell = aboutCell;
        }
        else if (indexPath.row == 1)
        {
            DirectoryFollowerCell *followerCell = [tableView dequeueReusableCellWithIdentifier:followerCellIdentifier];
            
            FollowersViewModel *followersViewModel = [[FollowersViewModel alloc] initWithFollowers:arFollowers];
            [followerCell configureCellWithFollowersViewModel:followersViewModel];
            followerCell.delegate = self;
            
            cell = followerCell;
        }
        else if (indexPath.row == 2)
        {
            DirectoryStumblerCell *stumblerCell = [tableView dequeueReusableCellWithIdentifier:stumblerCellIdentifier];
            
            StumblersViewModel *stumblersViewModel = [[StumblersViewModel alloc] initWithStumblers:arStumblers];
            [stumblerCell configureCellWithStumblersViewModel:stumblersViewModel];
            stumblerCell.delegate = self;
            
            cell = stumblerCell;
        }
        else if (indexPath.row == 3)
        {
            DirectoryPostCell *postCell = [tableView dequeueReusableCellWithIdentifier:postCellIdentifier];
            
            PostPagesViewModel *pagesViewModel = [[PostPagesViewModel alloc] initWithPostPages:arPosts];
            [postCell configureCellWithPostPagesViewModel:pagesViewModel];
            postCell.delegate = self;
            
            cell = postCell;
        }
    }
    else
    {
        if (indexPath.row == 0)
        {
            DirectoryFollowerCell *followerCell = [tableView dequeueReusableCellWithIdentifier:followerCellIdentifier];
            
            FollowersViewModel *followersViewModel = [[FollowersViewModel alloc] initWithFollowers:arFollowers];
            [followerCell configureCellWithFollowersViewModel:followersViewModel];
            followerCell.delegate = self;
            
            cell = followerCell;
        }
        else if (indexPath.row == 1)
        {
            DirectoryPerkCell *perkCell = [tableView dequeueReusableCellWithIdentifier:perkCellIdentifier];
            
            PerksViewModel *perksViewModel = [[PerksViewModel alloc] initWithPerks:arPerks];
            [perkCell configureCellWithPerksViewModel:perksViewModel];
            perkCell.delegate = self;
            
            cell = perkCell;
        }
        else if (indexPath.row == 2)
        {
            DirectoryPostCell *postCell = [tableView dequeueReusableCellWithIdentifier:postCellIdentifier];
            
            PostPagesViewModel *pagesViewModel = [[PostPagesViewModel alloc] initWithPostPages:arPosts];
            [postCell configureCellWithPostPagesViewModel:pagesViewModel];
            postCell.delegate = self;
            
            cell = postCell;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - DirectoryDetailHeaderDelegate

- (void)didRequestToChangeCoverPicture
{
    
}

- (void)didRequestToChangeProfilePicture
{
    
}

#pragma mark - DirectoryAboutCellDelegate

- (void)didRequestToCall:(NSString *)phoneNo
{
    
}

- (void)didRequestToViewAllAbout
{
    
}

#pragma mark - DirectoryFollowerCellDelegate

- (void)didSelectFollowerItemAtIndex:(NSInteger)selectedIndex
{
    
}

- (void)didRequestToViewAllFollowers
{
    
}

#pragma mark - DirectoryPerkCellDelegate

- (void)didSelectPerkItemAtIndex:(NSInteger)selectedIndex
{
    
}

- (void)didRequestToViewAllPerks
{
    
}

#pragma mark - DirectoryStumblerCellDelegate

- (void)didSelectStumblerItemAtIndex:(NSInteger)selectedIndex
{
    
}

- (void)didRequestToViewAllStumblers
{
    
}

#pragma mark - DirectoryPostCellDelegate

- (void)didSelectPostPageItemAtIndex:(NSInteger)selectedIndex
{
    
}

- (void)didRequestToViewAllPostPages
{
    
}

@end

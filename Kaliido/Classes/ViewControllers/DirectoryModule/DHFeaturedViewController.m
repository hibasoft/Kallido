//
//  DHFeaturedViewController.m
//  Kaliido
//
//  Created by Vadim Budnik on 6/21/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "DHFeaturedViewController.h"
#import "DirectoryFeaturedHeader.h"
#import "DirectoryTrendCell.h"
#import "TrendViewModel.h"
#import "TrendPage.h"
#import "DirectoryPerkCell.h"
#import "PerksViewModel.h"
#import "Perk.h"
#import "DirectoryCategoryCell.h"
#import "CategoriesViewModel.h"
#import "CategoryViewModel.h"
static NSString *trendingPageCellIdentifier = @"DirectoryTrendCell";
static NSString *perkCellIdentifier = @"DirectoryPerkCell";
static NSString *categoryCellIdentifier = @"DirectoryCategoryCell";

@interface DHFeaturedViewController () <UITableViewDelegate, UITableViewDataSource, DirectoryFeaturedHeaderDelegate, DirectoryTrendCellDelegate, DirectoryPerkCellDelegate, DirectoryCategoryCellDelegate>
{
    NSMutableArray *arTrends;
    NSMutableArray *arPerks;
    NSMutableArray *arCategories;
}


@end

@implementation DHFeaturedViewController

@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configureView];
    [self formDemoData];
    
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
    [vwFeaturedHeader configureViewWith:@{@"title" : @"LUMN8", @"subtitle" : @"FITNESS & WELLBEING", @"image_url" : @"imgSample1"}];
    vwFeaturedHeader.delegate = self;
    
    [tbContentList registerNib:[UINib nibWithNibName:trendingPageCellIdentifier bundle:nil] forCellReuseIdentifier:trendingPageCellIdentifier];
    [tbContentList registerNib:[UINib nibWithNibName:perkCellIdentifier bundle:nil] forCellReuseIdentifier:perkCellIdentifier];
    [tbContentList registerNib:[UINib nibWithNibName:categoryCellIdentifier bundle:nil] forCellReuseIdentifier:categoryCellIdentifier];
    tbContentList.separatorStyle = UITableViewCellSeparatorStyleNone;
    tbContentList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    tbContentList.rowHeight = UITableViewAutomaticDimension;
    tbContentList.estimatedRowHeight = 44.0;
}

- (void)formDemoData
{
    // Trending Pages
    arTrends = [@[] mutableCopy];
    TrendPage *page = nil;
    
    page = [[TrendPage alloc] initWithID:1 Name:@"Trending Page 1" ProfileURL:@"imgSample2" CoverURL:@"imgSample21"];
    [arTrends addObject:page];
    
    page = [[TrendPage alloc] initWithID:2 Name:@"Trending Page 2" ProfileURL:@"imgSample3" CoverURL:@"imgSample22"];
    [arTrends addObject:page];
    
    page = [[TrendPage alloc] initWithID:3 Name:@"Trending Page 3" ProfileURL:@"imgSample4" CoverURL:@"imgSample23"];
    [arTrends addObject:page];
    
    page = [[TrendPage alloc] initWithID:4 Name:@"Trending Page 4" ProfileURL:@"imgSample5" CoverURL:@"imgSample24"];
    [arTrends addObject:page];
    
    page = [[TrendPage alloc] initWithID:5 Name:@"Trending Page 5" ProfileURL:@"imgSample6" CoverURL:@"imgSample25"];
    [arTrends addObject:page];
    
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
    
    // Categories
    arCategories = [@[] mutableCopy];
   
    [[KLWebService getInstance] getBusinessTypes:^(BOOL success, NSArray *response, NSError *error) {
        
        arCategories = [NSMutableArray array];
        for (int i = 0; i < response.count; i++) {
            CategoryViewModel* tmpCategory = [[CategoryViewModel alloc] initWithDictionary:[response objectAtIndex:i]];
            [arCategories addObject:tmpCategory];
        }
        
        [tbContentList reloadData];
    }];
}

- (void)sizeHeaderToFit
{
    UIView *header = tbContentList.tableHeaderView;
    
    [header setNeedsLayout];
    [header layoutIfNeeded];
    
    CGRect frame = header.frame;
    
    CGFloat newHeight = tbContentList.frame.size.width/16*9-60.0f;
    
    frame.size.height = newHeight;
    header.frame = frame;
    
    tbContentList.tableHeaderView = header;
}

#pragma mark - Actions

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DHDirectoryTableViewCell"];
    
    if (indexPath.row == 0)
    {
        DirectoryTrendCell *trendingPageCell = [tableView dequeueReusableCellWithIdentifier:trendingPageCellIdentifier];
        
        NSMutableDictionary *dictTrendingPage = [NSMutableDictionary dictionaryWithCapacity:1];
        [dictTrendingPage setObject:arTrends forKey:@"trends"];
        
        TrendViewModel *trendViewModel = [[TrendViewModel alloc] initWithTrend:dictTrendingPage];
        [trendingPageCell configureCellWithTrendViewModel:trendViewModel];
        trendingPageCell.delegate = self;
        
        cell = trendingPageCell;
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
        DirectoryCategoryCell *categoryCell = [tableView dequeueReusableCellWithIdentifier:categoryCellIdentifier];
        
        CategoriesViewModel *categoriesViewModel = [[CategoriesViewModel alloc] initWithCategories:arCategories];
        [categoryCell configureCellWithCategoriesViewModel:categoriesViewModel];
        categoryCell.delegate = self;
        
        cell = categoryCell;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - DirectoryFeaturedHeaderDelegate


#pragma mark - DirectoryTrendCellDelegate

- (void)didSelectTrendingPageItemAtIndex:(NSInteger)selectedIndex
{
    
}

- (void)didRequestToViewAllTrendingPages
{
    
}

#pragma mark - DirectoryPerkCellDelegate

- (void)didSelectPerkItemAtIndex:(NSInteger)selectedIndex
{
    
}

- (void)didRequestToViewAllPerks
{
    
}

#pragma mark - DirectoryCategoryCellDelegate

- (void)didSelectCategoryItemAtIndex:(NSInteger)selectedIndex
{
    
}

- (void)didRequestToViewAllCategories
{
    
}

@end

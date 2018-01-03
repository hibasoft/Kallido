//
//  DirectorySubViewController.m
//  Kaliido
//
//  Created by Vadim Budnik on 6/21/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "DirectorySubViewController.h"
#import "DirectoryDirectoryTableCell.h"
#import "Directory.h"
#import "DirectoryViewModel.h"
#import "DirectoryDetailViewController.h"

static NSString *directoryDirectoryTableCellIdentifier = @"DirectoryDirectoryTableCell";

@interface DirectorySubViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *arContentList;
}

@end

@implementation DirectorySubViewController

@synthesize selectedCategory;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configureView];
    [self formDemoData];
    
    [tbContentList reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods

- (void)configureView
{
    if (selectedCategory)
    {
        [self.navigationItem setTitle:selectedCategory.categoryName];
    }
    else
    {
        [self.navigationItem setTitle:@"LIFESTYLE"];
    }
    
    UIBarButtonItem *btBack = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icoArrowBack"] style:UIBarButtonItemStylePlain target:self action:@selector(didRequestToBack:)];
    [self.navigationItem setLeftBarButtonItem:btBack];
    
    tbContentList.clipsToBounds = YES;
    tbContentList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)formDemoData
{
    arContentList = [@[] mutableCopy];
    Directory *item = nil;
    
    item = [[Directory alloc] initWithID:1 Name:@"Carabez" Headline:@"Fine jewellery for men" Location:@"SYDNEY, NSW" PhoneNo:@"(323) 353 8888" Description:@"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua." Type:1 LogoURL:@"imgLogoSample1" CoverURL:@"imgSample1" ProfileURL:@"imgSample3"];
    [arContentList addObject:item];
    
    item = [[Directory alloc] initWithID:2 Name:@"ADORINA" Headline:@"Workshop for casual men's accessories and streetwear" Location:@"PERTH, WA, AU" PhoneNo:@"(323) 353 1091" Description:@"Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident"  Type:0 LogoURL:@"imgLogoSample2" CoverURL:@"imgSample21" ProfileURL:@"imgSample2"];
    [arContentList addObject:item];
    
    item = [[Directory alloc] initWithID:3 Name:@"Alex & Chloe" Headline:@"Workshop for casual men's accessories and streetwear" Location:@"NEW YORK, USA" PhoneNo:@"(323) 353 8254" Description:@"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum." Type:1 LogoURL:@"imgLogoSample3" CoverURL:@"imgSample22" ProfileURL:@"imgSample3"];
    [arContentList addObject:item];
    
    item = [[Directory alloc] initWithID:4 Name:@"BLUMOSS" Headline:@"Fine jewellery for men" Location:@"SEATTLE, WA" PhoneNo:@"(617) 909 8065" Description:@"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua." Type:0 LogoURL:@"imgLogoSample4" CoverURL:@"imgSample23" ProfileURL:@"imgSample4"];
    [arContentList addObject:item];
    
    item = [[Directory alloc] initWithID:5 Name:@"Breda Watches" Headline:@"Workshop for casual men's accessories and streetwear" Location:@"SAN FRANCISCO, CA" PhoneNo:@"(323) 353 8888" Description:@"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua." Type:0 LogoURL:@"imgLogoSample5" CoverURL:@"imgSample1" ProfileURL:@"imgSample2"];
    [arContentList addObject:item];
    
    item = [[Directory alloc] initWithID:6 Name:@"Beauty Salon" Headline:@"pinky Beauty Salon for Beautiful Women" Location:@"SYDNEY, NSW" PhoneNo:@"1-866-599-6674" Description:@"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident" Type:0 LogoURL:@"imgLogoSample6" CoverURL:@"imgSample24" ProfileURL:@"imgSample5"];
    [arContentList addObject:item];
    
    item = [[Directory alloc] initWithID:7 Name:@"Spa" Headline:@"Spacious Luxury Spa" Location:@"MOSCOW, RU" PhoneNo:@"1-800-238-0767" Description:@"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua." Type:1 LogoURL:@"imgLogoSample7" CoverURL:@"imgSample25" ProfileURL:@"imgSample6"];
    [arContentList addObject:item];
    
    item = [[Directory alloc] initWithID:8 Name:@"Luxury Spa" Headline:@"Rejuvenating luxury spa at Ritz-Carlton hotel" Location:@"SYDNEY, NSW" PhoneNo:@"1-855-331-4754" Description:@"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua." Type:0 LogoURL:@"imgLogoSample8" CoverURL:@"imgSample1" ProfileURL:@"imgSample2"];
    [arContentList addObject:item];
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
    return [arContentList count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DirectoryDirectoryTableCell *cell = [tableView dequeueReusableCellWithIdentifier:directoryDirectoryTableCellIdentifier];
    
    Directory *item = [arContentList objectAtIndex:indexPath.row];
    DirectoryViewModel *itemVM = [[DirectoryViewModel alloc] initWithDirectory:item];
    [cell configureCellWithDirectoryViewModel:itemVM];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Directory *selectedItem = [arContentList objectAtIndex:indexPath.row];
    DirectoryDetailViewController *detailViewController = (DirectoryDetailViewController*)[[SharedManager sharedManager] loadViewControllerFromStoryboard:@"Directory" ViewControllerIdentifier:@"DirectoryDetailViewController"];
    detailViewController.selectedDirectory = selectedItem;
    
    [self.navigationController pushViewController:detailViewController animated:YES];
}


@end

//
//  StumblerSubCategoryViewController.m
//  Kaliido
//
//  Created by  Kaliido on 12/29/15.
//  Copyright © 2015 Kaliido. All rights reserved.
//

#import "StumblerSubCategoryViewController.h"
#import "SubInterestCell.h"
#import "KLWebService.h"


@interface StumblerSubCategoryViewController ()
{
    NSArray *arrData;
    NSMutableArray *idArray;
}
@end

@implementation StumblerSubCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    idArray =self.parent.stumblerArray;
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [[KLWebService getInstance] getStumblerSubCategory:(int)self.selectedCategory withCallback:^(BOOL success, NSArray *response, NSError *error) {
        [SVProgressHUD dismiss];
        arrData = response;
        [self.subInterestTableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SubInterestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubInterestCell"];
    cell.lblSubInterest.text = [[arrData objectAtIndex:indexPath.row] valueForKey:@"name"];
    cell.tag = indexPath.row;
    cell.delegate = self;
    if([idArray containsObject:[arrData objectAtIndex:indexPath.row]])
    {
        cell.btnAdd.selected = YES;
    }else
        cell.btnAdd.selected = NO;
    if (indexPath.row % 2 == 0)
    {
        cell.backgroundColor = [UIColor colorWithRed:239/255.0f green:239/255.0f blue:239/255.0f alpha:1.0f];
    }
    else{
        cell.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}

- (void)addButtonClicked:(SubInterestCell *)sender
{
    if (sender.btnAdd.selected)
    {
        [idArray addObject:[arrData objectAtIndex:sender.tag]];
    }else
    {
        [idArray removeObject:[arrData objectAtIndex:sender.tag]];
    }
}
@end

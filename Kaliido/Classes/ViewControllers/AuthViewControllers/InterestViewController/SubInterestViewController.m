//
//  SubInterestViewController.m
//  Kaliido
//
//  Created by  Kaliido on 3/8/15.
//  Copyright (c) 2015 Kaliido. All rights reserved.
//

#import "SubInterestViewController.h"
#import "SubInterestCell.h"
#import "KLWebService.h"

#import "KLApi.h"

@interface SubInterestViewController ()
{
    NSArray *arrData;
    NSArray *idArray;
}

@end

@implementation SubInterestViewController

#pragma mark - SubInterestViewController Implementation

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.title isEqualToString:@"LookingFor"])
    {
        if (self.parent != nil)
            idArray =self.parent.profileDic[@"lookingFors"];
        else
            idArray =self.detailParent.profileDic[@"lookingFors"];
        
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        [[KLWebService getInstance] getLookingFors:^(BOOL success, NSArray *response, NSError *error) {
            [SVProgressHUD dismiss];
            arrData = response;
            [self.subInterestTableView reloadData];
        }];
    }
    else if ([self.title isEqualToString:@"RelationShip"])
    {
        if (self.parent != nil)
            idArray =[NSArray arrayWithObject:self.parent.profileDic[@"relationship"]];
        else
            idArray =[NSArray arrayWithObject:self.detailParent.profileDic[@"relationship"]];
        
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        [[KLWebService getInstance] getRelationshipTypes:^(BOOL success, NSArray *response, NSError *error) {
            [SVProgressHUD dismiss];
            arrData = response;
            [self.subInterestTableView reloadData];
        }];
    }
    else
    {
        if (self.parent != nil)
            idArray =self.parent.profileDic[@"interests"];
        else if (self.detailParent != nil)
            idArray =self.detailParent.profileDic[@"interests"];
        else if (self.directoryParent != nil)
            idArray = self.directoryParent.interestArray;
        
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        [[KLWebService getInstance] getCategory:(int)self.selectedCategory withCallback:^(BOOL success, NSArray *response, NSError *error) {
            [SVProgressHUD dismiss];
            arrData = response;
            [self.subInterestTableView reloadData];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSArray *arrSubItems = (NSArray*) [arrData objectAtIndex:self.selectedCategory];
//    return [arrSubItems count];
    return [arrData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SubInterestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubInterestCell"];
//    NSArray *arrSubItems = (NSArray*) [arrData objectAtIndex:self.selectedCategory];
//    cell.lblSubInterest.text = [arrSubItems objectAtIndex:indexPath.row];
    
    cell.lblSubInterest.text = [[arrData objectAtIndex:indexPath.row] valueForKey:@"name"];
    cell.tag = indexPath.row;
    cell.delegate = self;
    
    if ([idArray containsObject:[arrData objectAtIndex:indexPath.row]])
    {
        cell.btnAdd.selected = YES;
    }
    else
    {
        cell.btnAdd.selected = NO;
    }
    
    if (indexPath.row % 2 == 0)
    {
        cell.backgroundColor = [UIColor colorWithRed:239/255.0f green:239/255.0f blue:239/255.0f alpha:1.0f];
    }
    else
    {
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    return cell;
}

#pragma mark - Actions

- (void)addButtonClicked:(SubInterestCell *)sender
{
    if (self.parent != nil)
    {
        if ([self.title isEqualToString:@"LookingFor"])
        {
            if (sender.btnAdd.selected)
            {
                [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
                [[KLWebService getInstance] addUserLookingFor:(int)[[[arrData objectAtIndex:sender.tag] valueForKey:@"id"] integerValue] withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
                    [SVProgressHUD dismiss];
                    [self.parent.profileDic[@"lookingFors"] addObject:[arrData objectAtIndex:sender.tag]];
                    [KLUser.currentUser setLookingForsDic:self.parent.profileDic];
                }];
            }else
            {
                [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
                [[KLWebService getInstance] deleteUserLookingFor:(int)[[[arrData objectAtIndex:sender.tag] valueForKey:@"id"] integerValue] withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
                    [SVProgressHUD dismiss];
                    [self.parent.profileDic[@"lookingFors"] removeObject:[arrData objectAtIndex:sender.tag]];
                    [KLUser.currentUser setLookingForsDic:self.parent.profileDic];
                }];
            }
        }else if ([self.title isEqualToString:@"RelationShip"])
        {
            idArray =[NSArray arrayWithObject:[arrData objectAtIndex:sender.tag]];
            [self.subInterestTableView reloadData];
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
            [[KLWebService getInstance] updateUserRelationShip:(int)[[[arrData objectAtIndex:sender.tag] valueForKey:@"id"] integerValue] withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
                [SVProgressHUD dismiss];
                [self.parent.profileDic setValue:[arrData objectAtIndex:sender.tag] forKey:@"relationship"];
                [KLUser.currentUser setRelationShipDic:self.parent.profileDic];
            }];
        }else
        {
            if (sender.btnAdd.selected)
            {
                [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
                [[KLWebService getInstance] addUserInterest:(int)[[[arrData objectAtIndex:sender.tag] valueForKey:@"id"] integerValue] withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
                    [SVProgressHUD dismiss];
                    [self.parent.profileDic[@"interests"] addObject:[arrData objectAtIndex:sender.tag]];
                    [KLUser.currentUser setInterestsDic:self.parent.profileDic];
                }];
            }else
            {
                [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
                [[KLWebService getInstance] deleteUserInterest:(int)[[[arrData objectAtIndex:sender.tag] valueForKey:@"id"] integerValue] withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
                    [SVProgressHUD dismiss];
                    [self.parent.profileDic[@"interests"] removeObject:[arrData objectAtIndex:sender.tag]];
                    [KLUser.currentUser setInterestsDic:self.parent.profileDic];
                }];
            }
        }
    }else  if (self.detailParent != nil)
    {
        if ([self.title isEqualToString:@"LookingFor"])
        {
            if (sender.btnAdd.selected)
            {
                [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
                [[KLWebService getInstance] addUserLookingFor:(int)[[[arrData objectAtIndex:sender.tag] valueForKey:@"id"] integerValue] withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
                    [SVProgressHUD dismiss];
                    [self.detailParent.profileDic[@"lookingFors"] addObject:[arrData objectAtIndex:sender.tag]];
                    [KLUser.currentUser setLookingForsDic:self.detailParent.profileDic];
                }];
            }else
            {
                [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
                [[KLWebService getInstance] deleteUserLookingFor:(int)[[[arrData objectAtIndex:sender.tag] valueForKey:@"id"] integerValue] withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
                    [SVProgressHUD dismiss];
                    [self.detailParent.profileDic[@"lookingFors"] removeObject:[arrData objectAtIndex:sender.tag]];
                    [KLUser.currentUser setLookingForsDic:self.detailParent.profileDic];
                }];
            }
        }else if ([self.title isEqualToString:@"RelationShip"])
        {
            idArray =[NSArray arrayWithObject:[arrData objectAtIndex:sender.tag]];
            [self.subInterestTableView reloadData];
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
            [[KLWebService getInstance] updateUserRelationShip:(int)[[[arrData objectAtIndex:sender.tag] valueForKey:@"id"] integerValue] withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
                [SVProgressHUD dismiss];
                [self.detailParent.profileDic setValue:[arrData objectAtIndex:sender.tag] forKey:@"relationship"];
                [KLUser.currentUser setRelationShipDic:self.detailParent.profileDic];
            }];
        }else
        {
            if (sender.btnAdd.selected)
            {
                [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
                [[KLWebService getInstance] addUserInterest:(int)[[[arrData objectAtIndex:sender.tag] valueForKey:@"id"] integerValue] withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
                    [SVProgressHUD dismiss];
                    [self.detailParent.profileDic[@"interests"] addObject:[arrData objectAtIndex:sender.tag]];
                    [KLUser.currentUser setInterestsDic:self.detailParent.profileDic];
                }];
            }else
            {
                [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
                [[KLWebService getInstance] deleteUserInterest:(int)[[[arrData objectAtIndex:sender.tag] valueForKey:@"id"] integerValue] withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
                    [SVProgressHUD dismiss];
                    [self.detailParent.profileDic[@"interests"] removeObject:[arrData objectAtIndex:sender.tag]];
                    [KLUser.currentUser setInterestsDic:self.detailParent.profileDic];
                }];
            }
        }
    }else if (_directoryParent != nil)
    {
        if (sender.btnAdd.selected)
        {
            [self.directoryParent.interestArray addObject:[arrData objectAtIndex:sender.tag]];
            
            
        }else
        {
            [self.directoryParent.interestArray removeObject:[arrData objectAtIndex:sender.tag]];
        }
    }
}

@end

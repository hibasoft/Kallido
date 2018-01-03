//
//  SearchPeopleViewController.m
//  Kaliido
//
//  Created by  Kaliido on 11/17/15.
//  Copyright © 2015 Kaliido. All rights reserved.
//

#import "SearchPeopleViewController.h"
#import "KLWebService.h"

#import "PeopleCell.h"

@interface SearchPeopleViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, CheckBoxProtocol>
@property (strong, nonatomic) IBOutlet UISearchBar *mainSearchBar;
@property (strong, nonatomic) IBOutlet UITableView *peopleTableView;

@property (strong, nonatomic) NSArray *peopleArray;
@end

@implementation SearchPeopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.peopleTableView.tableFooterView = [[UIView alloc] init];
    [self.mainSearchBar setReturnKeyType:UIReturnKeyDone];
    self.peopleArray = [self.parent.peopleDataArray mutableCopy];
}

- (IBAction) actionBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    return self.peopleArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PeopleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PeopleCell" forIndexPath:indexPath];
    cell.delegate = self;
    NSDictionary *userDic = self.peopleArray[indexPath.row];
    [cell updateData:userDic checked:[self.parent.peopleArray containsObject:[userDic valueForKey:@"id"]]];
    return cell;
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    __block NSString *tsearch = [searchText copy];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if ([searchBar.text isEqualToString:tsearch]) {
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
            [[KLWebService getInstance] getUsersByName:tsearch withCallback:^(BOOL success, NSArray *response, NSError *error) {
                self.peopleArray = response;
                [SVProgressHUD dismiss];
                [self.peopleTableView reloadData];
            }];
        }
    });
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}
#pragma mark - CheckBoxProtocol

- (void)containerView:(UIView *)containerView didChangeState:(id)sender {
    
    NSIndexPath *indexPath = [self.peopleTableView indexPathForCell:(id)containerView];
    NSDictionary *dicData = [self.peopleArray objectAtIndex:indexPath.row];
    NSUInteger index = [self.parent.peopleArray indexOfObject:[dicData valueForKey:@"id"]];
    if(index == NSNotFound)
    {
        [self.parent.peopleArray addObject:[dicData valueForKey:@"id"]];
        [self.parent.peopleNameArray addObject:[dicData valueForKey:@"fullName"]];
        [self.parent.peopleDataArray addObject:dicData];
    }else
    {
        [self.parent.peopleArray removeObjectAtIndex:index];
        [self.parent.peopleNameArray removeObjectAtIndex:index];
        [self.parent.peopleDataArray removeObjectAtIndex:index];
    }
}

- (IBAction)FavouriteButtonClicked:(UIButton*)sender {
    sender.selected = !sender.selected;
    if (sender.selected)
    {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        
        [[KLWebService getInstance] getAllFavourites:^(BOOL success, NSArray *response, NSError *error) {
            self.peopleArray = response;
            [SVProgressHUD dismiss];
            [self.peopleTableView reloadData];
        }];
    }else
    {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        [[KLWebService getInstance] getUsersByName:self.mainSearchBar.text withCallback:^(BOOL success, NSArray *response, NSError *error) {
            self.peopleArray = response;
            [SVProgressHUD dismiss];
            [self.peopleTableView reloadData];
        }];
    }
}
@end

//
//  DHDirectoryViewController.m
//  Kaliido
//
//  Created by Vadim Budnik on 6/21/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "DirectoryCategoryViewController1.h"
#import "DirectoryCategoryTableCell.h"
#import "CategoryViewModel.h"
#import "DirectoryCreateViewController.h"
#import "KLWebService.h"
static NSString *directoryCategoryTableCellIdentifier = @"DirectoryCategoryTableCell";

@interface DirectoryCategoryViewController1 () <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *arContentList;
}

@end

@implementation DirectoryCategoryViewController1

@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configureView];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [[KLWebService getInstance] getBusinessTypes:^(BOOL success, NSArray *response, NSError *error) {
        [SVProgressHUD dismiss];
        arContentList = [NSMutableArray array];
        for (int i = 0; i < response.count; i++) {
            CategoryViewModel* tmpCategory = [[CategoryViewModel alloc] initWithDictionary:[response objectAtIndex:i]];
            [arContentList addObject:tmpCategory];
        }
        [tbContentList reloadData];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods

- (void)configureView
{
    tbContentList.clipsToBounds = YES;
    tbContentList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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
    return [arContentList count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DirectoryCategoryTableCell *cell = [tableView dequeueReusableCellWithIdentifier:directoryCategoryTableCellIdentifier];
    
    CategoryViewModel *itemVM = [arContentList objectAtIndex:indexPath.row];
    [cell configureCellWithCategoryViewModel:itemVM];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DirectoryCreateViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DirectoryCreateViewController"];
    CategoryViewModel *itemVM = [arContentList objectAtIndex:indexPath.row];
    
    vc.selectedCategoryId = itemVM.categoryId;
    
    [self.navigationController pushViewController:vc animated:YES];
}




@end

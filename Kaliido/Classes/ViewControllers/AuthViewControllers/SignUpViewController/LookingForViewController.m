//
//  KLLookingForViewController.m
//  Kaliido
//
//  Created by  Kaliido on 3/6/15.
//  Copyright (c) 2015 Kaliido. All rights reserved.
//

#import "LookingForViewController.h"
#import "LookingForCell.h"

@interface LookingForViewController ()
{
    NSArray *arrLooks;
}
@end

@implementation LookingForViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    arrLooks = @[@"Chat",@"Dates",@"Friends",@"Networking",@"Relationship"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LookingForCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lookingforcell" forIndexPath:indexPath];
    cell.lblTitle.text = [arrLooks objectAtIndex:indexPath.row];
    return cell;
}



@end

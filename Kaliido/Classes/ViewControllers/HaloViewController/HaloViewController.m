//
//  HaloViewController.m
//  Kaliido
//
//  Created by  Kaliido on 1/27/15.
//  Copyright (c) 2015 Quickblox. All rights reserved.
//

#import "HaloViewController.h"
#import "UIColor+CreateMethods.h"
#import "HaloTableViewCell.h"

@interface HaloViewController ()
{
    IBOutlet UISwitch *switchHalo;
    NSArray *arrTestString;
    NSArray *arrTestString1;
    NSArray *arrTestString2;
}
@end

@implementation HaloViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    arrTestString = [NSArray arrayWithObjects:@"Global",@"Australlia",@"N.America", nil];
    arrTestString1 = @[@"UNICEF",@"Amnesty International",@"Community Brave",@"Kaleidoscope Australlia House Long String",@"Human Rights Campagin",@"GLLAD"];
    arrTestString2 = @[@"www.unicef.org",@"www.amnesty.com",@"www.thecommnunitybravefoundation.com",@"www.antigaylaws.wordpress.com",@"www.hrc.org",@"www.antilaws.com"];
//    switchHalo.layer.borderColor = [UIColor whiteColor].CGColor;
//    switchHalo.layer.borderWidth = 2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    view.backgroundColor = [UIColor colorWith8BitRed:70 green:57 blue:139 alpha:1];
    UIImageView *imgGlobal = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15-6, 12, 12)];
    imgGlobal.image = [UIImage imageNamed:@"global"];
    [view addSubview:imgGlobal];
    UILabel *lblCategoryName = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, self.view.frame.size.width-30, 30)];
    lblCategoryName.text = [arrTestString objectAtIndex:section];
    lblCategoryName.font = [UIFont systemFontOfSize:12];
    lblCategoryName.textColor = [UIColor whiteColor];
    [view addSubview:lblCategoryName];
    return view;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HaloTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"haloCell"];
    if (indexPath.row % 2 == 1)
        cell.backgroundColor = [UIColor colorWith8BitRed:239 green:239 blue:244 alpha:1];
    cell.lblName.text = [arrTestString1 objectAtIndex:indexPath.section*2+indexPath.row];
    cell.lblLink.text = [arrTestString2 objectAtIndex:indexPath.section*2+indexPath.row];
    cell.btnConnectionStatus.selected = indexPath.row %2;
    return cell;
}

@end

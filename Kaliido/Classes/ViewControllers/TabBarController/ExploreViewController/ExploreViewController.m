//
//  ExploreViewController.m
//  Kaliido
//
//  Created by Hiba on 9/19/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "ExploreViewController.h"
#import "KLPieChartView.h"
@interface ExploreViewController ()<KLPieChartViewDataSource, KLPieChartViewDelegate>


@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) KLPieChartView *pieChartView;
@property (nonatomic, strong) IBOutlet UILabel *playLabel;
@property (nonatomic, strong) IBOutlet UILabel *lifeLabel;
@property (nonatomic, strong) IBOutlet UILabel *workLabel;
@property (nonatomic, strong) UILabel *centerLabel;

@end

@implementation ExploreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"KL_STR_EXPLORE", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    
    //init pie chart view
    NSMutableArray *mutableArray = [NSMutableArray array];
    
    [mutableArray addObject:@(60)];
    [mutableArray addObject:@(25)];
    [mutableArray addObject:@(15)];
    
    _dataSource = [NSArray arrayWithArray:mutableArray];
    
    _pieChartView = [[KLPieChartView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-230/2, 80 , 230, 230)];
    _pieChartView.dataSource = self;
    _pieChartView.delegate = self;
    _pieChartView.ringWidth = 54;
    [self.view addSubview:_pieChartView];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chartTap:)];
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.numberOfTouchesRequired = 1;
    [_pieChartView addGestureRecognizer:tapRecognizer];
    
    //add center label
    self.centerLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-230/2, 80 + 230/2 - 15 , 230, 30)];
    self.centerLabel.text = @"SYDNEY";
    self.centerLabel.textColor = [UIColor colorWithRed:38/255.0 green:158/255.0 blue:198/255.0 alpha:1.0];
    self.centerLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.centerLabel];
    
    //
    
    [_pieChartView reloadDataWithAnimate:YES];
    
}
//MARK: tap action

-(IBAction)chartTap:(UITapGestureRecognizer*)recognizer
{

    NSLog(@"chartview tapped");
    
}

//MARK: KLPieChartViewDelegate

- (NSInteger)numberOfPieInPieChartView:(KLPieChartView *)pieChartView {
    return _dataSource.count;
}

- (id)pieChartView:(KLPieChartView *)pieChartView valueOfPieAtIndex:(NSInteger)index {
    return _dataSource[index];
}

- (id)sumValueInPieChartView:(KLPieChartView *)pieChartView {
    return @100;
}


- (UIColor *)pieChartView:(KLPieChartView *)pieChartView colorOfPieAtIndex:(NSInteger)index {
    if (index == 0) {
        return [UIColor colorWithRed:38/255.0 green:158/255.0 blue:198/255.0 alpha:1.0];
    } else if (index == 1) {
        return [UIColor colorWithRed:154/255.0 green:0/255.0 blue:117/255.0 alpha:1.0];
    } else if (index == 2) {
        return [UIColor colorWithRed:140/255.0 green:193/255.0 blue:59/255.0 alpha:1.0];
    }
    return [UIColor colorWithRed:0/255.0 green:207/255.0 blue:187/255.0 alpha:1.0];
}

//////////


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

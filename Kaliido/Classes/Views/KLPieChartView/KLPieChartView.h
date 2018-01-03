//
//  KLPieChartView.h
//  Kaliido
//
//  Created by Hiba on 9/22/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>



#import <UIKit/UIKit.h>

@class KLPieChartView;
@protocol KLPieChartViewDataSource <NSObject>

@required
- (NSInteger)numberOfPieInPieChartView:(KLPieChartView *)pieChartView;
- (id)pieChartView:(KLPieChartView *)pieChartView valueOfPieAtIndex:(NSInteger)index;

@optional
- (id)sumValueInPieChartView:(KLPieChartView *)pieChartView;

@end

@protocol KLPieChartViewDelegate <NSObject>

@optional
- (UIColor *)pieChartView:(KLPieChartView *)pieChartView colorOfPieAtIndex:(NSInteger)index;
- (NSAttributedString *)ringTitleInPieChartView:(KLPieChartView *)pieChartView;
- (UIView *)ringViewInPieChartView:(KLPieChartView *)pieChartView;

@end

@interface KLPieChartView : UIView

@property (nonatomic, weak) id<KLPieChartViewDataSource> dataSource;
@property (nonatomic, weak) id<KLPieChartViewDelegate> delegate;


@property (nonatomic, assign) CGPoint centerPoint;

@property (nonatomic, assign) CGFloat radius;

@property (nonatomic, strong) UIColor *pieBackgroundColor;


@property (nonatomic, assign) CGFloat ringWidth;

@property (nonatomic, copy) NSString *ringTitle;

@property (nonatomic, assign) BOOL circle;

- (void)reloadData;
- (void)reloadDataWithAnimate:(BOOL)animate;
-(void)rotatebyPoint : (CGPoint) point;
@end

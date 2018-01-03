//
//  KLPieChartView.m
//  Kaliido
//
//  Created by Learco on 9/22/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "KLPieChartView.h"

#define PIE_CHART_PADDING 16.0

@interface KLPieChartView ()
{
    CGFloat startAngle;
    CGFloat endAngle;
//    CGFloat currentViewAngle;
}
@property (nonatomic, strong) NSMutableArray *chartDataSource;

@end

@implementation KLPieChartView

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self initialization];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
    }
    return self;
}

- (void)initialization {
    self.backgroundColor = [UIColor clearColor];
    
    _centerPoint = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
    _radius = MIN(CGRectGetWidth(self.bounds)/2 - PIE_CHART_PADDING, CGRectGetHeight(self.bounds)/2 - PIE_CHART_PADDING);
    
    _pieBackgroundColor = [UIColor colorWithRed:63/255.0 green:63/255.0 blue:118/255.0 alpha:1.0];
    
    _ringWidth = _radius;
    _circle = YES;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (self.chartDataSource == nil) {
        [self reloadData];
    }
    
    
}

- (void)reloadData {
    [self reloadDataWithAnimate:YES];
}

- (void)reloadDataWithAnimate:(BOOL)animate {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    NSAssert([self.dataSource respondsToSelector:@selector(numberOfPieInPieChartView:)], @"You must implemetation the 'numberOfPieInPieChartView:' method");
    NSAssert([self.dataSource respondsToSelector:@selector(pieChartView:valueOfPieAtIndex:)], @"You must implemetation the 'pieChartView:valueOfPieAtIndex:' method");
    NSInteger numberOfPie = [self.dataSource numberOfPieInPieChartView:self];
    _chartDataSource = [NSMutableArray arrayWithCapacity:numberOfPie];
    for (NSInteger index = 0; index < numberOfPie; index ++) {
        id value = [self.dataSource pieChartView:self valueOfPieAtIndex:index];
        [_chartDataSource addObject:value];
    }
    CGFloat sumValue = 0.0;
    if ([self.dataSource respondsToSelector:@selector(sumValueInPieChartView:)]) {
        sumValue = [[self.dataSource sumValueInPieChartView:self] floatValue];
    } else if (_circle) {
        for (id value in _chartDataSource) {
            sumValue += [value floatValue];
        }
    } else {
        NSAssert([self.dataSource respondsToSelector:@selector(sumValueInPieChartView:)], @"You must have a sumValue");
    }
    
    for (NSInteger index = 0; index < numberOfPie; index ++) {
        endAngle = startAngle - [_chartDataSource[index] floatValue]/sumValue * 2 * M_PI;
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:_centerPoint radius:_radius - _ringWidth/2 startAngle:startAngle endAngle:endAngle clockwise:NO];
        
        UIColor *pieColor = [UIColor colorWithRed:(index + 1.0)/numberOfPie green:1 - (index + 1.0)/numberOfPie blue:index * 1.0/numberOfPie alpha:1.0];
        if ([self.delegate respondsToSelector:@selector(pieChartView:colorOfPieAtIndex:)]) {
            pieColor = [self.delegate pieChartView:self colorOfPieAtIndex:index];
        }
        
        CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
        shapeLayer.lineWidth = _ringWidth;
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.strokeColor = pieColor.CGColor;
        shapeLayer.path = bezierPath.CGPath;
        [self.layer addSublayer:shapeLayer];
        
        
        
        startAngle = endAngle;
    }
    
    if (animate)
    {
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        animation.fromValue = @(0.0);
        animation.toValue = @(M_PI*2);
        animation.repeatCount = 1.0;
        animation.duration = 1;
        
        animation.delegate = self;
        [self.layer addAnimation:animation forKey:@"animation"];
    }
    
    if ([self.delegate respondsToSelector:@selector(ringViewInPieChartView:)]) {
        UIView *view = [self.delegate ringViewInPieChartView:self];
        view.center = CGPointMake(_centerPoint.x, _centerPoint.y);
        [self addSubview:view];
    }
    
    [self setNeedsDisplay];
}


-(void)rotatebyPoint : (CGPoint) point{
    [self reloadDataWithAnimate:true];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
//    currentViewAngle += M_PI_2;
//    CGAffineTransform transform = CGAffineTransformMakeRotation(currentViewAngle);
//    [self setTransform:transform];
}

@end

//
//  CustomView.m
//  Kaliido
//
//  Created by Vadim Budnik on 6/25/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "CustomView.h"

@interface CustomView()

@property (nonatomic, strong) UIView *containerView;

@end

@implementation CustomView

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    UIView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
    if (view != nil)
    {
        _containerView = view;
        [self addSubview:view];
        
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [self setNeedsUpdateConstraints];
    }
}

- (void)updateConstraints
{
    if (_containerView != nil)
    {
        UIView *view = _containerView;
        NSDictionary *views = NSDictionaryOfVariableBindings(view);
        NSMutableArray *constraintsArray = [NSMutableArray new];
        [constraintsArray addObjectsFromArray:[NSLayoutConstraint
                                               constraintsWithVisualFormat:@"H:|[view]|"
                                               options:0 metrics:nil
                                               views:views]];
        [constraintsArray addObjectsFromArray:[NSLayoutConstraint
                                               constraintsWithVisualFormat:@"V:|[view]|"
                                               options:0 metrics:nil
                                               views:views]];
        
        [self addConstraints:constraintsArray];
        
    }
    
    [super updateConstraints];
}


@end

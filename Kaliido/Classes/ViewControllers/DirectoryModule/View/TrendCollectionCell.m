//
//  TrendCollectionCell.m
//  Kaliido
//
//  Created by Vadim Budnik on 6/28/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "TrendCollectionCell.h"
#import "TrendPageViewModel.h"

@implementation TrendCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self configureView];
}

- (void)configureView
{
    ivCover.clipsToBounds = YES;
    ivCover.contentMode = UIViewContentModeScaleAspectFill;
    
    ivProfile.clipsToBounds = YES;
    ivProfile.contentMode = UIViewContentModeScaleAspectFill;
    ivProfile.layer.cornerRadius = 0.0f;
    ivProfile.layer.borderWidth = 2.0f;
    ivProfile.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    self.clipsToBounds = YES;
    
    lbTitle.text = @"";
}

- (void)configureViewWithViewModel:(TrendPageViewModel*)trendPage
{
    lbTitle.text = trendPage.trendPageTitle;
    ivProfile.image = [UIImage imageNamed:trendPage.pageProfileURL];
    ivCover.image = [UIImage imageNamed:trendPage.pageCoverURL];
}

@end

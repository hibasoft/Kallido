//
//  CategoryCollectionCell.m
//  Kaliido
//
//  Created by Vadim Budnik on 6/28/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "CategoryCollectionCell.h"
#import "CategoryViewModel.h"

@implementation CategoryCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self configureView];
}

- (void)configureView
{
    ivImage.clipsToBounds = YES;
    ivImage.contentMode = UIViewContentModeScaleAspectFill;
    
    self.clipsToBounds = YES;
    
    lbTitle.text = @"";
}

- (void)configureViewWithViewModel:(CategoryViewModel*)categoryModel
{
    lbTitle.text = categoryModel.categoryName;
    ivImage.image = [UIImage imageNamed:categoryModel.imageUIDStandard];
}

@end

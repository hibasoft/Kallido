//
//  DirectoryTableCell.m
//  Kaliido
//
//  Created by Vadim Budnik on 6/23/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "DirectoryCategoryTableCell.h"
#import "CategoryViewModel.h"

@implementation DirectoryCategoryTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWithCategoryViewModel:(CategoryViewModel*)categoryItem
{
    lbTitle.text = categoryItem.categoryName;
}

@end

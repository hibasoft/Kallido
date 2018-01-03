//
//  PerkCollectionCell.m
//  Kaliido
//
//  Created by Vadim Budnik on 6/28/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "PerkCollectionCell.h"
#import "PerkViewModel.h"

@implementation PerkCollectionCell

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

- (void)configureViewWithViewModel:(PerkViewModel*)perkModel
{
    lbTitle.text = perkModel.perkName;
    ivImage.image = [UIImage imageNamed:perkModel.thumbnailURL];
}

@end

//
//  StumblerCollectionCell.m
//  Kaliido
//
//  Created by Vadim Budnik on 6/29/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "StumblerCollectionCell.h"
#import "StumblerViewModel.h"

@implementation StumblerCollectionCell

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

- (void)configureViewWithViewModel:(StumblerViewModel*)stumblerModel
{
    lbTitle.text = stumblerModel.stumblerName;
    ivImage.image = [UIImage imageNamed:stumblerModel.avatarURL];
}


@end

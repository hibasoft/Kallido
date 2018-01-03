//
//  FollowerCollectionCell.m
//  Kaliido
//
//  Created by Vadim Budnik on 6/29/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "FollowerCollectionCell.h"
#import "FollowerViewModel.h"

@implementation FollowerCollectionCell

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

- (void)configureViewWithViewModel:(FollowerViewModel*)followerModel
{
    lbTitle.text = followerModel.followerName;
    ivImage.image = [UIImage imageNamed:followerModel.avatarURL];
}

@end

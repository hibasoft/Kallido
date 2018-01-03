//
//  DirectoryDirectoryTableCell.m
//  Kaliido
//
//  Created by Vadim Budnik on 6/23/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "DirectoryDirectoryTableCell.h"
#import "DirectoryViewModel.h"

@implementation DirectoryDirectoryTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    ivLogo.clipsToBounds = YES;
    ivLogo.layer.cornerRadius = ivLogo.frame.size.width/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWithDirectoryViewModel:(DirectoryViewModel*)directoryItem
{
    lbTitle.text = directoryItem.directoryName;
    lbHeadline.text = directoryItem.directoryHeadline;
    ivLogo.image = [UIImage imageNamed:directoryItem.logoURL];
}

@end

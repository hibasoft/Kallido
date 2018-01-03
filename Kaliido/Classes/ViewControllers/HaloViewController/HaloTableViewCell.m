//
//  HaloTableViewCell.m
//  Kaliido
//
//  Created by  Kaliido on 1/27/15.
//  Copyright (c) 2015 Quickblox. All rights reserved.
//

#import "HaloTableViewCell.h"

@implementation HaloTableViewCell

- (void)awakeFromNib {
    _imgProf.layer.cornerRadius = _imgProf.frame.size.width/2;
    _imgProf.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end

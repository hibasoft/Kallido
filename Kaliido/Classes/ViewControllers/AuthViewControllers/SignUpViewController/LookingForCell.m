//
//  KLLookingForCell.m
//  Kaliido
//
//  Created by  Kaliido on 3/6/15.
//  Copyright (c) 2015 Kaliido. All rights reserved.
//

#import "LookingForCell.h"

@implementation LookingForCell
- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction) actionAdd:(id)sender
{
    self.btnAdd.hidden = YES;
}
@end

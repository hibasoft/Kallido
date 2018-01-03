//
//  SubInterestCell.m
//  Kaliido
//
//  Created by  Kaliido on 3/9/15.
//  Copyright (c) 2015 Kaliido. All rights reserved.
//

#import "SubInterestCell.h"
#import "KLWebService.h"

@implementation SubInterestCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (IBAction) actionBtnAdd:(id)sender
{
    self.btnAdd.selected = !self.btnAdd.selected;
    [self.delegate addButtonClicked:self];
}
@end

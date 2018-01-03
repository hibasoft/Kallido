//
//  MessageCell.m
//  Kaliido
//
//  Created by Learco R on 6/6/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

@synthesize senderAndTimeLabel, messageContentView, bgImageView;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




@end

//
//  NotificationTableViewCell.m
//  Kaliido
//
//  Learco on 1/8/17.
//  Copyright © 2017 Kaliido. All rights reserved.
//

#import "NotificationTableViewCell.h"

@implementation NotificationTableViewCell
@synthesize delegate;
    
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)onTapClose:(id)sender {
    [delegate didCloseNotification];
}

@end
	

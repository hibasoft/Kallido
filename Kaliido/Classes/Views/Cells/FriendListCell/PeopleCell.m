//
//  PeopleCell.m
//  Kaliido
//
//  Created by  Kaliido on 11/17/15.
//  Copyright © 2015 Kaliido. All rights reserved.
//

#import "PeopleCell.h"

@implementation PeopleCell

- (void)awakeFromNib {
    // Initialization code
    self.activeCheckbox.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)updateData:(NSDictionary*)userDic checked:(BOOL)bChecked
{
    self.userLabel.text =[userDic valueForKey:@"fullName"];
    
    NSString *photoUID = [userDic valueForKey:@"photoUID"];
    if (photoUID == nil ||[photoUID isEqual:[NSNull null]])
        photoUID = nil;
    NSURL *avatarUrl = [NSURL URLWithString:photoUID];

    UIImage *placeholder = [UIImage imageNamed:@"upic-placeholder"];
    
    [self.userImageView setImageWithURL:avatarUrl
                            placeholder:placeholder
                                options:SDWebImageHighPriority
                               progress:^(NSInteger receivedSize, NSInteger expectedSize) {}
                         completedBlock:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {}];
    self.activeCheckbox.hidden = !bChecked;
    self.check = bChecked;
}

- (void)setCheck:(BOOL)check {
    
    if (_check != check) {
        _check = check;
        self.activeCheckbox.hidden = !check;
    }
}

#pragma mark - Actions

- (IBAction)pressCheckBox:(id)sender {
    
    self.check ^= 1;
    [self.delegate containerView:self didChangeState:sender];
}
@end

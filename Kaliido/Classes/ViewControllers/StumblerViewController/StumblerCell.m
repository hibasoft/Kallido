//
//  StumblerCell.m
//  Kaliido
//
//  Created by  Kaliido on 2/24/15.
//  Copyright (c) 2015 Kaliido. All rights reserved.
//

#import "StumblerCell.h"
#import "KLStumblerModel.h"

@implementation StumblerCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void) updateData:(NSDictionary*) userDic
{
    KLStumblerModel *stumbler = [KLStumblerModel objectWithDictionary:userDic];
    self.lblOrganizationName.text = stumbler.name;
    self.lblNumAttendees.text = [NSString stringWithFormat:@"%ld attendees",stumbler.invitedCount];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
    NSDate *myDate = [df dateFromString:stumbler.date];
    [df setDateFormat:@"yyyy MMM dd"];
    
    self.lblWeekday.text = [df stringFromDate:myDate];
    
    UIImage *placeholder = [UIImage imageNamed:@"sbackground"];
    NSURL *url = [NSURL URLWithString:stumbler.imageUID];//[UsersUtils userAvatarURL:self.currentUser];
    [self.imgProfile setImageWithURL:url
                         placeholder:placeholder
                             options:SDWebImageHighPriority
                            progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                NSLog(@"r - %d; e - %d", receivedSize, expectedSize);
                            } completedBlock:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                
                            }];
    self.imgProfile.layer.masksToBounds = NO;
    self.imgProfile.layer.borderWidth = 0;
}
@end

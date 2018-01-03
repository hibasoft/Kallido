//
//  StumblerCollectionViewCell.m
//  Kaliido
//
//  Created by  Kaliido on 12/28/15.
//  Copyright © 2015 Kaliido. All rights reserved.
//

#import "StumblerCollectionViewCell.h"
#import "KLStumblerModel.h"

@implementation StumblerCollectionViewCell
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

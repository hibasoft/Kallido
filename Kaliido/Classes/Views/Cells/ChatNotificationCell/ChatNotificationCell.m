//
//  ChatNotificationCell.m
//  Kaliido
//
//  Created by Daron on 07.10.14.
//  Copyright (c) 2014 Kaliido. All rights reserved.
//

#import "ChatNotificationCell.h"
//#import "Message.h"
//#import "ChatUtils.h"
#import "KLApi.h"

@implementation ChatNotificationCell

- (void)awakeFromNib {
    // Initialization code
}

//- (void)setNotification:(Message *)notification
//{
//    if (![_notification isEqual:notification]) {
//        _notification = notification;
//    }
//    
//    self.dateLabel.text = [[self formatter] stringFromDate:self.notification.datetime];
//    self.messageLabel.text = [ChatUtils messageTextForNotification:self.notification];
//}

- (NSString *)nameOfUser:(KLUser *)user
{
    NSUInteger myID = KLUser.currentUser.ID;
    return (user.ID == myID) ? @"You" : user.fullName;
}

- (NSDateFormatter *)formatter {
    
    static dispatch_once_t onceToken;
    static NSDateFormatter *_dateFormatter = nil;
    dispatch_once(&onceToken, ^{
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"HH:mm"];
    });
    
    return _dateFormatter;
}

@end

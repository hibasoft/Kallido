//
//  ContactRequestCell.m
//  Kaliido
//
//  Created by Daron on 28/08/2014.
//  Copyright (c) 2014 Kaliido. All rights reserved.
//

#import "ContactRequestCell.h"
//#import "ChatUtils.h"
#import "KLApi.h"

@interface ContactRequestCell()

@property (nonatomic, strong) KLUser *opponent;

@end


@implementation ContactRequestCell

//
//- (void)setNotification:(Message *)notification
//{
//    if (![_notification isEqual:notification]) {
//        _notification = notification;
//    }
//    self.opponent = [KLUser userWithID:notification.senderID];
//    self.fullNameLabel.text = [ChatUtils messageTextForNotification:notification];
//}


- (IBAction)rejectButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(contactRequestWasRejectedForUser:)]) {
        [self.delegate contactRequestWasRejectedForUser:self.opponent];
    }
}

- (IBAction)acceptButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(contactRequestWasAcceptedForUser:)]) {
        [self.delegate contactRequestWasAcceptedForUser:self.opponent];
    }
}

@end

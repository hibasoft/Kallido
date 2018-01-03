//
//  ChatNotificationCell.h
//  Kaliido
//
//  Created by Daron on 07.10.14.
//  Copyright (c) 2014 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class Message;

static NSString *const kChatNotificationCellID = @"ContactNotificationCell";

@interface ChatNotificationCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

//@property (strong, nonatomic) Message *notification;

@end

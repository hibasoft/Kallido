//
//  DialogCell.h
//  Kaliido
//
//  Created by Daron on 31/03/2014.
//  Copyright (c) 2014 Kaliido. All rights reserved.
//

#import "KLTableViewCell.h"

@interface KLRecentChatListCell : KLTableViewCell


@property (strong, nonatomic) IBOutlet UILabel *unreadMsgNumb;
@property (strong, nonatomic) IBOutlet UIImageView *unreadMsgBackground;

@end

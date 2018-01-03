//
//  InviteFriendsStaticCell.h
//  Kaliido
//
//  Created by Daron on 25.03.14.
//  Copyright (c) 2014 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckBoxProtocol.h"

@interface InviteStaticCell : UITableViewCell

@property (assign, nonatomic) NSUInteger badgeCount;
@property (assign, nonatomic, getter = isChecked) BOOL check;
@property (weak, nonatomic) id <CheckBoxProtocol> delegate;

@end

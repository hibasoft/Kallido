//
//  InviteFriendsCell.h
//  Kaliido
//
//  Created by Daron on 24.03.14.
//  Copyright (c) 2014 Kaliido. All rights reserved.
//

#import "CheckBoxProtocol.h"
#import "KLTableViewCell.h"

@class InviteFriendCell;

@interface InviteFriendCell : KLTableViewCell

@property (assign, nonatomic, getter = isChecked) BOOL check;
@property (weak, nonatomic) id <CheckBoxProtocol> delegate;

@end

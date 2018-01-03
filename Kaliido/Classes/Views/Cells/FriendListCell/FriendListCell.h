//
//  FriendListCell.h
//  Kaliido
//
//  Created by Daron on 25/02/2014.
//  Copyright (c) 2014 Kaliido. All rights reserved.
//

#import "KLTableViewCell.h"


@interface FriendListCell : KLTableViewCell

@property (strong, nonatomic) NSString *searchText;

@property (weak, nonatomic) id <UsersListDelegate>delegate;

@end

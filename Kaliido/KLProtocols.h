//
//  KLProtocols.h
//  Kaliido
//
//  Created by Daron on 18.08.14.
//  Copyright (c) 2014 Kaliido. All rights reserved.
//


@class KLTableViewCell;
@class ContactRequestView;



@protocol TabBarChatDelegate <NSObject>
@optional
//- (void)tabBarChatWithChatMessage:(QBChatMessage *)message chatDialog:(QBChatDialog *)dialog showTMessage:(BOOL)show;
@end


@protocol UsersListDelegate <NSObject>
@optional
- (void)usersListCell:(KLTableViewCell *)cell pressAddBtn:(UIButton *)sender;

- (void)contactRequestWasAcceptedForUser:(KLUser *)user;
- (void)contactRequestWasRejectedForUser:(KLUser *)user;

@end


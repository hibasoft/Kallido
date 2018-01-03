//
//  QMGroupDetailsDataSource.m
//  Kaliido
//
//  Created by Kaliido14/06/2014.
//  Copyright (c) 2014 Quickblox. All rights reserved.
//

#import "QMGroupDetailsDataSource.h"
#import "QMFriendListCell.h"
#import "QMChatReceiver.h"
#import "KLApi.h"

NSString *const kFriendsListCellIdentifier = @"QMFriendListCell";
NSString *const kLeaveChatCellIdentifier = @"QMLeaveChatCell";

@interface QMGroupDetailsDataSource ()

<KLUsersListDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSArray *participants;

@property (nonatomic, strong) QBChatDialog *chatDialog;

@end

@implementation QMGroupDetailsDataSource

- (void)dealloc {
    NSLog(@"%@ - %@",  NSStringFromSelector(_cmd), self);
    [[QMChatReceiver instance] unsubscribeForTarget:self];
}

- (id)initWithTableView:(UITableView *)tableView {

    if (self = [super init]) {
        
        _tableView = tableView;
        
        
        self.tableView.dataSource = nil;
        self.tableView.dataSource = self;
        
        __weak __typeof(self)weakSelf = self;
        
        [[QMChatReceiver instance] usersHistoryUpdatedWithTarget:self block:^{
            [weakSelf reloadUserData];
        }];
        
        [[QMChatReceiver instance] chatContactListUpdatedWithTarget:self block:^{
            [weakSelf reloadUserData];
        }];
        
        [[QMChatReceiver instance] chatAfterDidReceiveMessageWithTarget:self block:^(QBChatMessage *message) {
            
            if (message.delayed) {
                return;
            }
            if (message.cParamNotificationType == QMMessageNotificationTypeUpdateGroupDialog &&
                [message.cParamDialogID isEqualToString:weakSelf.chatDialog.ID])
            {
                [weakSelf reloadUserData];
            }
        }];
    }
    
    return self;
}

- (void)reloadDataWithChatDialog:(QBChatDialog *)chatDialog  {
    
    self.chatDialog = chatDialog;
    [self reloadUserData];
}

- (void)reloadUserData {
    
    NSArray *unsortedParticipants = [[KLApi instance] usersWithIDs:self.chatDialog.occupantIDs];
    self.participants = [QMUsersUtils sortUsersByFullname:unsortedParticipants];
    [self.tableView reloadData];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (section == 0) ? self.participants.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        return [tableView dequeueReusableCellWithIdentifier:kLeaveChatCellIdentifier];
    }
    QMFriendListCell *cell = [tableView dequeueReusableCellWithIdentifier:kFriendsListCellIdentifier];

    KLUser *user = self.participants[indexPath.row];
    
    cell.userData = user;
    cell.contactlistItem = [[KLApi instance] contactItemWithUserID:user.ID];
    cell.delegate = self;
    
    return cell;
}


#pragma mark - QMFriendListCellDelegate

- (void)usersListCell:(QMFriendListCell *)cell pressAddBtn:(UIButton *)sender {

    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    KLUser *user = self.participants[indexPath.row];
    [[KLApi instance] addUserToContactList:user completion:^(BOOL success, QBChatMessage *notification) {}];
}

@end

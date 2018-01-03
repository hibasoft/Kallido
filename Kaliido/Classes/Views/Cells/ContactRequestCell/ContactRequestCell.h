//
//  ContactRequestCell.h
//  Kaliido
//
//  Created by Daron on 28/08/2014.
//  Copyright (c) 2014 Kaliido. All rights reserved.
//

#import <Foundation/Foundation.h>

//#import "ChatCell.h"

@interface ContactRequestCell : UITableViewCell

@property (nonatomic, weak) id <UsersListDelegate> delegate;

//@property (nonatomic, strong) Message *notification;
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;

@end

//
//  QMGroupDetailsDataSource.h
//  Kaliido
//
//  Created by Kaliido14/06/2014.
//  Copyright (c) 2014 Quickblox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QMGroupDetailsDataSource : NSObject <UITableViewDataSource>

- (id)initWithTableView:(UITableView *)tableView;
- (void)reloadDataWithChatDialog:(QBChatDialog *)chatDialog;

@end

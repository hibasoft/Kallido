//
//  NotificationTableViewCell.h
//  Kaliido
//
//  Learco on 1/8/17.
//  Copyright © 2017 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NotificationCellDelegate <NSObject>
    
    @optional
    
- (void)didCloseNotification;

    
@end

@interface NotificationTableViewCell : UITableViewCell
    @property (weak, nonatomic) IBOutlet UILabel *firstLabel;
    @property (weak, nonatomic) IBOutlet UILabel *secondLabel;

    @property (assign) id<NotificationCellDelegate> delegate;
@end

//
//  ActivityTableViewCell.h
//  Kaliido
//
//  Learco on 1/8/17.
//  Copyright © 2017 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityTableViewCell : UITableViewCell
    @property (weak, nonatomic) IBOutlet UIView *barView;
    @property (weak, nonatomic) IBOutlet UILabel *percentLabel;
    @property (weak, nonatomic) IBOutlet UILabel *activityLabel;

@end

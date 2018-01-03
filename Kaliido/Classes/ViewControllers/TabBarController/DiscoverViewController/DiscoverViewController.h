//
//  DiscoverViewController.h
//  Kaliido
//
//  Hiba on 1/8/17.
//  Copyright © 2017 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WeatherModel.h"
#import "NotificationModel.h"
#import "ActivityModel.h"
#import "EventModel.h"
#import "GroupModel.h"
#import "WeatherTableViewCell.h"
#import "NotificationTableViewCell.h"
#import "ActivityTableViewCell.h"
#import "EventTableViewCell.h"
#import "GroupTableViewCell.h"

@interface DiscoverViewController : UIViewController<UITableViewDataSource,UITableViewDelegate, NotificationCellDelegate>
{
    WeatherModel* mWeather;
    NotificationModel* mNotification;
    NSMutableArray* mArrayActivity;
    NSMutableArray* mArrayEvent;
    NSMutableArray* mArrayGroup;
    
    BOOL bCloseNotification;
}
@property (nonatomic,strong) IBOutlet  UITableView *tableView;

@end

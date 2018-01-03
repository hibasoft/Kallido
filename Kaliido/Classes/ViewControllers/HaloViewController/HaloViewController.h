//
//  HaloViewController.h
//  Kaliido
//
//  Created by  Kaliido on 1/27/15.
//  Copyright (c) 2015 Quickblox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftSlideViewController.h"
@interface HaloViewController : LeftSlideViewController < UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *tableViewHalo;
}
@end

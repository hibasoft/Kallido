//
//  ActivityViewController.h
//  Kaliido
//
//  Hiba on 1/9/17.
//  Copyright © 2017 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
    
    @property (nonatomic,strong) IBOutlet  UITableView *tableView;
    
    @end

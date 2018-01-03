//
//  StumblerDetailViewController.h
//  Kaliido
//
//  Created by  Kaliido on 2/24/15.
//  Copyright (c) 2015 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLStumblerModel.h"
@interface StumblerDetailViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) KLStumblerModel *model;
@end

//
//  StumblerSubCategoryViewController.h
//  Kaliido
//
//  Created by  Kaliido on 12/29/15.
//  Copyright © 2015 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StumblerCreateViewController.h"
#import "SubInterestCell.h"

@interface StumblerSubCategoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, SubInterestDelegate>
@property (strong, nonatomic) IBOutlet UITableView *subInterestTableView;
@property (strong, nonatomic) StumblerCreateViewController *parent;
@property (nonatomic, assign) NSUInteger selectedCategory;
@end
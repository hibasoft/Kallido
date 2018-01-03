//
//  SubInterestViewController.h
//  Kaliido
//
//  Created by  Kaliido on 3/8/15.
//  Copyright (c) 2015 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileViewController.h"
#import "SubInterestCell.h"
#import "YourDetailsViewController.h"
#import "DirectoryCreateViewController.h"
@interface SubInterestViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, SubInterestDelegate>
{
    
}

@property (strong, nonatomic) IBOutlet UITableView *subInterestTableView;
@property (strong, nonatomic) ProfileViewController *parent;
@property (strong, nonatomic) YourDetailsViewController *detailParent;
@property (strong, nonatomic) DirectoryCreateViewController *directoryParent;
@property (nonatomic, assign) NSUInteger selectedCategory;

@end

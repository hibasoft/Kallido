//
//  DirectorySubViewController.h
//  Kaliido
//
//  Created by Vadim Budnik on 6/21/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CategoryViewModel.h"

@interface DirectorySubViewController : UIViewController
{
    IBOutlet UITableView *tbContentList;
}

@property (nonatomic, strong) CategoryViewModel *selectedCategory;

@end

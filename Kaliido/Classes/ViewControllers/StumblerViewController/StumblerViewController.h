//
//  StumblerViewController.h
//  Kaliido
//
//  Created by  Kaliido on 1/28/15.
//  Copyright (c) 2015 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StumblerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *tbl;
}
@property (nonatomic) int  categoryId;
@property (nonatomic, strong) NSString *searchString;
@end

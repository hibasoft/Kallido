//
//  PeopleCell.h
//  Kaliido
//
//  Created by  Kaliido on 11/17/15.
//  Copyright © 2015 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLImageView.h"
#import "CheckBoxProtocol.h"

@interface PeopleCell : UITableViewCell
@property (strong, nonatomic) IBOutlet KLImageView *userImageView;
@property (strong, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UIImageView *activeCheckbox;

@property (assign, nonatomic, getter = isChecked) BOOL check;
@property (weak, nonatomic) id <CheckBoxProtocol> delegate;
-(void)updateData:(NSDictionary*)userDic checked:(BOOL) bChecked;

@end

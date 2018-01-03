//
//  SubInterestCell.h
//  Kaliido
//
//  Created by  Kaliido on 3/9/15.
//  Copyright (c) 2015 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SubInterestCell;
@protocol SubInterestDelegate <NSObject>
-(void) addButtonClicked:(SubInterestCell*) sender;
@end

@interface SubInterestCell : UITableViewCell

@property (nonatomic, assign) IBOutlet UILabel *lblSubInterest;
@property (nonatomic, assign) IBOutlet UIButton *btnAdd;
@property (nonatomic, weak) id<SubInterestDelegate> delegate;

@end

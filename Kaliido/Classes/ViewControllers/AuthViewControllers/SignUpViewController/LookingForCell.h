//
//  KLLookingForCell.h
//  Kaliido
//
//  Created by  Kaliido on 3/6/15.
//  Copyright (c) 2015 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LookingForCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *lblTitle;
@property (nonatomic, weak) IBOutlet UIButton *btnAdd;

- (IBAction) actionAdd:(id)sender;

@end

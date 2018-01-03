//
//  HaloTableViewCell.h
//  Kaliido
//
//  Created by  Kaliido on 1/27/15.
//  Copyright (c) 2015 Quickblox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLImageView.h"

@interface HaloTableViewCell : UITableViewCell
{
}
@property(nonatomic, assign) IBOutlet KLImageView *imgProf;
@property(nonatomic, assign) IBOutlet UILabel *lblName;
@property(nonatomic, assign) IBOutlet UILabel *lblLink;
@property(nonatomic, assign) IBOutlet UIButton *btnConnectionStatus;
@end

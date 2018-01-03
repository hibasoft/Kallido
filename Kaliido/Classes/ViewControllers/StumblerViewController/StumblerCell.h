//
//  StumblerCell.h
//  Kaliido
//
//  Created by  Kaliido on 2/24/15.
//  Copyright (c) 2015 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLImageView.h"

@interface StumblerCell : UITableViewCell
{
    
}
@property (nonatomic, weak) IBOutlet KLImageView *imgProfile;
@property (nonatomic, weak) IBOutlet UILabel *lblOrganizationName;
@property (nonatomic, weak) IBOutlet UILabel *lblNumAttendees;
@property (nonatomic, weak) IBOutlet UILabel *lblWeekday;
@property (nonatomic, weak) IBOutlet UIButton *btnCheckMark;

-(void) updateData:(NSDictionary*) userDic;
@end

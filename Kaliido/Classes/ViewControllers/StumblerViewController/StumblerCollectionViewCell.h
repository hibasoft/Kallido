//
//  StumblerCollectionViewCell.h
//  Kaliido
//
//  Created by  Kaliido on 12/28/15.
//  Copyright © 2015 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLImageView.h"

@interface StumblerCollectionViewCell : UICollectionViewCell
@property (nonatomic, weak) IBOutlet KLImageView *imgProfile;
@property (nonatomic, weak) IBOutlet UILabel *lblOrganizationName;
@property (nonatomic, weak) IBOutlet UILabel *lblNumAttendees;
@property (nonatomic, weak) IBOutlet UILabel *lblWeekday;
@property (nonatomic, weak) IBOutlet UIButton *btnCheckMark;

-(void) updateData:(NSDictionary*) userDic;
@end

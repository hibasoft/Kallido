//
//  PrivacyViewController.h
//  Kaliido
//
//  Learco on 9/19/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLSwitch.h"
@interface PrivacyViewController : UITableViewController


@property (nonatomic, retain) IBOutlet KLSwitch* swShowBirthday;
@property (nonatomic, retain) IBOutlet KLSwitch* swShowAge;
@property (nonatomic, retain) IBOutlet KLSwitch* swShowActivities;
@property (nonatomic, retain) IBOutlet KLSwitch* swShowRelationsip;
@property (nonatomic, retain) IBOutlet KLSwitch* swShowLookingFor;
@end

//
//  AttendeTableViewCell.h
//  Kaliido
//
//  Created by  Kaliido on 10/9/15.
//  Copyright © 2015 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLImageView.h"

@interface AttendeTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet KLImageView *attendeeImageView;
@property (strong, nonatomic) IBOutlet UILabel *attendeeNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *attendeeDateLabel;

@end

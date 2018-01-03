//
//  KLVenueViewItemTableViewCell.h
//  Kaliido
//
//  Created by Hiba R on 5/24/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VenueViewItemTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *venueNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *milesLabel;
@property (weak, nonatomic) IBOutlet UILabel *venueTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *visitLabel;

@end

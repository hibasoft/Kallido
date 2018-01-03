//
//  KLVenueDetailCheckInTableViewCell.h
//  Kaliido
//
//  Created by Hiba R on 5/24/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface VenueDetailCheckInTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *venueNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingsLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;



@end

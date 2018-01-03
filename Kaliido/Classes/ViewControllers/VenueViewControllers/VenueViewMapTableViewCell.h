//
//  KLVenueViewMapTableViewCell.h
//  Kaliido
//
//  Created by Learco R on 5/24/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface VenueViewMapTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

//
//  MessageCell.h
//  Kaliido
//
//  Created by Learco R on 6/6/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MessageCell : UITableViewCell
@property (nonatomic, retain) IBOutlet UIImageView* bgImageView;
@property (nonatomic, retain) IBOutlet UIImageView* profileImageView;
@property (nonatomic, retain) IBOutlet UILabel* senderAndTimeLabel;
@property (nonatomic, retain) IBOutlet UITextView* messageContentView;
@property (nonatomic, retain) IBOutlet UIImageView* fileImageView;
@property (nonatomic, retain) IBOutlet MKMapView* mapView;
@property (nonatomic, retain) IBOutlet UIButton* btnViewContent;
@end

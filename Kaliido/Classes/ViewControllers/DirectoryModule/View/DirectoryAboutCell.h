//
//  DirectoryAboutCell.h
//  Kaliido
//
//  Created by Vadim Budnik on 7/1/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@protocol DirectoryAboutCellDelegate <NSObject>

@optional

- (void)didRequestToCall:(NSString*)phoneNo;
- (void)didRequestToViewAllAbout;

@end

@class DirectoryViewModel;

@interface DirectoryAboutCell : UITableViewCell
{
    IBOutlet UIButton *btViewAll;
    IBOutlet MKMapView *mvMap;
    IBOutlet UILabel *lbAddress;
    IBOutlet UIButton *btPhoneNo;
}

@property (assign) id<DirectoryAboutCellDelegate> delegate;

- (void)configureCellWithDirectoryViewModel:(DirectoryViewModel*)directoryModel;

@end

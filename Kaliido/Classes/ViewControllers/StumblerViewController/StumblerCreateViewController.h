//
//  StumblerCreateViewController.h
//  Kaliido
//
//  Created by  Kaliido on 9/7/15.
//  Copyright (c) 2015 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface StumblerCreateViewController : UIViewController
@property (strong, nonatomic) MKPointAnnotation *currentPoint;
@property (strong, nonatomic) NSMutableArray *peopleArray;
@property (strong, nonatomic) NSMutableArray *peopleNameArray;
@property (strong, nonatomic) NSMutableArray *peopleDataArray;
@property (strong, nonatomic) NSMutableArray *stumblerArray;
@property (strong, nonatomic) NSMutableArray *stumblerNameArray;
@end

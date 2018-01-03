//
//  MapViewController.h
//  Kaliido
//
//  Hiba on 6/18/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@protocol ChatMapViewtDelegate <NSObject>
@optional
- (void)didAttachLocation:(CLLocation*)location;
@end

@interface ChatMapViewController : UIViewController
{
   
}
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic)   CLLocation *location;
@property (readwrite) int nMode;
@property (weak, nonatomic) id <ChatMapViewtDelegate> delegate;
@end

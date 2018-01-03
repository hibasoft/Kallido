//
//  MapViewController.m
//  Kaliido
//
//  Learco on 6/18/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "ChatMapViewController.h"

@interface ChatMapViewController ()

@end

@implementation ChatMapViewController
@synthesize location, mapView;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.nMode == 0) {//edit mode
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
        [self.mapView addGestureRecognizer:longPressGesture];
    }else
    {//view mode
        MKCoordinateRegion region;
        region.center.latitude = location.coordinate.latitude;
        region.center.longitude = location.coordinate.longitude;
        region.span.latitudeDelta = 0.2;
        region.span.longitudeDelta = 0.2;
        [self.mapView setRegion:region animated:NO];
        //---------------------------------------------------------------------------------------------------------------------------------------------
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        [self.mapView addAnnotation:annotation];
        [annotation setCoordinate:location.coordinate];

    }
    
    
    
}
 
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

-(void)handleLongPressGesture:(UIGestureRecognizer*)sender {
    // This is important if you only want to receive one tap and hold event
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        [mapView removeAnnotations:[mapView annotations]];
        // Here we get the CGPoint for the touch and convert it to latitude and longitude coordinates to display on the map
        CGPoint point = [sender locationInView:self.mapView];
        CLLocationCoordinate2D locCoord = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
        // Then all you have to do is create the annotation and add it to the map
        MKPointAnnotation *dropPin = [[MKPointAnnotation alloc] init];
        dropPin.coordinate = locCoord;
        [self.mapView addAnnotation:dropPin];
        self.location = [[CLLocation alloc] initWithLatitude:locCoord.latitude longitude:locCoord.longitude];
    }
    else
    {
        
        
    }
}

-(IBAction)onTapDone:(id)sender
{
    [self.navigationController popViewControllerAnimated:true];
    if (self.nMode == 0) {
    
        [self.delegate didAttachLocation:self.location];
    }
    
}
-(IBAction)onTapBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:true];
}
//MARK: mapview delegate
- (void)mapView:(MKMapView *)mapView
didAddAnnotationViews:(NSArray *)annotationViews
{
    for (MKAnnotationView *annView in annotationViews)
    {
        CGRect endFrame = annView.frame;
        annView.frame = CGRectOffset(endFrame, 0, -500);
        [UIView animateWithDuration:0.3
                         animations:^{ annView.frame = endFrame; }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

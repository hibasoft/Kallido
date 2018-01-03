//
//  MapViewController.m
//  Kaliido
//
//  Created by  Kaliido on 9/9/15.
//  Copyright (c) 2015 Kaliido. All rights reserved.
//

#import "MapViewController.h"

#import <MapKit/MapKit.h>
@interface MapViewController ()<UISearchBarDelegate, MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>{
    
    CLLocationDegrees           latForSearch;
    CLLocationDegrees           longForSearch;
    CLLocationManager*          locationManager;
}
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UITableView *addressTableView;

@property (strong, nonatomic) NSMutableArray *addressArray;
@property (nonatomic, strong) MKLocalSearch             *localSearch;
@property (strong, nonatomic) MKPointAnnotation *selectAnnotation;
@end
@implementation MapViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.mapView setDelegate:self];
    [self.mapView setMapType:MKMapTypeStandard];
    self.mapView.showsUserLocation = YES;
    self.addressArray = [[NSMutableArray alloc] init];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(foundTap:)];
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.numberOfTouchesRequired = 1;
    [self.mapView addGestureRecognizer:tapRecognizer];
    
    [self.searchBar setReturnKeyType:UIReturnKeyDone];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction) actionBack:(id)sender
{
    if (self.selectAnnotation != nil && self.selectAnnotation.title != nil && [self.selectAnnotation.title length] >0)
    {
        self.parent.currentPoint = self.selectAnnotation;
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:self.selectAnnotation.coordinate.latitude longitude:self.selectAnnotation.coordinate.longitude];
    [geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
        [SVProgressHUD dismiss];
        if (error)
        {
            self.parent.currentPoint = self.selectAnnotation;
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        
        CLPlacemark *placemark = [placemarks lastObject];
        NSString *strAdd = nil;
        
        if ([placemark.subThoroughfare length] != 0)
            strAdd = placemark.subThoroughfare;
        
        if ([placemark.thoroughfare length] != 0)
        {
            if ([strAdd length] != 0)
                strAdd = [NSString stringWithFormat:@"%@, %@",strAdd,[placemark thoroughfare]];
            else
            {
                strAdd = placemark.thoroughfare;
            }
        }
        
        if ([placemark.postalCode length] != 0)
        {
            if ([strAdd length] != 0)
                strAdd = [NSString stringWithFormat:@"%@, %@",strAdd,[placemark postalCode]];
            else
                strAdd = placemark.postalCode;
        }
        
        if ([placemark.locality length] != 0)
        {
            if ([strAdd length] != 0)
                strAdd = [NSString stringWithFormat:@"%@, %@",strAdd,[placemark locality]];
            else
                strAdd = placemark.locality;
        }
        
        if ([placemark.administrativeArea length] != 0)
        {
            if ([strAdd length] != 0)
                strAdd = [NSString stringWithFormat:@"%@, %@",strAdd,[placemark administrativeArea]];
            else
                strAdd = placemark.administrativeArea;
        }
        
        if ([placemark.country length] != 0)
        {
            if ([strAdd length] != 0)
                strAdd = [NSString stringWithFormat:@"%@, %@",strAdd,[placemark country]];
            else
                strAdd = placemark.country;
        }
        self.selectAnnotation.title = strAdd;
        self.parent.currentPoint = self.selectAnnotation;
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

-(IBAction)foundTap:(UITapGestureRecognizer*)recognizer
{
    CGPoint point = [recognizer locationInView:self.mapView];
    CLLocationCoordinate2D tapPoint = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
    MKPointAnnotation *annotation;
    annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = tapPoint;
    if (self.selectAnnotation != nil)
        [self.mapView removeAnnotation:self.selectAnnotation];
    self.selectAnnotation = annotation;
    [self.mapView addAnnotation:annotation];
    return;
    // add title annotation;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:tapPoint.latitude longitude:tapPoint.longitude];
    
    [geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error)
        {
            MKPointAnnotation *annotation;
            annotation = [[MKPointAnnotation alloc] init];
            annotation.coordinate = loc.coordinate;
            if (self.selectAnnotation != nil)
                [self.mapView removeAnnotation:self.selectAnnotation];
            self.selectAnnotation = annotation;
            [self.mapView addAnnotation:annotation];
            return;
        }
        
        CLPlacemark *placemark = [placemarks lastObject];
        NSString *strAdd = nil;
        
        if ([placemark.subThoroughfare length] != 0)
            strAdd = placemark.subThoroughfare;
        
        if ([placemark.thoroughfare length] != 0)
        {
            if ([strAdd length] != 0)
                strAdd = [NSString stringWithFormat:@"%@, %@",strAdd,[placemark thoroughfare]];
            else
            {
                strAdd = placemark.thoroughfare;
            }
        }
        
        if ([placemark.postalCode length] != 0)
        {
            if ([strAdd length] != 0)
                strAdd = [NSString stringWithFormat:@"%@, %@",strAdd,[placemark postalCode]];
            else
                strAdd = placemark.postalCode;
        }
        
        if ([placemark.locality length] != 0)
        {
            if ([strAdd length] != 0)
                strAdd = [NSString stringWithFormat:@"%@, %@",strAdd,[placemark locality]];
            else
                strAdd = placemark.locality;
        }
        
        if ([placemark.administrativeArea length] != 0)
        {
            if ([strAdd length] != 0)
                strAdd = [NSString stringWithFormat:@"%@, %@",strAdd,[placemark administrativeArea]];
            else
                strAdd = placemark.administrativeArea;
        }
        
        if ([placemark.country length] != 0)
        {
            if ([strAdd length] != 0)
                strAdd = [NSString stringWithFormat:@"%@, %@",strAdd,[placemark country]];
            else
                strAdd = placemark.country;
        }
        MKPointAnnotation *annotation;
        annotation = [[MKPointAnnotation alloc] init];
        annotation.coordinate = loc.coordinate;
        annotation.title = strAdd;
        if (self.selectAnnotation != nil)
            [self.mapView removeAnnotation:self.selectAnnotation];
        self.selectAnnotation = annotation;
        [self.mapView addAnnotation:annotation];
    }];

}
#pragma mark - MKMapViewDelegate
-(void) mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKPointAnnotation *annotation;
    annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = userLocation.location.coordinate;
    if (self.selectAnnotation != nil)
        [self.mapView removeAnnotation:self.selectAnnotation];
    self.selectAnnotation = annotation;
    [self.mapView addAnnotation:annotation];
    [self.mapView setCenterCoordinate:annotation.coordinate animated:YES];
    return;
    //add title on annotation;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error)
           return;
        
        CLPlacemark *placemark = [placemarks lastObject];
        NSString *strAdd = nil;
        
        if ([placemark.subThoroughfare length] != 0)
            strAdd = placemark.subThoroughfare;
        
        if ([placemark.thoroughfare length] != 0)
        {
            if ([strAdd length] != 0)
                strAdd = [NSString stringWithFormat:@"%@, %@",strAdd,[placemark thoroughfare]];
            else
            {
                strAdd = placemark.thoroughfare;
            }
        }
        
        if ([placemark.postalCode length] != 0)
        {
            if ([strAdd length] != 0)
                strAdd = [NSString stringWithFormat:@"%@, %@",strAdd,[placemark postalCode]];
            else
                strAdd = placemark.postalCode;
        }
        
        if ([placemark.locality length] != 0)
        {
            if ([strAdd length] != 0)
                strAdd = [NSString stringWithFormat:@"%@, %@",strAdd,[placemark locality]];
            else
                strAdd = placemark.locality;
        }
        
        if ([placemark.administrativeArea length] != 0)
        {
            if ([strAdd length] != 0)
                strAdd = [NSString stringWithFormat:@"%@, %@",strAdd,[placemark administrativeArea]];
            else
                strAdd = placemark.administrativeArea;
        }
        
        if ([placemark.country length] != 0)
        {
            if ([strAdd length] != 0)
                strAdd = [NSString stringWithFormat:@"%@, %@",strAdd,[placemark country]];
            else
                strAdd = placemark.country;
        }
        MKPointAnnotation *annotation;
        annotation = [[MKPointAnnotation alloc] init];
        annotation.coordinate = userLocation.location.coordinate;
        annotation.title = strAdd;
        if (self.selectAnnotation != nil)
            [self.mapView removeAnnotation:self.selectAnnotation];
        self.selectAnnotation = annotation;
        [self.mapView addAnnotation:annotation];
        [self.mapView setCenterCoordinate:annotation.coordinate animated:YES];
    }];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    __block NSString *tsearch = [searchText copy];
    if ([searchBar.text isEqualToString:@""])
    {
        [self.addressTableView setHidden:YES];
        return;
    }else
    {
        [self.addressTableView setHidden:NO];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if ([searchBar.text isEqualToString:tsearch]) {
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
            latForSearch = longForSearch = 0.0f;
            [self startSearch:searchBar.text];
            [self.addressTableView setHidden:NO];
        }
    });
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    return self.addressArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MKPointAnnotation *pointAnnotation = [self.addressArray objectAtIndex:indexPath.row];
    if (self.selectAnnotation != nil)
        [self.mapView removeAnnotation:self.selectAnnotation];
    self.selectAnnotation = pointAnnotation;
    [self.mapView setCenterCoordinate:pointAnnotation.coordinate animated:YES];
    [self.mapView addAnnotation:pointAnnotation];
    
    [self.addressTableView setHidden:YES];
    
    self.searchBar.text = @"";
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self.searchBar resignFirstResponder];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *mapCell = [tableView dequeueReusableCellWithIdentifier:@"mapIdentifier"];
    if (mapCell == nil)
    {
        mapCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mapIdentifier"];
    }
    MKPointAnnotation *annotation =(MKPointAnnotation*)[self.addressArray objectAtIndex:indexPath.row];
    mapCell.textLabel.text = annotation.title;
    return mapCell;
}

- (void)startSearch:(NSString *)searchString
{
    if (self.localSearch.searching)
    {
        [self.localSearch cancel];
    }
    
    // confine the map search area to the user's current location
    MKCoordinateRegion newRegion;
    
    newRegion.center.latitude = latForSearch;
    newRegion.center.longitude = longForSearch;

//    newRegion.span.latitudeDelta = 0.00112872;
//    newRegion.span.longitudeDelta = 0.00109863;
    
    [self.mapView setRegion:newRegion animated:YES];
    
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    
    request.naturalLanguageQuery = searchString;
    request.region = newRegion;
    
    MKLocalSearchCompletionHandler completionHandler = ^(MKLocalSearchResponse *response, NSError *error)
    {
        [SVProgressHUD dismiss];
        if (error != nil)
        {
            [self.addressArray removeAllObjects];
            [self.addressTableView reloadData];
        }
        else
        {
            [self.addressArray removeAllObjects];
            NSArray *places = [response mapItems];
            for(MKMapItem *mapItem in places)
            {
                MKPointAnnotation *annotation;
                annotation = [[MKPointAnnotation alloc] init];
                annotation.coordinate = mapItem.placemark.location.coordinate;
                annotation.title = mapItem.name;
                [self.addressArray addObject:annotation];
            }
            
            [self.addressTableView reloadData];
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    };
    
    if (self.localSearch != nil)
    {
        self.localSearch = nil;
    }
    self.localSearch = [[MKLocalSearch alloc] initWithRequest:request];
    
    [self.localSearch startWithCompletionHandler:completionHandler];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
@end

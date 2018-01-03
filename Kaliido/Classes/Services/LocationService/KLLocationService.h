//
//  KLLocationService.m
//  Kaliido
//
//  Created by  Kaliido on 1/22/15.
//  Copyright (c) 2015 Kaliido. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
@protocol LocationServiceDelegate <NSObject>

- (void) locationFound:(CLLocation*) location isNew:(BOOL)newLocation;
- (void) locationNotFound;

@optional

- (void) badAccuracylocationFound:(CLLocation*) location;

@end

@interface KLLocationService: NSObject <CLLocationManagerDelegate>
{
    NSTimer *_timer;
}

// Start location service and add a delegate
- (void)startWithDelegate:(id<LocationServiceDelegate>)delegate implicitly:(BOOL)implicitly;

// Sets user location manually
- (void)setUserLocation:(CLLocation*)location;

- (CLLocation*)getLastLocation;

- (void)stopAndRemoveAllDelegates;
- (void)removeDelegate:(id)delegate;

+ (void)initialize;
+ (KLLocationService *)instance;


@end




#define MAX_LOCATION_LIFETIME 3000 // In seconds
#define MIN_LOCATION_ACCURACY 300 // In meters
#define LOCATION_SERVICE_TIMEOUT 10 // In seconds

#import "KLLocationService.h"

@interface KLLocationService()

- (void)startLocationService;
- (void)stopLocationService;
- (BOOL)returnLocation;

@end

@implementation KLLocationService


static CLLocationManager* locationManager;

static CLLocation* userLocation;

static BOOL locationUpdated;
static double getUserLocationRunTimestamp;

static NSDate* lastUpdate = nil;
static NSMutableArray* delegates;

static KLLocationService *sharedInstance;

+ (KLLocationService *)instance
{
    return sharedInstance;
}

+ (void)initialize
{
    static BOOL initialized = NO;
    
    if(!initialized)
    {
        initialized = YES;
        
        sharedInstance = [[KLLocationService alloc] init];
        delegates = [[NSMutableArray alloc] init];
        
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = sharedInstance;
        locationManager.distanceFilter = 100;
        //[locationManager requestAlwaysAuthorization];
        [locationManager requestWhenInUseAuthorization];
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
}
+(BOOL)shouldFetchUserLocation{
    
    BOOL shouldFetchLocation= NO;
    
    if ([CLLocationManager locationServicesEnabled]) {
        switch ([CLLocationManager authorizationStatus]) {
            case kCLAuthorizationStatusAuthorized:
                shouldFetchLocation= YES;
                break;
            case kCLAuthorizationStatusDenied:
            {
                UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Error" message:@"App level settings has been denied" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alert show];
                alert= nil;
            }
                break;
            case kCLAuthorizationStatusNotDetermined:
            {
                UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Error" message:@"The user is yet to provide the permission" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alert show];
                alert= nil;
            }
                break;
            case kCLAuthorizationStatusRestricted:
            {
                UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Error" message:@"The app is recstricted from using location services." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alert show];
                alert= nil;
            }
                break;
                
            default:
                break;
        }
    }
    else{
        UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Error" message:@"The location services seems to be disabled from the settings." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        alert= nil;
    }
    
    return shouldFetchLocation;
}
- (void)setUserLocation:(CLLocation*)location
{
    if (userLocation)
    {
        userLocation = nil;
    }
    userLocation = location;
    if (lastUpdate)
    {
        lastUpdate = nil;
        
    }
    lastUpdate = [NSDate date];
    locationUpdated = YES;
    
    [self returnLocation];
}

- (void)startWithDelegate:(id<LocationServiceDelegate>)delegate implicitly:(BOOL)implicitly
{
    getUserLocationRunTimestamp = [[NSDate date] timeIntervalSince1970];
    
    if(delegate != nil)
        if([delegates count] == 0 || [delegates indexOfObject:delegate] != NSNotFound)
        {
            [delegates addObject: delegate];
        }
    
    // If it takes too long to find user location - send locationNotFound
    if(!_timer)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:LOCATION_SERVICE_TIMEOUT
                                                  target:self
                                                selector:@selector(timeout:)
                                                userInfo:nil
                                                 repeats:NO];
        
        [[NSRunLoop currentRunLoop] addTimer:_timer
                                     forMode:NSDefaultRunLoopMode];
    }
    
    BOOL locationExpired = [[NSDate date] timeIntervalSinceDate:lastUpdate] > MAX_LOCATION_LIFETIME;
    
    if(implicitly || lastUpdate == nil || locationExpired)
    {
        [self startLocationService];
    }
    else
    {
        [self returnLocation];
    }
}

- (CLLocation*)getLastLocation
{
    return userLocation;
}

- (void) stopAndRemoveAllDelegates
{
    [self stopLocationService];
    [delegates removeAllObjects];
}

- (void)removeDelegate:(id)delegate
{
    if(delegate != nil)
        if([delegates count] > 0 && ([delegates indexOfObject:delegate] != NSNotFound))
        {
            [delegates removeObject:delegate];
        }
}

#pragma mark - Private

- (BOOL)returnLocation
{
    [self stopLocationService];
    
    [self callWebService];
    if(userLocation == nil)
    {
        return NO;
    }
    else
    {
        while ([delegates count] > 0)
        {
            id<LocationServiceDelegate> delegate = [delegates objectAtIndex:0];
            [delegate locationFound:userLocation isNew:locationUpdated];
            [delegates removeObject:delegate];
        }
        
        [delegates removeAllObjects];
        
        return YES;
    }
}

- (void) callWebService
{
//    // create QBLGeoData entity
//    QBLGeoData *geoData = [QBLGeoData geoData];
//    geoData.latitude = locationManager.location.coordinate.latitude;
//    geoData.longitude = locationManager.location.coordinate.longitude;
//    geoData.status = @"Update Location";
//    NSLog(@"Geo data is (%f, %f)", geoData.latitude, geoData.longitude);
//    // post own location
//    [QBRequest createGeoData:geoData successBlock:^(QBResponse *response, QBLGeoData *geoDataR) {
//        NSLog(@"Geo register success");
//    } errorBlock:^(QBResponse *response) {
//        NSLog(@"Can't register the geo data");
//     }];
}

- (void)returnBadAccuracyLocation
{
    for(int i = 0; i < [delegates count]; ++i)
    {
        id<LocationServiceDelegate> delegate = [delegates objectAtIndex:i];
        if([delegate respondsToSelector:@selector(badAccuracylocationFound:)])
            [delegate badAccuracylocationFound:userLocation];
    }
}

- (void)startLocationService
{
    //if ([KLLocationService shouldFetchUserLocation]) {
        [locationManager startUpdatingLocation];
    //}
}

- (void) stopLocationService
{
    [locationManager stopUpdatingLocation];
}

- (void)timeout:(id) timer
{
    [self locationManager:nil didFailWithError:nil];
}

#pragma mark - CLLocationManagerDelegate methods

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [_timer invalidate];
    _timer = nil;
    NSLog(@"%@", error.description);
    [self stopLocationService];
    
    // Block other threads until completed
    @synchronized(self)
    {
        for(id<LocationServiceDelegate> delegate in delegates)
        {
            [delegate locationNotFound];
        }
        
        [delegates removeAllObjects];
    }
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations{
    [_timer invalidate];
    _timer = nil;
    NSLog(@"get location!!");
    CLLocation *newLocation = [locations lastObject];
    BOOL locationExpired = [[NSDate date] timeIntervalSinceDate:newLocation.timestamp] > MAX_LOCATION_LIFETIME;
    BOOL goodAccuracy = newLocation.horizontalAccuracy < MIN_LOCATION_ACCURACY;
    BOOL timeout = [[NSDate date] timeIntervalSince1970] - getUserLocationRunTimestamp > LOCATION_SERVICE_TIMEOUT;
    
    if((!locationExpired && goodAccuracy) || timeout)
    {
        [self stopLocationService];
        if (userLocation)
        {
            userLocation = nil;
        }
        userLocation = newLocation;
        
        [self returnLocation];
        if (lastUpdate)
        {
            lastUpdate = nil;
        }
        lastUpdate = [NSDate date];
    }
    else
    {
        userLocation = newLocation;
        [self returnBadAccuracyLocation];
        
    }
}

@end
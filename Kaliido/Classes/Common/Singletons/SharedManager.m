//
//  SharedManager.m
//  Kaliido
//
//  Created by Vadim Budnik on 06/21/16.
//  Copyright (c) 2016 Kaliido. All rights reserved.
//

#import "SharedManager.h"

#import "NSDate+TimeAgo.h"
#import <AVFoundation/AVFoundation.h>


@implementation SharedManager

#pragma mark - Singleton SharedInstance

+ (SharedManager*)sharedManager
{
    static SharedManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[SharedManager alloc] init];
        _sharedManager.locationServiceEnabled = NO;
        _sharedManager.currentLatitude = 0.0f;
        _sharedManager.currentLongitude = 0.0f;
    });
    
    return _sharedManager;
}

- (UIStoryboard *)storyboard:(NSString*)boardName
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:boardName bundle:[NSBundle mainBundle]];
    
    return storyboard;
}

- (UIViewController*)loadViewControllerFromStoryboard:(NSString*)boardName ViewControllerIdentifier:(NSString*)viewControllerIdentifier
{
    UIStoryboard *storyboard=[self storyboard:boardName];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:viewControllerIdentifier];
    
    return viewController;
}

#pragma mark - Validators

+ (BOOL)isEmailValid:(NSString *)email
{
    NSString *emailReg = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailReg];
    
    if ( [emailTest evaluateWithObject:email] == YES)
    {
        return YES;
    }
    
    return NO;
}

+ (BOOL)isPasswordValid:(NSString*)password
{
    int len = (int)[password length];
    
    if (len>=8 && len<=32)
    {
        return YES;
    }
    
    return NO;
}

+ (NSDate*)getDateTimeFrom:(NSString*)strDateTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate *datetimeMoment = [dateFormatter dateFromString:strDateTime];
    
    return datetimeMoment;
}

+ (NSString*)getTimeFrom:(NSString*)strDateTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate *datetimeMoment = [dateFormatter dateFromString:strDateTime];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    
    NSString *result = [dateFormatter stringFromDate:datetimeMoment];
    
    return result;
}

+ (NSString*)getFormattedPostMomentFrom:(NSString*)strMoment
{
    NSDate *dtMoment = [SharedManager getDateTimeFrom:strMoment];
    
    return [dtMoment timeAgo];
}

+ (NSString*)getFormattedNumber:(int)num
{
    NSString *result = @"";
    int q6 = num/1000000; // - 1M
    int q3 = (num%1000000)/1000; // - 999K
    
    if (q6>0)
    {
        //More than 1 Million
        result = [NSString stringWithFormat:@"%dM", q6];
    }
    else
    {
        //Less than 1 Million
        if (q3>0)
        {
            //More than 1K
            if (q3/100>0)
            {
                //e.g., 134K, 999K
                result = [NSString stringWithFormat:@"%dK", q3];
            }
            else
            {
                //e.g., 13.4K, 9.8K, 58K, 72K
                int q0 = ((num%1000000)%1000)/100;
                if (q0>0)
                {
                    //13.4K, 9.8K
                    result = [NSString stringWithFormat:@"%d.%dK", q3%100, q0];
                }
                else
                {
                    //58K, 72K
                    result = [NSString stringWithFormat:@"%dK", q3%100];
                }
            }
        }
        else
        {
            //Less than 1K
            result = [NSString stringWithFormat:@"%d", num];
        }
    }
    
    return result;
}

+ (UIImage *)generateThumbImageOf:(NSString *)filepath At:(float)timeAt
{
    NSURL *url = [NSURL fileURLWithPath:filepath];
    
    AVAsset *asset = [AVAsset assetWithURL:url];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    CMTime time = [asset duration];
    time.value = timeAt; // Time in milliseconds
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);  // CGImageRef won't be released by ARC
    
    return thumbnail;
}

+ (NSArray*)generateThumbnailsOf:(NSString*)filepath AtTimes:(NSArray*)timetable
{
    NSMutableArray *arResult = [@[] mutableCopy];
    
    NSURL *url = [NSURL fileURLWithPath:filepath];
    
    AVAsset *asset = [AVAsset assetWithURL:url];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    CMTime time = [asset duration];
    
    for (int i=0;i<[timetable count];i++)
    {
        float timeAt = [[timetable objectAtIndex:i] floatValue];
        time.value = timeAt; // Time in milliseconds
        CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
        UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
        [arResult addObject:thumbnail];
        
        CGImageRelease(imageRef);  // CGImageRef won't be released by ARC
    }
    
    return arResult;
}

#pragma mark - Methods




@end

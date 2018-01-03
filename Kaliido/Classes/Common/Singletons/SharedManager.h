//
//  SharedManager.h
//  Kaliido
//
//  Created by Vadim Budnik on 06/21/16.
//  Copyright (c) 2016 Kaliido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedManager : NSObject

@property (nonatomic, assign) BOOL locationServiceEnabled;
@property (nonatomic, assign) double currentLatitude;
@property (nonatomic, assign) double currentLongitude;

+ (id)sharedManager;
- (UIViewController*)loadViewControllerFromStoryboard:(NSString*)boardName ViewControllerIdentifier:(NSString*)viewControllerIdentifier;

#pragma mark - Validators

+ (BOOL)isEmailValid:(NSString *)email;
+ (BOOL)isPasswordValid:(NSString*)password;
+ (NSDate*)getDateTimeFrom:(NSString*)strDateTime;
+ (NSString*)getTimeFrom:(NSString*)strDateTime;
+ (NSString*)getFormattedPostMomentFrom:(NSString*)strMoment;
+ (NSString*)getFormattedNumber:(int)num;
+ (UIImage *)generateThumbImageOf:(NSString *)filepath At:(float)timeAt;
+ (NSArray*)generateThumbnailsOf:(NSString*)filepath AtTimes:(NSArray*)timetable;

#pragma mark - Methods


@end

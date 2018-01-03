//
//  WeatherModel.h
//  Kaliido
//
//  Hiba on 1/9/17.
//  Copyright © 2017 Kaliido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherModel : NSObject
    
    @property (nonatomic, assign) NSInteger weatherId;
    @property (nonatomic, strong) NSString *greatingMessage;
    @property (nonatomic, strong) NSString *cityName;
    @property (nonatomic, strong) NSString *temperature;
    @property (nonatomic, strong) NSString *weathericon;
    
@end

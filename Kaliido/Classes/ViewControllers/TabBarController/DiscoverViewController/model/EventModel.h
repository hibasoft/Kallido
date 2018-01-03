//
//  EventModel.h
//  Kaliido
//
//  Hiba on 1/9/17.
//  Copyright © 2017 Kaliido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventModel : NSObject
    @property (nonatomic, assign) NSInteger eventId;
    @property (nonatomic, strong) NSString *imgUrl;
    @property (nonatomic, strong) NSString *eventName;
    @property (nonatomic, strong) NSString *eventDate;
    

@end

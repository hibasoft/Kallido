//
//  NotificationModel.h
//  Kaliido
//
//  Hiba on 1/9/17.
//  Copyright © 2017 Kaliido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationModel : NSObject
    @property (nonatomic, assign) NSInteger notificationId;
    @property (nonatomic, strong) NSString *firstMessage;
    @property (nonatomic, strong) NSString *secondMessage;
    
@end

//
//  NotificationTag.h
//  Kaliido
//
//  Created by Admin on 7/1/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KLBaseModel.h"

@interface NotificationTag : KLBaseModel

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *value;

- (NSDictionary *) toDictionary;

@end

//
//  NotificationTag.m
//  Kaliido
//
//  Created by Admin on 7/1/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "NotificationTag.h"

@implementation NotificationTag

- (NSDictionary *) toDictionary
{
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [[super class] addItemToDictionary:dict key:@"Value" value:self.value default:@""];
    [[super class] addItemToDictionary:dict key:@"Name" value:self.name default:@""];
    return dict;
}

@end

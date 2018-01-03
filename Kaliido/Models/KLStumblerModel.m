//
//  KLStumblerModel.m
//  Kaliido
//
//  Created by  Kaliido on 9/24/15.
//  Copyright © 2015 Kaliido. All rights reserved.
//

#import "KLStumblerModel.h"

@implementation KLStumblerModel
+ (id) objectWithDictionary:(NSDictionary *)dic
{
    if (dic == nil || dic == (NSDictionary*)[NSNull null])
        return nil;
    
    KLStumblerModel *stumbler = [[KLStumblerModel alloc] init];
    
    stumbler.stumblerId = [[super itemFromDictionary:dic key:@"id" default:@""] integerValue];
    stumbler.name = [super itemFromDictionary:dic key:@"name" default:@""];
    stumbler.date = [super itemFromDictionary:dic key:@"date" default:@""];
    stumbler.imageUID = [super itemFromDictionary:dic key:@"imageUID" default:nil];
    stumbler.invitedCount = [[super itemFromDictionary:dic key:@"invitedCount" default:@""] integerValue];
    stumbler.post = [super itemFromDictionary:dic key:@"post" default:@""];
    stumbler.privacy = [super itemFromDictionary:dic key:@"privacy" default:@""];
    stumbler.address = [super itemFromDictionary:dic key:@"address" default:@""];
    stumbler.latitude = [super itemFromDictionary:dic key:@"latitude" default:nil];
    stumbler.longitude = [super itemFromDictionary:dic key:@"longitude" default:nil];
    stumbler.ownerFullname = [super itemFromDictionary:dic key:@"ownerFullname" default:@""];
    stumbler.ownerUserPhotoUid = [super itemFromDictionary:dic key:@"ownerUserPhotoUid" default:@""];
    stumbler.goingCount = [[super itemFromDictionary:dic key:@"invitedCount" default:@""] integerValue];
    stumbler.maybeCount = [[super itemFromDictionary:dic key:@"maybeCount" default:@""] integerValue];
    stumbler.attendees = [super itemFromDictionary:dic key:@"attendees" default:nil];
    stumbler.subcategoryids = [super itemFromDictionary:dic key:@"subcategoryids" default:nil];
    return stumbler;
}

- (NSDictionary *) toDictionary
{
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [[super class] addItemToDictionary:dict key:@"Id" value:[NSNumber numberWithInt:self.stumblerId] default:@""];
    [[super class] addItemToDictionary:dict key:@"stumblername" value:self.name default:@""];
    [[super class] addItemToDictionary:dict key:@"date" value:self.date default:@""];
    [[super class] addItemToDictionary:dict key:@"imageUID" value:self.imageUID default:@""];
    [[super class] addItemToDictionary:dict key:@"invitedCount" value:[NSNumber numberWithInt:self.invitedCount] default:@""];
    [[super class] addItemToDictionary:dict key:@"post" value:self.post default:@""];
    [[super class] addItemToDictionary:dict key:@"privacy" value:self.privacy default:@""];
    [[super class] addItemToDictionary:dict key:@"address" value:self.address default:@""];
    [[super class] addItemToDictionary:dict key:@"latitude" value:self.latitude default:@""];
    [[super class] addItemToDictionary:dict key:@"longitude" value:self.longitude default:@""];
    [[super class] addItemToDictionary:dict key:@"createDate" value:self.createDate default:@""];
    [[super class] addItemToDictionary:dict key:@"userownerid" value:[NSNumber numberWithInt:self.userOwnerId] default:@""];
    [[super class] addItemToDictionary:dict key:@"ownerfullname" value:self.ownerFullname default:@""];
    [[super class] addItemToDictionary:dict key:@"owneruserphotouid" value:self.ownerUserPhotoUid default:@""];
    [[super class] addItemToDictionary:dict key:@"goingcount" value:[NSNumber numberWithInt:self.goingCount] default:@""];
    [[super class] addItemToDictionary:dict key:@"maybecount" value:[NSNumber numberWithInt:self.maybeCount] default:@""];
    [[super class] addItemToDictionary:dict key:@"attendees" value:self.attendees default:[NSNull null]];
    [[super class] addItemToDictionary:dict key:@"subcategoryids" value:self.subcategoryids default:[NSNull null]];
    return dict;
}

- (NSDictionary *) postDictionary
{
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [[super class] addItemToDictionary:dict key:@"stumblername" value:self.name default:@""];
    [[super class] addItemToDictionary:dict key:@"date" value:self.date default:@""];
    [[super class] addItemToDictionary:dict key:@"imageUID" value:self.imageUID default:@""];
    [[super class] addItemToDictionary:dict key:@"post" value:self.post default:@""];
    [[super class] addItemToDictionary:dict key:@"privacy" value:self.privacy default:@""];
    [[super class] addItemToDictionary:dict key:@"address" value:self.address default:@""];
    [[super class] addItemToDictionary:dict key:@"latitude" value:self.latitude default:@""];
    [[super class] addItemToDictionary:dict key:@"longitude" value:self.longitude default:@""];
    [[super class] addItemToDictionary:dict key:@"attendeeids" value:self.attendees default:[NSNull null]];
    [[super class] addItemToDictionary:dict key:@"subcategoryids" value:self.subcategoryids default:[NSNull null]];
    return dict;
}
@end

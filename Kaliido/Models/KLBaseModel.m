//
//  KLBaseModel.m
//  Kaliido
//
//  Created by  Kaliido on 9/24/15.
//  Copyright © 2015 Kaliido. All rights reserved.
//

#import "KLBaseModel.h"

@implementation KLBaseModel

- (id)copyWithZone:(NSZone *)zone
{
    return [[[self class] allocWithZone:zone] init];
}

+ (id) objectWithDictionary:(NSDictionary *)dictionary
{
    return nil;
}

- (NSDictionary *) toDictionary
{
    return nil;
}

+ (id) itemFromDictionary:(NSDictionary*) dict
                      key:(id) memberKey
                  default:(id) defaultValue
{
    @try {
        id value = [dict objectForKey:memberKey];
        
        if (value == nil || value == [NSNull null])
            return defaultValue;
        else
            return value;
    }
    @catch (NSException* e) {
        NSLog(@"%@", e.description);
        return defaultValue;
    }
}

+ (NSArray *) arrayItemFromDictionary:(NSDictionary *) dict
                                  key:(id) memberKey
                                class:(Class) elemClass
{
    @try {
        NSArray * dictArr = [dict objectForKey:memberKey];
        
        if (dictArr == nil || dictArr == (NSArray *)[NSNull null])
            return nil;
        
        NSMutableArray * arr = [[NSMutableArray alloc] init];
        
        for (NSDictionary * dict in dictArr) {
            [arr addObject:[elemClass objectWithDictionary:dict]];
        }
        
        return arr;
    }
    @catch (NSException* e) {
        NSLog(@"%@", e.description);
        return nil;
    }
}

+ (NSDictionary *) addItemToDictionary:(NSDictionary*) dict
                                   key:(id) memberKey
                                 value:(id) value
                               default:(id) defaultValue
{
    @try {
        if (value == nil || value == [NSNull null])
            [(NSMutableDictionary *)dict setObject:defaultValue forKey:memberKey];
        else
            [(NSMutableDictionary *)dict setObject:value forKey:memberKey];
    }
    @catch (NSException* e) {
        NSLog(@"%@", e.description);
    }
    
    return dict;
}

+ (id) objectToDictionary:(id)objectInfo
{
    NSDictionary *retDic = [[NSDictionary alloc]init];
    
    return retDic;
}

@end

@implementation NSArray (Copy)

- (id)deepCopyArray
{
    
    NSMutableArray * result = [[NSMutableArray alloc] init];
    
    for (id object in self) {
        if ([[object class] isSubclassOfClass:[NSArray class]]) {
            [result addObject:[object deepCopyArray]];
        }
        else if ([[object class] isSubclassOfClass:[NSDictionary class]]){
            [result addObject:[object deepCopyDictionary]];
        }
        else{
            [result addObject:[object copy]];
        }
        
    }
    return result;
}

@end

@implementation NSDictionary (Copy)

- (id)deepCopyDictionary
{
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    
    id keys = [self allKeys];
    
    for (id key in keys) {
        id object = [self objectForKey:key];
        
        if ([[object class] isSubclassOfClass:[NSArray class]]) {
            [result setObject:[object deepCopyArray] forKey:key];
            
        }
        else if ([[object class] isSubclassOfClass:[NSDictionary class]]){
            [result setObject:[object deepCopyDictionary] forKey:key];
        }
        else{
            [result setObject:[object copy] forKey:key];
        }
    }
    return result;
}

@end

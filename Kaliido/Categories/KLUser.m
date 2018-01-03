//
//  KLUser+CustomParameters.m
//  Kaliido
//
//  Created by Daron 29.09.14.
//  Copyright (c) 2014 Kaliido. All rights reserved.
//

#import "KLUser.h"
#import <objc/runtime.h>


@implementation KLUser 


#pragma mark - Setters & getters



static KLUser* currentUser;

+ (KLUser*)currentUser
{
    return currentUser;
}

+ (void)setCurrentUser:(KLUser*)user
{
    currentUser = user;
}
- (NSString*)headline
{
    NSString *headLine = [self stringForKey:@"headLine"];
    if (headLine == nil ||[headLine isEqual:[NSNull null]])
        headLine = @"";
    return headLine;
}

- (NSString*)aboutMe
{
    NSString *aboutMe = [self stringForKey:@"aboutMe"];
    if (aboutMe == nil ||[aboutMe isEqual:[NSNull null]])
        aboutMe = @"";
    return aboutMe;
}

- (NSString*)photoUID
{
    NSString *photoUID = [self stringForKey:@"photoUID"];
    if (photoUID == nil ||[photoUID isEqual:[NSNull null]])
        photoUID = nil;
    return photoUID;
}

- (NSInteger)age
{
    return [[self stringForKey:@"age"] integerValue];
}

- (BOOL)isAgeShowen
{
    return [[self stringForKey:@"isAgeShowen"] boolValue];
}

- (NSString*)birthDate
{
    NSString *birthDate = [self stringForKey:@"birthDate"];
    if (birthDate == nil ||[birthDate isEqual:[NSNull null]])
        birthDate = @"";
    return birthDate;
}

-(void)setInterestsDic:(NSDictionary*)dic
{
    [self setString:[dic valueForKey:@"interests"] forKey:@"interests"];
}

-(void)setLookingForsDic:(NSDictionary*)dic
{
    [self setString:[dic valueForKey:@"lookingFors"] forKey:@"lookingFors"];
}

-(void)setRelationShipDic:(NSDictionary*)dic
{
    [self setString:[dic valueForKey:@"relationship"] forKey:@"relationship"];
}

-(void) setUser:(NSDictionary*)dic
{
    NSArray *keys = [dic allKeys];
    for(NSString *key in keys)
    {
        [self setString:[dic valueForKey:key] forKey:key];
    }
}

-(NSDictionary*) getUserDic
{
    NSMutableDictionary *jsonDict = [self dictionaryFromString:self.customData];
    
    return jsonDict;
}

#pragma mark - Serialization

- (void)setString:(NSString *)string forKey:(NSString *)key
{
    NSMutableDictionary *jsonDict = [self dictionaryFromString:self.customData];
    // returned dictionary - existed or new:
    if (string) {
        jsonDict[key] = string;
    } else {
        [jsonDict removeObjectForKey:key];
    }
    NSString *jsonString = [self stringFromDictionary:jsonDict];
    self.customData = jsonString;
}

- (NSString *)stringForKey:(NSString *)key
{
    NSString *string = nil;
    NSMutableDictionary *jsonDict = [self dictionaryFromString:self.customData];
    if (jsonDict != nil) {
        string = jsonDict[key];
    }
    return string;
}

#pragma mark -

- (NSString *)stringFromDictionary:(NSMutableDictionary *)dict
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (NSMutableDictionary *)dictionaryFromString:(NSString *)string
{
    NSMutableDictionary *customParams = nil;
    NSError *error = nil;
    
    NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
    if (jsonData == nil) {
        return [[NSMutableDictionary alloc] init];
    }
    customParams = [[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error] mutableCopy];
    if (customParams == nil) {
        customParams = [[NSMutableDictionary alloc] init];
    }
    return customParams;
}

@end

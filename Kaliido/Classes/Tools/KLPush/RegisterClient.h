//
//  RegisterClient.h
//  Kaliido
//
//  Hiba on 6/25/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegisterClient : NSObject
@property (strong, nonatomic) NSString* authenticationHeader;

-(void) registerWithDeviceToken:(NSData*)token tags:(NSSet*)tags
                  andCompletion:(void(^)(NSError*))completion;

-(void) unsubscribeFromPushNotifications:(NSData*)token userId:(int)userId andCompletion:(void(^)(NSURLResponse*, NSError*))completion;


-(instancetype) initWithEndpoint:(NSString*)Endpoint;

@end

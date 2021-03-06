//
//  NSObject+KLApi_Permissions.m
//  Kaliido
//
//  Created by Anton Sokolchenko on 3/19/15.
//  Copyright (c) 2015 Kaliido. All rights reserved.
//

#import "KLApi.h"
#import <AVFoundation/AVAudioSession.h>
#import <AVFoundation/AVFoundation.h>

@implementation KLApi (Permissions)

- (void)requestPermissionToMicrophoneWithCompletion:(void(^)(BOOL granted))completion {
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        if( completion ) {
            completion(granted);
        }
    }];
}

- (void)requestPermissionToCameraWithCompletion:(void(^)(BOOL authorized))completion {
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusAuthorized) {
        if( completion ){
            completion(YES);
        }
    } else if(authStatus == AVAuthorizationStatusDenied){
        if( completion ){
            completion(NO);
        }
    } else if(authStatus == AVAuthorizationStatusRestricted){
        if( completion ){
            completion(NO);
        }
    } else if(authStatus == AVAuthorizationStatusNotDetermined){
        // not determined?!
        [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
                if( completion ){
                    completion(granted);
                }
            
        }];
    } else {
        if( completion ){
            completion(NO);
        }
    }
}

@end

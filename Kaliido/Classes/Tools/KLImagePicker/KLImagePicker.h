//
//  KLImagePicker.h
//  Kaliido
//
//  Created by Daron on 11.08.14.
//  Copyright (c) 2014 Kaliido. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^KLImagePickerResult)(UIImage *image);
typedef void(^KLImagePickerVideoResult)(NSURL *videoURL);

@interface KLImagePicker : UIImagePickerController

+ (void)presentIn:(UIViewController *)vc
        configure:(void (^)(UIImagePickerController *picker))configure
           result:(KLImagePickerResult)result;

+ (void)chooseSourceTypeInVC:(id)vc allowsEditing:(BOOL)allowsEditing result:(KLImagePickerResult)result;
+ (void)chooseVideoSourceTypeInVC:(id)vc allowsEditing:(BOOL)allowsEditing result:(KLImagePickerVideoResult)result;
@end

//
//  KLImagePicker.m
//  Kaliido
//
//  Created by Daron on 11.08.14.
//  Copyright (c) 2014 Kaliido. All rights reserved.
//

#import "KLImagePicker.h"
#import "REActionSheet.h"

@interface KLImagePicker()

<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (copy, nonatomic) KLImagePickerResult result;
@property (copy, nonatomic) KLImagePickerVideoResult resultURL;

@end

@implementation KLImagePicker

- (void)dealloc {
   NSLog(@"%@ - %@",  NSStringFromSelector(_cmd), self);
}

+ (void)presentIn:(UIViewController *)vc
        configure:(void (^)(UIImagePickerController *picker))configure
           result:(KLImagePickerResult)result {
    
    KLImagePicker *picker = [[KLImagePicker alloc] init];
    picker.result = result;
    configure(picker);
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [vc presentViewController:picker animated:YES completion:nil];
}

+ (void)presentVideoIn:(UIViewController *)vc
        configure:(void (^)(UIImagePickerController *picker))configure
           result:(KLImagePickerVideoResult)result {
    
    KLImagePicker *picker = [[KLImagePicker alloc] init];
    picker.resultURL = result;
    configure(picker);
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [vc presentViewController:picker animated:YES completion:nil];
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.delegate = self;
    }
    return self;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];

    if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        NSString *key = picker.allowsEditing ? UIImagePickerControllerEditedImage: UIImagePickerControllerOriginalImage;
        UIImage *image = info[key];
        
        [picker dismissViewControllerAnimated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            self.result(image);
            self.result = nil;
        }];
    }else if ([mediaType isEqualToString:@"public.movie"]){
    
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        
        [picker dismissViewControllerAnimated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            self.resultURL(videoURL);
            self.resultURL = nil;
        }];
        
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        self.result = nil;
    }];
}

+ (void)chooseSourceTypeInVC:(id)vc allowsEditing:(BOOL)allowsEditing result:(KLImagePickerResult)result {
    
    UIViewController *viewController = vc;
    
    void (^showImagePicker)(UIImagePickerControllerSourceType) = ^(UIImagePickerControllerSourceType type) {
        
        [KLImagePicker presentIn:viewController configure:^(UIImagePickerController *picker) {
            
            picker.sourceType = type;
            picker.allowsEditing = allowsEditing;
            
        } result:result];
    };
    
    
    [REActionSheet presentActionSheetInView:viewController.view configuration:^(REActionSheet *actionSheet) {
        
        [actionSheet addButtonWithTitle:NSLocalizedString(@"KL_STR_TAKE_NEW_PHOTO", nil)
                         andActionBlock:^{
                             showImagePicker(UIImagePickerControllerSourceTypeCamera);
                         }];
        
        [actionSheet addButtonWithTitle:NSLocalizedString(@"KL_STR_CHOOSE_FROM_LIBRARY", nil)
                         andActionBlock:^{
                             showImagePicker(UIImagePickerControllerSourceTypePhotoLibrary);
                         }];
        
        [actionSheet addCancelButtonWihtTitle:NSLocalizedString(@"KL_STR_CANCEL", nil)
                               andActionBlock:^{}];
    }];
}


+ (void)chooseVideoSourceTypeInVC:(id)vc allowsEditing:(BOOL)allowsEditing result:(KLImagePickerVideoResult) result {
    
    UIViewController *viewController = vc;
    
    void (^showImagePicker)(UIImagePickerControllerSourceType) = ^(UIImagePickerControllerSourceType type) {
        
        [KLImagePicker presentVideoIn:viewController configure:^(UIImagePickerController *picker) {
            
            picker.sourceType = type;
            picker.allowsEditing = allowsEditing;
            picker.mediaTypes = @[(NSString*)kUTTypeMovie, (NSString*)kUTTypeAVIMovie, (NSString*)kUTTypeVideo, (NSString*)kUTTypeMPEG4];

            
        } result:result];
    };
    
    
    [REActionSheet presentActionSheetInView:viewController.view configuration:^(REActionSheet *actionSheet) {
        
        [actionSheet addButtonWithTitle:NSLocalizedString(@"KL_STR_TAKE_NEW_VIDEO", nil)
                         andActionBlock:^{
                             showImagePicker(UIImagePickerControllerSourceTypeCamera);
                         }];
        
        [actionSheet addButtonWithTitle:NSLocalizedString(@"KL_STR_CHOOSE_FROM_LIBRARY", nil)
                         andActionBlock:^{
                             showImagePicker(UIImagePickerControllerSourceTypePhotoLibrary);
                         }];
        
        [actionSheet addCancelButtonWihtTitle:NSLocalizedString(@"KL_STR_CANCEL", nil)
                               andActionBlock:^{}];
    }];
}



@end

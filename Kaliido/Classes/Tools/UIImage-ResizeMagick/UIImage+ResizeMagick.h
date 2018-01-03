/*************************************************************************
 *
 * TMODS - TARGETED MARKETING ON DISPLAY SYSTEM
 * __________________
 *
 *  [2015] MEDIASUITE SOLUTIONS PTY LTD
 *  All Rights Reserved.
 *
 * NOTICE:  All information contained herein is, and remains
 * the property of MEDIASUITE SOLUTIONS PTY LTD and its suppliers,
 * if any.  The intellectual and technical concepts contained
 * herein are proprietary to MEDIASUITE SOLUTIONS PTY LTD
 * and its suppliers and may be covered by AUSTRALIAN & FOREIGN copyright law.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from MEDIASUITE SOLUTIONS PTY LTD.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface UIImage (ResizeMagick)

- (UIImage *) resizedImageByMagick: (NSString *) spec;
- (UIImage *) resizedImageByWidth:  (NSUInteger) width;
- (UIImage *) resizedImageByHeight: (NSUInteger) height;
- (UIImage *) resizedImageWithMaximumSize: (CGSize) size;
- (UIImage *) resizedImageWithMinimumSize: (CGSize) size;
- (UIImage*) croppedImageWithRect: (CGSize) newSize ;
@end

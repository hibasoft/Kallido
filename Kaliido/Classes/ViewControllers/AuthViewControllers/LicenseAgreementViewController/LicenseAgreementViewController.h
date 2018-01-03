//
//  KLLicenseAgreementViewController.h
//  Kaliido
//
//  Created by Daron10/07/2014.
//  Copyright (c) 2014 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^LicenceCompletionBlock)(BOOL accepted);

@interface LicenseAgreementViewController : UIViewController

@property (copy, nonatomic) LicenceCompletionBlock licenceCompletionBlock;

@end

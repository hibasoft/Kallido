//
//  StumblerCategoryViewController.h
//  Kaliido
//
//  Created by  Kaliido on 12/29/15.
//  Copyright © 2015 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StumblerCreateViewController.h"

@interface StumblerCategoryViewController : UIViewController < UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) StumblerCreateViewController *parent;
@end
//
//  ActivityPeopleTableViewCell.h
//  Kaliido
//
//  Hiba on 1/9/17.
//  Copyright © 2017 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityPeopleTableViewCell : UITableViewCell<UICollectionViewDataSource, UICollectionViewDelegate>
    @property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

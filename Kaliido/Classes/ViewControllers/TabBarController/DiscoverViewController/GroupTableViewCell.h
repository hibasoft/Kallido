//
//  GroupTableViewCell.h
//  Kaliido
//
//  Hiba on 1/8/17.
//  Copyright © 2017 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupModel.h"

@interface GroupTableViewCell : UITableViewCell<UICollectionViewDelegate, UICollectionViewDataSource>
{
    NSMutableArray* mGroupArray;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
-(void) setGroupData : (NSMutableArray*) groupArray;
@end

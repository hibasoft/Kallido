//
//  EventTableViewCell.h
//  Kaliido
//
//  Learco on 1/8/17.
//  Copyright © 2017 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventTableViewCell : UITableViewCell<UICollectionViewDelegate, UICollectionViewDataSource>
{
    NSMutableArray* mEventArray;
}

    @property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
-(void) setEventData : (NSMutableArray*) eventArray;
@end

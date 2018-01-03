//
//  WeatherTableViewCell.h
//  Kaliido
//
//  Learco on 1/8/17.
//  Copyright © 2017 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherTableViewCell : UITableViewCell
{
        
}

    @property (weak, nonatomic) IBOutlet UILabel *greatingLabel;
    @property (weak, nonatomic) IBOutlet UILabel *cityLabel;
    @property (weak, nonatomic) IBOutlet UIImageView *weatherImageView;
    @property (weak, nonatomic) IBOutlet UILabel *tempratureLabel;

@end


#import <UIKit/UIKit.h>
#import "SlideMenuCell.h"
#import "KLImageView.h"


typedef enum {
    KLMenuMain, // Default
    KLMenuMe,
} KLMenuMode;

@interface MEMenuViewController : UIViewController <UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *lblNotification;
@property (weak, nonatomic) IBOutlet KLImageView *imgProfile;
@property (weak, nonatomic) IBOutlet UILabel *lblProfileName;
@property (weak, nonatomic) IBOutlet UILabel *lblEmailAddress;

@property (readwrite) KLMenuMode nMenuMode;
@end

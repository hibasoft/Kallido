#import <Foundation/Foundation.h>
#import "ECSlidingViewController.h"

@interface MEZoomAnimationController : NSObject <UIViewControllerAnimatedTransitioning,
                                                 ECSlidingViewControllerDelegate,
                                                 ECSlidingViewControllerLayout>
@end

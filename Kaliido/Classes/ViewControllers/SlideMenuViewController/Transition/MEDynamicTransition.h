#import <Foundation/Foundation.h>
#import "ECSlidingViewController.h"
#import "ECPercentDrivenInteractiveTransition.h"

@interface MEDynamicTransition : NSObject <UIViewControllerInteractiveTransitioning,
                                           UIDynamicAnimatorDelegate,
                                           ECSlidingViewControllerDelegate>
@property (nonatomic, assign) ECSlidingViewController *slidingViewController;
- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer;
@end

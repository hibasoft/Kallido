#import <Foundation/Foundation.h>
#import "ECSlidingViewController.h"
#import "MEFoldAnimationController.h"
#import "MEZoomAnimationController.h"
#import "MEDynamicTransition.h"

FOUNDATION_EXPORT NSString *const METransitionNameDefault;
FOUNDATION_EXPORT NSString *const METransitionNameFold;
FOUNDATION_EXPORT NSString *const METransitionNameZoom;
FOUNDATION_EXPORT NSString *const METransitionNameDynamic;

@interface METransitions : NSObject {
    NSArray *_all;
}
@property (nonatomic, strong) MEFoldAnimationController *foldAnimationController;
@property (nonatomic, strong) MEZoomAnimationController *zoomAnimationController;
@property (nonatomic, strong) MEDynamicTransition *dynamicTransition;
@property (nonatomic, strong, readonly) NSArray *all;
@end

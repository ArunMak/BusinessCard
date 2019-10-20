

#import "seagueAnimation.h"

@implementation seagueAnimation

-(void)perform{
    UIViewController *sourceViewController = (UIViewController *) [self sourceViewController];
    UIViewController *destinationViewController = (UIViewController *) [self destinationViewController];
    CATransition* transition = [CATransition animation];
    if ([self.identifier isEqualToString:@"b"]){
        transition.duration = .25;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionMoveIn; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
        transition.subtype = kCATransitionFromLeft; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    }else{
        transition.duration = .25;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionMoveIn;
        transition.subtype = kCATransitionFromRight;
    }
    [sourceViewController.navigationController.view.layer addAnimation:transition
                                                            forKey:kCATransition];
    [sourceViewController.navigationController pushViewController:destinationViewController animated:NO];
}

@end

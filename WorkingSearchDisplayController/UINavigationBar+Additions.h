//
//  UINavigationBar+Additions.h
//  WorkingSearchDisplayController
//

@import UIKit;


@interface UINavigationBar (Additions)

- (void)animateSearchBarFrameAlongWithAnimations:(void (^)(void))animations;
- (void)animateSearchBarTextFieldIconAndLabelToTheLeft;

@end


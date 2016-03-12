//
//  UINavigationBar+Additions.m
//  WorkingSearchDisplayController
//

#import "UINavigationBar+Additions.h"

@implementation UINavigationBar (Additions)

- (void)animateSearchBarFrameAlongWithAnimations:(void (^)(void))animations
{
	if (!animations) {
		return;
	}
	UIView *searchBarTextField = [self findSearchBarTextFieldInViewHierarchy:self];
	if (!searchBarTextField) {
		animations();
		return;
	}

	// Save frame and perform animations.
	CGRect oldSearchBarFrame = searchBarTextField.frame;
	animations();
	CGRect newSearchBarFrame = searchBarTextField.frame;

	// Remove all animations for the search bar text field and its subviews.
	[self removeAllAnimationsForViewHierarchy:searchBarTextField];

	// Redo the text field frame animation.
	[UIView performWithoutAnimation:^{
		searchBarTextField.frame = oldSearchBarFrame;
	}];
	[UIView animateWithDuration:0.25 animations:^{
		searchBarTextField.frame = newSearchBarFrame;
	}];
}

- (void)animateSearchBarTextFieldIconAndLabelToTheLeft
{
	UIView *searchBarTextField = [self findSearchBarTextFieldInViewHierarchy:self];
	UIView *searchIcon = [self findSearchBarTextFieldSearchIconInViewHierarchy:searchBarTextField];
	UIView *searchLabel = [self findSearchBarTextFieldSearchLabelInViewHierarchy:searchBarTextField];

	// These walues work for iOS 8 and 9 but they might change in future iOS releases.
	CGRect newIconFrame = searchIcon.frame;
	newIconFrame.origin.x = 8.0;
	CGRect newLabelFrame = searchLabel.frame;
	newLabelFrame.origin.x = 29.0;

	[UIView animateWithDuration:0.25 animations:^{
		searchIcon.frame = newIconFrame;
		searchLabel.frame = newLabelFrame;
	}];
}

// Finds the UISearchBarTextField inside the UINavigationBar.
- (UIView *)findSearchBarTextFieldInViewHierarchy:(UIView *)view {
	return [self findFirstSubviewOfClass:[UITextField class] inViewHierarchy:view validateWith:nil];
}

// Finds the UISearchBarTextFieldLabel inside UISearchBarTextField.
- (UIView *)findSearchBarTextFieldSearchLabelInViewHierarchy:(UIView *)view {
	return [self findFirstSubviewOfClass:[UILabel class] inViewHierarchy:view validateWith:nil];
}

// Finds the UIImageView icon inside UISearchBarTextField (but not the _UISearchBarSearchFieldBackgroundView which comes first).
- (UIView *)findSearchBarTextFieldSearchIconInViewHierarchy:(UIView *)view
{
	return [self findFirstSubviewOfClass:[UIImageView class] inViewHierarchy:view validateWith:^BOOL (UIView *subview) {
		CGRect frame = subview.frame;
		return (frame.size.width == frame.size.height);
	}];
}

- (UIView *)findFirstSubviewOfClass:(Class)class inViewHierarchy:(UIView *)view validateWith:(BOOL (^)(UIView *subview))block
{
	NSArray *subviews = view.subviews;
	if (!subviews || subviews.count == 0) {
		return nil;
	}
	for (UIView *subview in subviews) {
		if ([subview isKindOfClass:class]) {
			if (!block || block(subview)) {
				return subview;
			}
		}
	}
	for (UIView *subview in subviews) {
		UIView *result = [self findFirstSubviewOfClass:class inViewHierarchy:subview validateWith:block];
		if (result != nil) {
			return result;
		}
	}
	return nil;
}

- (void)removeAllAnimationsForViewHierarchy:(UIView *)view
{
	[view.layer removeAllAnimations];
	NSArray *subviews = view.subviews;
	if (subviews && subviews.count > 0) {
		for (UIView *subview in subviews) {
			[self removeAllAnimationsForViewHierarchy:subview];
		}
	}
}

@end


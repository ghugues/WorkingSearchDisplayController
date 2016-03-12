//
//  SearchDisplayViewController.m
//  WorkingSearchDisplayController
//

#import "SearchDisplayViewController.h"
#import "UINavigationBar+Additions.h"

@interface SearchDisplayViewController () <UISearchDisplayDelegate, UISearchBarDelegate>
@property (nonatomic, strong) UISearchDisplayController *searchController;
@property (nonatomic, strong) UIBarButtonItem *leftBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *rightBarButtonItem;
@property (nonatomic) BOOL textFieldWasFirstResponderOnViewWillDisappear;
@end


@implementation SearchDisplayViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	self.view.backgroundColor = [UIColor lightGrayColor];
	self.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(navigationLeftBarButtonItemAction)];
	self.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(navigationRightBarButtonItemAction)];
//	self.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 29.0, 0.0)]];

	// Required if the navigation bar is opaque (not translucent). Optional otherwise.
	self.extendedLayoutIncludesOpaqueBars = YES;

	UISearchBar *searchBar = [[UISearchBar alloc] init];
	searchBar.delegate = self;
	[searchBar sizeToFit];

	self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
	self.searchController.displaysSearchBarInNavigationBar = YES;
	self.searchController.navigationItem.leftBarButtonItem = self.leftBarButtonItem;
	self.searchController.navigationItem.rightBarButtonItem = self.rightBarButtonItem;
	self.searchController.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];

	// Keybord dismissal animation is broken in iOS 8.0 and later. Resigning the first responder here fixes the animation.
	// We remember the value of `isFirstResponder` in `textFieldWasFirstResponderOnViewWillDisappear` and make the textField
	// first responder again in `viewWillAppear:` or `viewDidAppear:` if necessary.
	if ([[UIDevice currentDevice].systemVersion compare:@"8.0" options:NSNumericSearch] != NSOrderedAscending) {
		UIView *searchBarTextField = self.searchController.navigationItem.titleView;
		self.textFieldWasFirstResponderOnViewWillDisappear = [searchBarTextField isFirstResponder];
		if (self.textFieldWasFirstResponderOnViewWillDisappear) {
			[searchBarTextField resignFirstResponder];
		}
	}
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	// See `viewWillDisappear:` for why this is necessary.
	// Showing the keyboard here makes a great animation in iOS 8, but it's broken in iOS 9 so we do it in `viewDidAppear:`
	if ([[UIDevice currentDevice].systemVersion compare:@"8.0" options:NSNumericSearch] != NSOrderedAscending &&
		[[UIDevice currentDevice].systemVersion compare:@"9.0" options:NSNumericSearch] == NSOrderedAscending) {
		if (self.textFieldWasFirstResponderOnViewWillDisappear) {
			[self.searchController.navigationItem.titleView becomeFirstResponder];
		}
	}
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

	// See `viewWillAppear:` for why this is necessary.
	if ([[UIDevice currentDevice].systemVersion compare:@"9.0" options:NSNumericSearch] != NSOrderedAscending) {
		if (self.textFieldWasFirstResponderOnViewWillDisappear) {
			[self.searchController.navigationItem.titleView becomeFirstResponder];
		}
	}
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
	// This is needed for some reason... Has no effect if the controller is already active.
	[self.searchController setActive:YES animated:YES];
	return YES;
}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
	// Animate the search bar frame properly.
	[self.navigationController.navigationBar animateSearchBarFrameAlongWithAnimations:^{
	//	[self.searchController.navigationItem setLeftBarButtonItem:nil animated:true];
		[self.searchController.navigationItem setRightBarButtonItem:nil animated:true];
		[self.searchController.searchBar setShowsCancelButton:YES animated:YES];
	}];
	// Animate the search icon and label to the left (needed only for iOS 8.0 and later).
	if ([[UIDevice currentDevice].systemVersion compare:@"8.0" options:NSNumericSearch] != NSOrderedAscending) {
		[self.navigationController.navigationBar animateSearchBarTextFieldIconAndLabelToTheLeft];
	}
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
	// Animate the search bar frame properly.
	[self.navigationController.navigationBar animateSearchBarFrameAlongWithAnimations:^{
		[self.searchController.searchBar setShowsCancelButton:NO animated:YES];
		[self.searchController.navigationItem setRightBarButtonItem:self.rightBarButtonItem animated:true];
	//	[self.searchController.navigationItem setLeftBarButtonItem:self.leftBarButtonItem animated:true];
	}];
}

- (void)navigationLeftBarButtonItemAction {
	UIViewController *viewController = [[UIViewController alloc] init];
	viewController.view.backgroundColor = [UIColor whiteColor];
	[self.navigationController pushViewController:viewController animated:YES];
}

- (void)navigationRightBarButtonItemAction {
	CALayer *windowLayer = [UIApplication sharedApplication].keyWindow.layer;
	windowLayer.speed = (windowLayer.speed == 1.0) ? 0.1 : 1.0;
}

@end


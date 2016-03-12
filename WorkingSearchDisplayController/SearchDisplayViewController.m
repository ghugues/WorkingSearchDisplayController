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
@end


@implementation SearchDisplayViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	self.view.backgroundColor = [UIColor lightGrayColor];
	self.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(navigationLeftBarButtonItemAction)];
	self.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(navigationRightBarButtonItemAction)];
//	self.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 29.0, 0.0)]];

	// Needed only if the navigation bar is opaque (not translucent)
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

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
	// Animate search bar frame properly
	[self.navigationController.navigationBar animateSearchBarFrameAlongWithAnimations:^{
		[self.searchController.navigationItem setLeftBarButtonItem:nil animated:true];
		[self.searchController.navigationItem setRightBarButtonItem:nil animated:true];
		[self.searchController.searchBar setShowsCancelButton:YES animated:YES];
	}];
	// Animate icon and label to the left (needed only for iOS 8.0 and later)
	if ([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] != NSOrderedAscending) {
		[self.navigationController.navigationBar animateSearchBarTextFieldIconAndLabelToTheLeft];
	}
	[self.searchController setActive:YES animated:YES];
	return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
	// Animate search bar frame properly
	[self.navigationController.navigationBar animateSearchBarFrameAlongWithAnimations:^{
		[self.searchController.searchBar setShowsCancelButton:NO animated:YES];
		[self.searchController.navigationItem setRightBarButtonItem:self.rightBarButtonItem animated:true];
		[self.searchController.navigationItem setLeftBarButtonItem:self.leftBarButtonItem animated:true];
	}];
	[self.searchController setActive:NO animated:YES];
	return YES;
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


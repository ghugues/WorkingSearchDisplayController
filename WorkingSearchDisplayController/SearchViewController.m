//
//  SearchViewController.m
//  WorkingSearchDisplayController
//

#import "SearchViewController.h"

@interface SearchViewController () <UISearchControllerDelegate, UISearchResultsUpdating>
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) UIBarButtonItem *leftBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *rightBarButtonItem;
@end


@implementation SearchViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	self.view.backgroundColor = [UIColor lightGrayColor];
	self.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(navigationLeftBarButtonItemAction)];
	self.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(navigationRightBarButtonItemAction)];

	UITableViewController *searchResultsController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
	self.searchController = [[UISearchController alloc] initWithSearchResultsController:searchResultsController];
	self.searchController.delegate = self;
	self.searchController.searchResultsUpdater = self;
	self.searchController.hidesNavigationBarDuringPresentation = NO;

	self.navigationItem.titleView = self.searchController.searchBar;
	self.navigationItem.leftBarButtonItem = self.leftBarButtonItem;
	self.navigationItem.rightBarButtonItem = self.rightBarButtonItem;

	self.definesPresentationContext = YES;
}

- (void)willPresentSearchController:(UISearchController *)searchController
{
	[self.navigationItem setLeftBarButtonItem:nil animated:true];
	[self.navigationItem setRightBarButtonItem:nil animated:true];
}

- (void)willDismissSearchController:(UISearchController *)searchController
{
	[self.navigationItem setRightBarButtonItem:self.rightBarButtonItem animated:true];
	[self.navigationItem setLeftBarButtonItem:self.leftBarButtonItem animated:true];
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

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
}

@end


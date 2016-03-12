//
//  AppDelegate.m
//  WorkingSearchDisplayController
//

#import "AppDelegate.h"
#import "SearchViewController.h"
#import "SearchDisplayViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// Fix the status bar disapearing in landscape mode in iOS 8 and later.
	// The UIViewControllerBasedStatusBarAppearance Info.plist key must also be set to NO.
	[application setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
	[application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];

//	SearchViewController *searchController = [[SearchViewController alloc] init];
	SearchDisplayViewController *searchController = [[SearchDisplayViewController alloc] init];

	self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:searchController];
	[self.window makeKeyAndVisible];

	return YES;
}

@end


//
//  AppDelegate.m
//  shopping
//
//  Created by LiZujian on 13-8-1.
//  Copyright (c) 2013年 LiZujian. All rights reserved.
//

#import "AppDelegate.h"
#import "IIViewDeckController.h"
#import "ChoiceViewController.h"
#import "MainViewController.h"
#import "UIBarButtonItem+FlatUI.h"
#import "ImageCacheManager.h"
#import "AuthorizeManager.h"
@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
//    [[AuthorizeManager sharedInstance]authorize];
    [ImageCacheManager initCacheDirectory];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    IIViewDeckController* deckController = [[self generateControllerStack]autorelease];
    self.window.rootViewController = deckController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (IIViewDeckController*)generateControllerStack {
    ChoiceViewController* leftVC= [[[ChoiceViewController alloc] init]autorelease];
    
    MainViewController *centerVC = [[[MainViewController alloc] init]autorelease];
    UINavigationController * centerController = [[[UINavigationController alloc] initWithRootViewController:centerVC]autorelease];
    [centerController.navigationBar setBackgroundImage:[UIImage imageNamed:@"toolbar_bg"]   forBarMetrics:UIBarMetricsDefault & UIBarMetricsLandscapePhone];
    IIViewDeckController* deckController =  [[IIViewDeckController alloc] initWithCenterViewController:centerController
                                                                                    leftViewController:leftVC];
    deckController.leftSize = 100;
//    deckController.bounceDurationFactor = 0.1;
//    deckController.openSlideAnimationDuration = 0.1;
//    deckController.closeSlideAnimationDuration = 0.1;
    [deckController disablePanOverViewsOfClass:NSClassFromString(@"_UITableViewHeaderFooterContentView")];
    return deckController;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

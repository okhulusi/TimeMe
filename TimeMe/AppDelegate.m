//
//  AppDelegate.m
//  TimeMe
//
//  Created by Omar Khulusi on 9/20/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import "AppDelegate.h"
#import "TMViewController.h"
#import "TMAlertManager.h"
#import "TMStyleManager.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[TMAlertManager getInstance] reloadTimeValues];
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    TMViewController *viewController = [[TMViewController alloc] init];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self.window setRootViewController:navigationController];
    
    [self.window makeKeyAndVisible];
    
    TMStyleManager *styleManager = [TMStyleManager getInstance];
    [[UINavigationBar appearance] setBarTintColor:styleManager.navigationBarTintColor];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:
                                                           styleManager.navigationBarTitleColor,
                                                           NSFontAttributeName:
                                                           [styleManager.font fontWithSize:25] }];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[TMAlertManager getInstance] saveValues];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[TMAlertManager getInstance] reloadTimeValues];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    if ([application applicationState] == UIApplicationStateActive) {
        TMAlertManager *alertManager = [TMAlertManager getInstance];
        NSNumber *alert = [[notification userInfo] objectForKey:kTMAlertKey];
        [alertManager didFireAlert:alert];
    }
}

@end

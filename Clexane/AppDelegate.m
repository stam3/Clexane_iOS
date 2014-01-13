//
//  AppDelegate.m
//  Clexane
//
//  Created by David Sayag on 8/31/13.
//  Copyright (c) 2013 David Sayag. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "NudnikViewController.h"
#import "NSDate-Utilities.h"

#import <Parse/Parse.h>

@implementation AppDelegate {
    
    BOOL enteredFromLocalNotification;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [Parse setApplicationId:@"feNv8I2417EOVEKVNuQz2fYV4VUEMIhDMlSyMsqi"
                  clientKey:@"LnBI4k0D17NOBpzgZPIe9zMVEU2g4YsKhEyuUV65"];
    
    
    self.modelManager = [[ModelManager alloc] init];
   
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"bgEnterDate"];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    BOOL signedup = ([[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsProfileEmailID] != nil);
    if (!rails)
        signedup = YES;
    NSString* storyboardName = @"MainStoryboard";
    if (!signedup)
        storyboardName = @"SignupStoryboard";
    else
        [self.modelManager loginExistingUserWithDelegate:nil];
    
    UIStoryboard *settingsStoryboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    UIViewController *rootController = [settingsStoryboard instantiateInitialViewController];
    rootController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    self.window.rootViewController = rootController;
    
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    enteredFromLocalNotification = YES;
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
        
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"תזכורת" message:notification.alertBody delegate:self cancelButtonTitle:@"אוקיי" otherButtonTitles:nil];
        [alertView show];
        return;
    }

    NSLog(@"alertAction: %@", notification.alertAction);
    NSLog(@"notification: %@", notification);
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    
    NudnikViewController *controller = (NudnikViewController *)[storyboard instantiateViewControllerWithIdentifier:@"NudnikViewController"];
    UINavigationController* navController = (UINavigationController*)self.window.rootViewController;
    [navController dismissViewControllerAnimated:NO completion:nil];
    [navController popToRootViewControllerAnimated:NO];
    //MainViewController *viewController = [[navController viewControllers] objectAtIndex:0];
    //[viewController performSegueWithIdentifier:@"nudnik" sender:viewController];
    [navController pushViewController:controller animated:YES ];
    controller.localNotification = notification;
    
//    NudnikViewController *controller = [[NudnikViewController alloc] init];
//    UINavigationController* navController = (UINavigationController*)self.window.rootViewController;
//    [navController popToRootViewControllerAnimated:NO];
//    [navController pushViewController:controller animated:YES ];
//    controller.localNotification = notification;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"bgEnterDate"];
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
    if (enteredFromLocalNotification) {
        
        enteredFromLocalNotification = NO;
        return;
    }

    NSDate* date = [[NSUserDefaults standardUserDefaults] objectForKey:@"bgEnterDate"];
    NSDate* now = [NSDate date];
    NSLog(@"minutesBeforeDate: %d", [date minutesBeforeDate:now]);
    if ([date minutesBeforeDate:now] > 15) {
        
        if (!debug)
            [self.modelManager loadData];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)refreshData {
    
    [self.modelManager loadData];
}

- (void)closeSignupController {
    
    UIStoryboard *settingsStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UIViewController *rootController = [settingsStoryboard instantiateInitialViewController];
    rootController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    self.window.rootViewController = rootController;
}

- (void)logout {
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDefaultsProfileEmailID];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDefaultsProfilePswdID];
    [[NSUserDefaults standardUserDefaults]  synchronize];
    
    UIStoryboard *settingsStoryboard = [UIStoryboard storyboardWithName:@"SignupStoryboard" bundle:nil];
    UIViewController *rootController = [settingsStoryboard instantiateInitialViewController];
    rootController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    self.window.rootViewController = rootController;
}

- (BOOL)isPicklineOn {
    
    int state = [[NSUserDefaults standardUserDefaults] integerForKey:kUserDefaultsPicklineOn];
    if (state == 2)
        return YES;
    else if (state == 1)
        return NO;
    else {
        [self setPicklineOn:YES];
        return YES;
    }
}

- (void)setPicklineOn:(BOOL)status {
    
    int state = (status) ? 2 : 1;
    [[NSUserDefaults standardUserDefaults] setInteger:state forKey:kUserDefaultsPicklineOn];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString*)getUserEmail {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsProfileEmailID];
}

@end

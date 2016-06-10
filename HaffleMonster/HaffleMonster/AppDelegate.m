//
//  AppDelegate.m
//  HaffleMonster
//
//  Created by Fermata on 2015. 3. 13..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize isFirst;
@synthesize userInfoViewController;
@synthesize navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GMSServices provideAPIKey:@"AIzaSyBCllMzWgaRvGT2OTD06-FK0RC2ljI0JtU"];
    if(kUseCrashlytics){
        [Fabric with:@[CrashlyticsKit]];
    }
    [[HMKinsightSession shared] initialize];
    [[SRAPIManager manager] enterApp];
    if (SRUserDefaults.hasLaunchedOnce){
        self.isFirst = NO;
        SRUserDefaults.isFirstLaunch = NO;
    }else{
        self.isFirst = YES;
        [[SRDatabase db] createTables];
        SRUserDefaults.hasLaunchedOnce = YES;
        SRUserDefaults.isFirstLaunch = YES;
    }
    if(!SRUserDefaults.didRegisterUser){
        [[SRAPIManager manager] registerUser];
    }
    
    UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    if(kShowRenewedUI){
        self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
        HMGoodsViewController *vc = [[HMGoodsViewController alloc] initWithNibName:@"HMGoodsViewController" bundle:[NSBundle mainBundle]]; // determine the initial view controller here and instantiate it with [storyboard instantiateViewControllerWithIdentifier:<storyboard id>];
        self.window.rootViewController = vc;
        [self.window makeKeyAndVisible];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [[HMKinsightSession shared] close];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[HMKinsightSession shared] close];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[HMKinsightSession shared] resume];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[HMKinsightSession shared] resume];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[HMKinsightSession shared] close];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSArray *urlComponents = [[url query] componentsSeparatedByString:@"&"];
    for (NSString *keyValuePair in urlComponents)
    {
        NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
        NSString *key = [[pairComponents firstObject] stringByRemovingPercentEncoding];
        NSString *value = [[pairComponents lastObject] stringByRemovingPercentEncoding];
        [[[HMShareManager manager] values] setObject:value forKey:key];
    }
    
    return YES;
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString *deviceTokenString = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    deviceTokenString = [deviceTokenString stringByReplacingOccurrencesOfString:@" " withString:@""];
    SRUserDefaults.apnsDeviceToken = deviceTokenString;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if ( application.applicationState == UIApplicationStateInactive || application.applicationState == UIApplicationStateBackground  )
    {
        if(userInfo[@"martId"] != nil){
            [[[HMShareManager manager] values] setObject:userInfo[@"martId"] forKey:@"MartPushID"];
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"App Launched Inactive" message:@"앱이 푸시타고 들어왔다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    if(notification.userInfo[@"UserCartItemID"] != nil){
        [[[HMShareManager manager] values] setObject:notification.userInfo[@"UserCartItemID"] forKey:@"UserCartItemID"];
    }
}


@end

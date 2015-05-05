//
//  AppDelegate.m
//  Blue Ham
//
//  Created by Ethan Gill on 5/4/15.
//  Copyright (c) 2015 Ethan Gill. All rights reserved.
//

#import "AppDelegate.h"
#import "SendViewController.h"
#import "ReceiveViewController.h"

@interface AppDelegate ()

//@property (strong, nonatomic) ReceiveViewController *receiveViewController;
//@property (strong, nonatomic) SendViewController *sendViewController;
@end

@implementation AppDelegate
@synthesize beacon;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self startBeacons];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLabel) name:@"Subscribed" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLabel2) name:@"Unsubscribed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(terminate) name:@"terminate" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startBeacons) name:@"reconnect" object:nil];
    
//    if ([self.window.rootViewController isKindOfClass:[SendViewController class]]) {
//        self.sendViewController = (SendViewController *)self.window.rootViewController;
//    } else if ([self.window.rootViewController isKindOfClass:[ReceiveViewController class]]){
//        self.receiveViewController = (ReceiveViewController*)self.window.rootViewController;
//    }
    return YES;
}

- (void)startBeacons {
    beacon = [JGBeacon new];
    beacon.running = JGBeaconSendingAndReceiving;
    beacon.delegate = self;
}

- (void)receivedData:(NSData *)data {
    NSLog(@"Received Data");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dataReceived" object:data];
    
//    self.receiveViewController = (ReceiveViewController*)self.window.rootViewController;
//    [self.receiveViewController addToLog:@"Received Data"];
    
//    NSString *decodedString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    [[NSUserDefaults standardUserDefaults] setObject:decodedString forKey:@"lastURL"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    if ([decodedString hasPrefix:@"http"] || [decodedString hasPrefix:@"spotify"] || [decodedString hasPrefix:@"twitter"]) {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:decodedString]];
//    }
//    NSLog(@"decoded: %@ %@", data, decodedString);
//    UIApplicationState state = [[UIApplication sharedApplication] applicationState];
//    if (state == UIApplicationStateBackground || state == UIApplicationStateInactive)
//    {
//        if (![decodedString isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"lastURL"]]) {
//            
//        } else {
//            UILocalNotification *notification = [[UILocalNotification alloc] init];
//            notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:0];
//            notification.alertBody = @"New Baton Arrived.";
//            notification.timeZone = [NSTimeZone defaultTimeZone];
//            notification.soundName = UILocalNotificationDefaultSoundName;
//            NSLog(@"notification sent");
//            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
//        }
//    }
}

- (void)terminate {
    NSString *data = @"TERMINATE";
    NSData *plainData = [data dataUsingEncoding:NSUTF8StringEncoding];
    [beacon queueDataToSend:plainData];
    [beacon terminate];
    //    [self.statusLabel setText:@"Not Connected"];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"terminate" object:nil];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reblue" object:nil];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reblue" object:nil];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
//{    UIApplicationState state = [application applicationState];
//    
//    NSLog(@"LAOS %ld", (long)state);
//    // check state here
//    
//    //    if(state == UIApplicationStateBackground || state == UIApplicationStateInactive){
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSString *string = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastURL"];
//        NSLog(@"SASJHLKASJHDAS %@", string);
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
//    });
//    
//    //    }
//    
//}

@end

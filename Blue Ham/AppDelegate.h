//
//  AppDelegate.h
//  Blue Ham
//
//  Created by Ethan Gill on 5/4/15.
//  Copyright (c) 2015 Ethan Gill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGBeacon.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, JGBeaconDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) JGBeacon *beacon;

@end


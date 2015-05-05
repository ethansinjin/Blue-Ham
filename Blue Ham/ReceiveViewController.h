//
//  SecondViewController.h
//  Blue Ham
//
//  Created by Ethan Gill on 5/4/15.
//  Copyright (c) 2015 Ethan Gill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGBeacon.h"

@interface ReceiveViewController : UIViewController 

@property (strong, nonatomic) IBOutlet UITextView *log;
@property (strong, nonatomic) IBOutlet UITextView *messageView;

- (void)addToLog:(NSString*)string;

@end


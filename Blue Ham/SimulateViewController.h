//
//  SimulateViewController.h
//  Blue Ham
//
//  Created by Ethan Gill on 5/5/15.
//  Copyright (c) 2015 Ethan Gill. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimulateViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *transmitButtonPlaceholder;
@property (strong, nonatomic) IBOutlet UITextView *messageView;
@property (strong, nonatomic) IBOutlet UITextView *log;

- (void)addToLog:(NSString*)string;

@end

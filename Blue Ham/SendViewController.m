//
//  FirstViewController.m
//  Blue Ham
//
//  Created by Ethan Gill on 5/4/15.
//  Copyright (c) 2015 Ethan Gill. All rights reserved.
//

#import "SendViewController.h"
#import "HTPressableButton.h"
#import "UIColor+HTColor.h"
#import "AppDelegate.h"

@interface SendViewController ()

@end

@implementation SendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CGRect frame = CGRectMake(0,0,250,50);
    HTPressableButton *rectButton = [[HTPressableButton alloc] initWithFrame:frame buttonStyle:HTPressableButtonStyleRect];
    rectButton.buttonColor = [UIColor ht_jayColor];
    rectButton.shadowColor = [UIColor ht_jayDarkColor];
    [rectButton setTitle:@"Transmit" forState:UIControlStateNormal];
    [self.transmitButtonPlaceholder addSubview:rectButton];
    
    [rectButton addTarget:self
                 action:@selector(sendData)
       forControlEvents:UIControlEventTouchUpInside];
    
    self.log.text = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sendData {
    NSData *plainData = [self.messageView.text dataUsingEncoding:NSUTF8StringEncoding];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self addToLog:[NSString stringWithFormat:@"Sending String: %@",self.messageView.text]];
    [appDelegate.beacon queueDataToSend:plainData];
}

- (void)addToLog:(NSString*)string {
    self.log.text = [NSString stringWithFormat:@"%@\n%@",string, self.log.text];
}

@end

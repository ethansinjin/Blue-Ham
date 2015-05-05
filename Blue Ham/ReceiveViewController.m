//
//  SecondViewController.m
//  Blue Ham
//
//  Created by Ethan Gill on 5/4/15.
//  Copyright (c) 2015 Ethan Gill. All rights reserved.
//

#import "ReceiveViewController.h"
#import "hamming.h"

@interface ReceiveViewController ()

@end

@implementation ReceiveViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processReceivedData:) name:@"dataReceived" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subscribed) name:@"Subscribed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unsubscribed) name:@"Unsubscribed" object:nil];
    self.log.text = @"";
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) processReceivedData:(NSNotification *)notification {
    //do all the logging and stuff here
    NSData *data = [notification object];
    NSString *decodedString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self addToLog:@"Received a valid NSData object"];
    [self updateReceivedMessage:decodedString];

}

- (void) subscribed {
    [self addToLog:@"Subscribed to a broadcast"];
}

- (void) unsubscribed {
    [self addToLog:@"Unsubscribed from a broadcast"];
}

- (void)addToLog:(NSString*)string {
    self.log.text = [NSString stringWithFormat:@"%@\n%@",string, self.log.text];
}

- (void)updateReceivedMessage:(NSString*)string {
    self.messageView.text = [NSString stringWithFormat:@"%@",string];
}

@end

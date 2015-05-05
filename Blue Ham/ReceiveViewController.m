//
//  SecondViewController.m
//  Blue Ham
//
//  Created by Ethan Gill on 5/4/15.
//  Copyright (c) 2015 Ethan Gill. All rights reserved.
//

#import "ReceiveViewController.h"
#import "hamming.h"

#define HI_NIBBLE(b) (((b) >> 4) & 0x0F)
#define LO_NIBBLE(b) ((b) & 0x0F)

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
    [self addToLog:@"Received a valid NSData object. Decoding"];
    unsigned long rlength = [data length];
    unsigned char receivedData[rlength];
    unsigned char decodedData[rlength];
    [data getBytes:receivedData length:rlength];
    //we now have the received data present in receivedData
    for (int i = 0; i < rlength; i++) {
        unsigned char decodedChar = HammingMatrixDecode(receivedData[i]);
        decodedData[i] = decodedChar;
    }
    NSData *completeData = [NSData dataWithBytes:(const void *)decodedData length:sizeof(unsigned char)*rlength];
    NSString *decodedString = [[NSString alloc] initWithData:completeData encoding:NSUTF8StringEncoding];
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

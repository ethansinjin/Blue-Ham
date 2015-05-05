//
//  FirstViewController.m
//  Blue Ham
//
//  Created by Ethan Gill on 5/4/15.
//  Copyright (c) 2015 Ethan Gill. All rights reserved.
//

#define HI_NIBBLE(b) (((b) >> 4) & 0x0F)
#define LO_NIBBLE(b) ((b) & 0x0F)

#import "SendViewController.h"
#import "HTPressableButton.h"
#import "UIColor+HTColor.h"
#import "AppDelegate.h"
#import "hamming.h"

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
    self.messageView.text = @"Test";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sendData {
    NSData *plainData = [self.messageView.text dataUsingEncoding:NSUTF8StringEncoding];
    [self addToLog:[NSString stringWithFormat:@"Encoding String: %@",self.messageView.text]];
    unsigned long rlength = [plainData length];
    unsigned char rawData[rlength];
    unsigned char encodedData[rlength];
    [plainData getBytes:rawData length:rlength];
    //we now have the raw data present in rawData
    for (int i = 0; i < rlength; i++) {
        unsigned char encodedChar = HammingMatrixEncode(rawData[i]);
        NSLog(@"%x becomes %x",rawData[i],encodedChar);
        encodedData[i] = encodedChar;
    }
    NSData *completeData = [NSData dataWithBytes:(const void *)encodedData length:sizeof(unsigned char)*rlength];
    
    //send the completed data
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.beacon queueDataToSend:completeData];
    
    unsigned char receivedData[rlength];
    unsigned char decodedData[rlength];
    [completeData getBytes:receivedData length:rlength];
    NSLog(@"Decoding:\n");
    //we now have the received data present in receivedData
    for (int i = 0; i < rlength; i++) {
        unsigned char decodedChar = HammingMatrixDecode(receivedData[i]);
        NSLog(@"%x becomes %x",receivedData[i],decodedChar);
        decodedData[i] = decodedChar;
    }
    NSData *testCData = [NSData dataWithBytes:(const void *)decodedData length:sizeof(unsigned char)*rlength];
    if (plainData == testCData) {
        [self addToLog:@"Local Decoding successful"];
    } else {
        [self addToLog:@"Local Decoding failed"];
    }
    
}

- (void)addToLog:(NSString*)string {
    self.log.text = [NSString stringWithFormat:@"%@\n%@",string, self.log.text];
}

@end

//
//  FirstViewController.m
//  Blue Ham
//
//  Created by Ethan Gill on 5/4/15.
//  Copyright (c) 2015 Ethan Gill. All rights reserved.
//

#define HI_NIBBLE(b) (((b) >> 4) & 0x0F);
#define LO_NIBBLE(b) ((b) & 0x0F);
#define COMBINE_NIBBLES(a,b) (a << 4) | b;

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
    [self addToLog:[NSString stringWithFormat:@"unsigned char representation: %@",plainData]];
    unsigned long rlength = [plainData length];
    unsigned char rawData[rlength];
    unsigned char splitData[rlength*2];
    unsigned char encodedData[rlength*2];
    [plainData getBytes:rawData length:rlength];
    //we now have the raw data present in rawData
    //we need to split up the bytes so that we can encode and decode correctly
    int counter = 0;
    for (int i = 0; i < rlength; i++) {
        splitData[counter] = HI_NIBBLE(rawData[i]);
        counter++;
        splitData[counter] = LO_NIBBLE(rawData[i]);
        counter++;
        NSLog(@"%x split to %x and %x",rawData[i],splitData[counter-2],splitData[counter-1]);
    }
    for (int i = 0; i < rlength*2; i++) {
        unsigned char encodedChar = HammingMatrixEncode(splitData[i]);
        NSLog(@"%x becomes %x",splitData[i],encodedChar);
        encodedData[i] = encodedChar;
    }
    NSData *completeData = [NSData dataWithBytes:(const void *)encodedData length:sizeof(unsigned char)*rlength*2];
    
    //send the completed data
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.beacon queueDataToSend:completeData];
    [self addToLog:[NSString stringWithFormat:@"Transmitted Encoded Message: %@",completeData]];
    //perform the steps in reverse to verify that the data can be locally decoded
    rlength = [completeData length];
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
    //we now need to combine the bytes to receive the original message
    unsigned char combinedData[rlength/2];
    counter = 0;
    for (int i = 0; i < rlength/2; i++) {
        combinedData[i] = COMBINE_NIBBLES(decodedData[counter], decodedData[counter+1]);
        counter += 2;
        NSLog(@"%x and %x combine to %x",decodedData[counter-2],decodedData[counter-1],combinedData[i]);
    }
    NSData *testCData = [NSData dataWithBytes:(const void *)combinedData length:sizeof(unsigned char)*rlength/2];
    if ([plainData isEqualToData:testCData]) {
        [self addToLog:@"Local Decode Verification Successful"];
    } else {
        [self addToLog:@"Local Decode Verification Failed"];
    }
    
}

- (void)addToLog:(NSString*)string {
    self.log.text = [NSString stringWithFormat:@"%@\n%@",string, self.log.text];
}

@end

//
//  SimulateViewController.m
//  Blue Ham
//
//  Created by Ethan Gill on 5/5/15.
//  Copyright (c) 2015 Ethan Gill. All rights reserved.
//

#define HI_NIBBLE(b) (((b) >> 4) & 0x0F);
#define LO_NIBBLE(b) ((b) & 0x0F);
#define COMBINE_NIBBLES(a,b) (a << 4) | b;
#define TOGGLE_BIT(a,b) (a ^= 1 << b); //toggle bit in data a at position b

#import "SimulateViewController.h"
#import "HTPressableButton.h"
#import "UIColor+HTColor.h"
#import "AppDelegate.h"
#import "hamming.h"

@interface SimulateViewController ()

@end

@implementation SimulateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect frame = CGRectMake(0,0,250,50);
    HTPressableButton *rectButton = [[HTPressableButton alloc] initWithFrame:frame buttonStyle:HTPressableButtonStyleRect];
    rectButton.buttonColor = [UIColor ht_leadColor];
    rectButton.shadowColor = [UIColor ht_leadDarkColor];
    [rectButton setTitle:@"Simulate" forState:UIControlStateNormal];
    [self.transmitButtonPlaceholder addSubview:rectButton];
    
    [rectButton addTarget:self
                   action:@selector(sendData)
         forControlEvents:UIControlEventTouchUpInside];
    
    self.log.text = @"";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addToLog:(NSString*)string {
    self.log.text = [NSString stringWithFormat:@"%@\n%@",string, self.log.text];
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
        [self addToLog:[NSString stringWithFormat:@"%x split to %x and %x",rawData[i],splitData[counter-2],splitData[counter-1]]];
    }
    for (int i = 0; i < rlength*2; i++) {
        unsigned char encodedChar = HammingMatrixEncode(splitData[i]);
        [self addToLog:[NSString stringWithFormat:@"%x encodes to %x",splitData[i],encodedChar]];
        encodedData[i] = encodedChar;
    }
    NSData *completeData = [NSData dataWithBytes:(const void *)encodedData length:sizeof(unsigned char)*rlength*2];
    
    [self addToLog:[NSString stringWithFormat:@"Encoded Message: %@",completeData]];
    //perform the steps in reverse to verify that the data can be locally decoded
    rlength = [completeData length];
    unsigned char receivedData[rlength];
    unsigned char decodedData[rlength];
    [completeData getBytes:receivedData length:rlength];
    [self addToLog:[NSString stringWithFormat:@"Decoding Started. Introducing errors"]];
    //we now have the received data present in receivedData
    for (int i = 0; i < rlength; i++) {
        //arbitrarily pick the bit to screw up. Let's do bit 5 for no real reason
        //toggle it
        TOGGLE_BIT(receivedData[i],5);
    }
    for (int i = 0; i < rlength; i++) {
        unsigned char decodedChar = HammingMatrixDecode(receivedData[i]);
        [self addToLog:[NSString stringWithFormat:@"%x decodes to %x",receivedData[i],decodedChar]];
        decodedData[i] = decodedChar;
    }
    //we now need to combine the bytes to receive the original message
    unsigned char combinedData[rlength/2];
    counter = 0;
    for (int i = 0; i < rlength/2; i++) {
        combinedData[i] = COMBINE_NIBBLES(decodedData[counter], decodedData[counter+1]);
        counter += 2;
        [self addToLog:[NSString stringWithFormat:@"%x and %x combine to %x",decodedData[counter-2],decodedData[counter-1],combinedData[i]]];
    }
    NSData *testCData = [NSData dataWithBytes:(const void *)combinedData length:sizeof(unsigned char)*rlength/2];
    [self addToLog:[NSString stringWithFormat:@"Decoded unsigned char representation: %@", testCData]];
    if ([plainData isEqualToData:testCData]) {
        [self addToLog:@"Local Decode Verification Successful"];
    } else {
        [self addToLog:@"Local Decode Verification Failed"];
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

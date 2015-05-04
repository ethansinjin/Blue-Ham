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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

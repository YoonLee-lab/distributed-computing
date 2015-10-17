//
//  ViewController.m
//  Distrubutor
//
//  Created by Taha  on 10/16/15.
//  Copyright © 2015 OSUBoilerMaker. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    tcpHandler = [[TCP_Handler alloc] initWithDelegate:self];
    [connectButton setTitle:@"My Title" forState:UIControlStateNormal];
    UIButton *mySwitch = [[UIButton alloc] initWithFrame:CGRectMake(130, 235, 0, 0)];
    [mySwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:mySwitch];
    
}

- (void)changeSwitch:(id)sender{
    
    if([sender isOn]){
        NSLog(@"Connect");
    } else{
        NSLog(@"Disconnect");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openconnection:(UIButton *)sender {
    if (!tcpHandler.connecting) {
        if (!tcpHandler.connected) {
            [tcpHandler connect];
        }
        else{
            [tcpHandler disconnect];
        }
    }
}

-(NSString *)performCalculation:(NSString *)data{
    if(![data containsString:@":"]){
        return @"Error";
    }
    else{
        NSArray *arr = [data componentsSeparatedByString:@":"];
        long indexOfDevice = [[arr objectAtIndex:0] integerValue];
        long deviceCount = [[arr objectAtIndex:1] integerValue];
        long uBound = [[arr objectAtIndex:2] integerValue];
        NSLog(@"deviceCount: %ld",deviceCount);
        double sum = 0;
        for (long i = indexOfDevice; i <= uBound; i+=deviceCount) {
            sum+=1;
        }
        
        return [NSString stringWithFormat:@"%f",sum];
    }
}

/** TCP_Delegate Methods **/

-(void)didConnect{
    NSLog(@"CONNECTED");
}

-(void)didDisconnect{
    NSLog(@"DISCONNECTED");
}

-(void)connectFailed{
    NSLog(@"FAILED TO CONNECT");
}

-(void)didReceiveCalculation:(NSString *)calculation{
    NSString *response = [self performCalculation:calculation];
    [tcpHandler writeAnswer:response];
}

@end

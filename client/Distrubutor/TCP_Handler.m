//
//  TCP_Handler.m
//  Distrubutor
//
//  Created by Danny Flax on 10/17/15.
//  Copyright © 2015 OSUBoilerMaker. All rights reserved.
//

#import "TCP_Handler.h"

#define HOST_IP "10.186.105.175"
#define HOST_PORT 8080

@implementation TCP_Handler
-(TCP_Handler *)initWithDelegate:(id<TCP_Delegate>)delegate{
    self = [super init];
    _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    _delegate = delegate;
    self.connecting = false;
    return self;
}

-(void)connect{
    NSError *err = nil;
    if (![_socket connectToHost:[NSString stringWithFormat:@"%s",HOST_IP] onPort:HOST_PORT error:&err]) // Asynchronous!
    {
        // If there was an error, it's likely something like "already connected" or "no delegate set"
        
        NSLog(@"%@",err.localizedDescription);
        [_delegate connectFailed];
    }
    else{
        self.connecting = true;
        [_socket readDataToLength:500 withTimeout:-1 tag:0];
    }
}

-(void)disconnect{
    [_socket disconnect];
    self.connected = false;
    [_delegate didDisconnect];
}

-(void)writeAnswer:(NSString *)answer{
    [_socket writeData:[answer dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
}

/**
 ** GCDAsyncDelegate Methods
 **/
- (void)socket:(GCDAsyncSocket *)sender didConnectToHost:(NSString *)host port:(UInt16)port
{
    self.connected = true;
    self.connecting = false;
    [_delegate didConnect];
}

- (void)socket:(GCDAsyncSocket *)sender didReadData:(NSData *)data withTag:(long)tag
{
    if (tag == 0)
    {
        [_delegate didReceiveCalculation:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
    }
}


@end
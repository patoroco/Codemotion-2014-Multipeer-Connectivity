//
//  ViewController+MCSessionDelegate.m
//  BoardPeer
//
//  Created by Jorge Maroto García on 20/11/14.
//  Copyright (c) 2014 http://maroto.me. All rights reserved.
//

#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "ViewController+NSStreamDelegate.h"
#import "ViewController+MCSessionDelegate.h"


@implementation ViewController (MCSessionDelegate)

#pragma mark - MCSessionDelegate
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    switch (state) {
        case MCSessionStateConnected:
        {
            NSLog(@"Connected with %@", peerID.displayName);
            
            NSError *error;
            self.output = [self.appdelegate.session startStreamWithName:@"touchs" toPeer:self.appdelegate.session.connectedPeers[0] error:&error];
            self.output.delegate = self;
            
            if (error) {
                self.output = nil;
                NSLog(@"ERROR: %@", error.localizedDescription);
                return;
            }
            
            [self.output scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
            [self.output open];
            
            [self.browser dismissViewControllerAnimated:YES completion:nil];
            break;
        }
        case MCSessionStateConnecting:
            NSLog(@"Waiting for %@", peerID.displayName);
            break;
        case MCSessionStateNotConnected:
        {
            NSLog(@"Disconnected from %@", peerID.displayName);
            break;
        }
    }
}

- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream
       withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{
    stream.delegate = self;
    [stream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [stream open];
}


- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {}
- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress {}
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName
       fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error{}

@end

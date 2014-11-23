//
//  ViewController.m
//  BoardPeer
//
//  Created by Jorge Maroto García on 20/11/14.
//  Copyright (c) 2014 http://maroto.me. All rights reserved.
//

#import "ViewController.h"
#import "ViewController+NSStreamDelegate.h"
#import "ViewController+MCSessionDelegate.h"
#import "ViewController+MCBrowserDelegate.h"

#import "NSData+DrawData.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.appdelegate = [[UIApplication sharedApplication] delegate];
    self.appdelegate.session.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self requireDeviceConnected];
}

#pragma mark - Gestures
- (IBAction)panReceived:(UIPanGestureRecognizer *)sender
{
    CGPoint point = [sender locationInView:sender.view];
    
    [self.drawable drawPoint:point state:sender.state];
    
    NSData *data = [NSData drawDataWithGestureState:sender.state point:[sender locationInView:sender.view]];
    [self.output write:data.bytes maxLength:data.length];
}

#pragma mark - UI Buttons
- (IBAction)cleanScreen:(UIButton *)sender
{
    [self.drawable clearScreen];
    
    NSData *data = [NSData drawDataWithGestureState:UIGestureRecognizerStateCancelled point:CGPointZero];
    [self.output write:data.bytes maxLength:data.length];
}

@end
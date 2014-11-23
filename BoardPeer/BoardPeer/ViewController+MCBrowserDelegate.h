//
//  ViewController+MCBrowserDelegate.h
//  BoardPeer
//
//  Created by Jorge Maroto García on 20/11/14.
//  Copyright (c) 2014 http://maroto.me. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (MCBrowserDelegate)<MCBrowserViewControllerDelegate>

- (void)requireDeviceConnected;

@end
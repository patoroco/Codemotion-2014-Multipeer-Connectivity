//
//  ViewController+MCBrowserDelegate.m
//  BoardPeer
//
//  Created by Jorge Maroto García on 20/11/14.
//  Copyright (c) 2014 http://maroto.me. All rights reserved.
//

#import "ViewController+MCBrowserDelegate.h"

@implementation ViewController (MCBrowserDelegate)

- (void)requireDeviceConnected
{
    if (self.appdelegate.session.connectedPeers.count == 0) {
        self.browser = [[MCBrowserViewController alloc] initWithServiceType:pizarraService session:self.appdelegate.session];
        self.browser.delegate = self;
        [self presentViewController:self.browser animated:YES completion:nil];
    }
}

#pragma mark - MCBrowserViewControllerDelegate
- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController
{
    [browserViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController
{
    [browserViewController dismissViewControllerAnimated:YES completion:^{ [self requireDeviceConnected]; }];
}
@end

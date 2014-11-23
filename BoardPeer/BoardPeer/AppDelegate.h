//
//  AppDelegate.h
//  BoardPeer
//
//  Created by Jorge Maroto García on 20/11/14.
//  Copyright (c) 2014 http://maroto.me. All rights reserved.
//

#import <MultipeerConnectivity/MultipeerConnectivity.h>

extern NSString * const pizarraService;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MCSession *session;
@property (strong, nonatomic) MCPeerID *peerId;

@end
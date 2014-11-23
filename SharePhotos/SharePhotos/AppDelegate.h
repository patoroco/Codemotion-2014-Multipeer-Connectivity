//
//  AppDelegate.h
//  SharePhotos
//
//  Created by Jorge Maroto García on 20/11/14.
//  Copyright (c) 2014 http://maroto.me. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

extern NSString * const sharePicsService;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MCSession *session;
@property (strong, nonatomic) MCPeerID *peerId;

@end
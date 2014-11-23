//
//  ViewController.h
//  BoardPeer
//
//  Created by Jorge Maroto García on 20/11/14.
//  Copyright (c) 2014 http://maroto.me. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Drawable.h"

@interface ViewController : UIViewController
@property (nonatomic, weak) AppDelegate *appdelegate;
@property (nonatomic, strong) NSOutputStream *output;
@property (strong, nonatomic) IBOutlet Drawable *drawable;

@property (nonatomic, strong) MCBrowserViewController *browser;

@property (weak, nonatomic) IBOutlet UILabel *position;
@end


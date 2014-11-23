//
//  NSData+DrawData.h
//  BoardPeer
//
//  Created by Jorge Maroto García on 20/11/14.
//  Copyright (c) 2014 http://maroto.me. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSData (DrawData)

+ (NSData *)drawDataWithGestureState:(UIGestureRecognizerState)state point:(CGPoint)point;

@end

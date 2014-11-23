//
//  Drawable.m
//  BoardPeer
//
//  Created by Jorge Maroto García on 20/11/14.
//  Copyright (c) 2014 http://maroto.me. All rights reserved.
//

#import "Drawable.h"

@interface Drawable (){
    CGPoint lastPoint;
}

@property (nonatomic, weak) IBOutlet UIImageView *layout;
@property (nonatomic, weak) IBOutlet UIImageView *tmpLayout;
@end

@implementation Drawable

#pragma mark - Drawing
- (void)clearScreen
{
    UIGraphicsBeginImageContext(self.layout.frame.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBFillColor(ctx, 255.0, 255.0, 255.0, 1.0);
    CGContextFillRect(ctx, CGRectMake(0, 0, self.tmpLayout.frame.size.width, self.tmpLayout.frame.size.height));
    self.layout.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (void)drawPoint:(CGPoint)point state:(UIGestureRecognizerState)state
{
    switch (state) {
        case UIGestureRecognizerStateBegan:
        {
            lastPoint = point;
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            CGPoint currentPoint = point;
            
            UIGraphicsBeginImageContext(self.layout.frame.size);
            [self.tmpLayout.image drawInRect:CGRectMake(0, 0, self.layout.frame.size.width, self.layout.frame.size.height)];
            CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
            CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
            CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
            CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 10);
            CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0, 0, 0, 1.0);
            CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
            
            CGContextStrokePath(UIGraphicsGetCurrentContext());
            self.tmpLayout.image = UIGraphicsGetImageFromCurrentImageContext();
            [self.tmpLayout setAlpha:1];
            UIGraphicsEndImageContext();
            
            lastPoint = currentPoint;
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            UIGraphicsBeginImageContext(self.layout.frame.size);
            [self.layout.image drawInRect:CGRectMake(0, 0, self.layout.frame.size.width, self.layout.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
            [self.tmpLayout.image drawInRect:CGRectMake(0, 0, self.layout.frame.size.width, self.layout.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
            self.layout.image = UIGraphicsGetImageFromCurrentImageContext();
            self.tmpLayout.image = nil;
            UIGraphicsEndImageContext();
            break;
        }
            
            
        default:
            break;
    }
}
@end
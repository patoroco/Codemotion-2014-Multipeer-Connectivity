//
//  ViewController+NSStreamDelegate.m
//  BoardPeer
//
//  Created by Jorge Maroto García on 20/11/14.
//  Copyright (c) 2014 http://maroto.me. All rights reserved.
//

#import "ViewController+NSStreamDelegate.h"

@implementation ViewController (NSStreamDelegate)

#pragma mark - NSStreamDelegate
- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    if (self.output == aStream) { return; }
    
    switch (eventCode) {
        case NSStreamEventOpenCompleted:
            NSLog(@"Conectado");
            break;
        case NSStreamEventEndEncountered:
            NSLog(@"Cerrando stream");
            [aStream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
            [aStream close];
            self.output = nil;
            break;
        case NSStreamEventHasBytesAvailable:
        {
            NSInputStream *inputStream = (NSInputStream *)aStream;
            
            static int packageSize = 2 * sizeof(float) + sizeof(UIGestureRecognizerState);
            uint8_t buffer[packageSize];
            NSInteger size = [inputStream read:(uint8_t *)buffer maxLength:sizeof(buffer)];
            
            if (packageSize != size) {
                return;
            }
            
            NSData *data = [NSData dataWithBytes:buffer length:size];
            float x, y;
            UIGestureRecognizerState state;
            
            [data getBytes:&x range:NSMakeRange(0, sizeof(float))];
            [data getBytes:&y range:NSMakeRange(sizeof(float), sizeof(float))];
            [data getBytes:&state range:NSMakeRange(2*sizeof(float), sizeof(UIGestureRecognizerState))];
            
            if (state == UIGestureRecognizerStateCancelled) {
                [self.drawable clearScreen];
                return;
            }
            
            self.position.text = [NSString stringWithFormat:@"%f - %f", x, y];
            
            CGPoint point = CGPointMake(x, y);
            [self.drawable drawPoint:point state:state];
            
            break;
        }
        default:
            NSLog(@"Event: %lu", (unsigned long)eventCode);
            break;
    }
}

@end
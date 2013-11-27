/*
 * Copyright (c) 2013 Razeware LLC
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "SKNode+SKTDebugDraw.h"

BOOL SKTDebugDrawEnabled = YES;

@implementation SKNode (SKTDebugDraw)

- (SKShapeNode *)skt_attachDebugFrameFromPath:(CGPathRef)path color:(SKColor *)color {
  if (SKTDebugDrawEnabled) {
    SKShapeNode *shape = [SKShapeNode node];
    shape.path = path;
    shape.strokeColor = color;
    shape.lineWidth = 1.0;
	shape.glowWidth = 0.0;
	shape.antialiased = NO;
    [self addChild:shape];
    return shape;
  }
  return nil;
}

- (SKShapeNode *)skt_attachDebugRectWithSize:(CGSize)size color:(SKColor *)color {
  if (SKTDebugDrawEnabled) {
    CGPathRef bodyPath = CGPathCreateWithRect(CGRectMake(-size.width/2.0, -size.height/2.0, size.width, size.height), nil);
    SKShapeNode *shape = [self skt_attachDebugFrameFromPath:bodyPath color:color];
    CGPathRelease(bodyPath);
    return shape;
  }
  return nil;
}

- (SKShapeNode *)skt_attachDebugCircleWithRadius:(CGFloat)radius color:(SKColor *)color {
  if (SKTDebugDrawEnabled) {
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-radius, -radius, radius*2.0, radius*2.0)];
    SKShapeNode *shape = [self skt_attachDebugFrameFromPath:path.CGPath color:color];
    return shape;
  }
  return nil;
}

- (SKShapeNode *)skt_attachDebugLineFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint color:(SKColor *)color {
  if (SKTDebugDrawEnabled) {
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:startPoint];
    [path addLineToPoint:endPoint];
    return [self skt_attachDebugFrameFromPath:path.CGPath color:color];
  }
  return nil;
}

@end

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

#import <SpriteKit/SpriteKit.h>

@interface SKNode (SKTExtras)

/** Lets you treat the node's scale as a CGPoint value. */
@property (nonatomic, assign) CGPoint skt_scale;

/**
 * Runs an action on the node that performs a selector after a given time.
 */
- (void)skt_performSelector:(SEL)selector onTarget:(id)target afterDelay:(NSTimeInterval)delay;

/**
 * Makes this node the frontmost node in its parent.
 */
- (void)skt_bringToFront;

/**
 * Orients the node in the direction that it is moving by tweening its rotation
 * angle. This assumes that at 0 degrees the node is facing up.
 *
 * @param rate How fast the node rotates. Must have a value between 0.0 and 1.0,
 *        where smaller means slower; 1.0 is instantaneous.
 */
- (void)skt_rotateToVelocity:(CGVector)velocity rate:(CGFloat)rate;

@end

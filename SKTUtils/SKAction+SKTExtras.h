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

@interface SKAction (SKTExtras)

/**
 * Shorthand for:
 *   [SKAction sequence:@[[SKAction waitForDuration:duration], action]]
 */
+ (instancetype)skt_afterDelay:(NSTimeInterval)duration perform:(SKAction *)action;

/**
 * Shorthand for:
 *   [SKAction sequence:@[[SKAction waitForDuration:duration], [SKAction runBlock:^{ ... }]]]
 */
+ (instancetype)skt_afterDelay:(NSTimeInterval)duration runBlock:(dispatch_block_t)block;

/**
 * Shorthand for:
 *   [SKAction sequence:@[[SKAction waitForDuration:duration], [SKAction removeFromParent]]]
 */
+ (instancetype)skt_removeFromParentAfterDelay:(NSTimeInterval)duration;

/** 
 * Creates an action to perform a parabolic jump.
 */
+ (instancetype)skt_jumpWithHeight:(float)height duration:(float)duration originalPosition:(CGPoint)originalPosition;

@end

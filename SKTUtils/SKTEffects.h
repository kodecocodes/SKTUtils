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
#import "SKTTimingFunctions.h"

/**
 * Allows you to perform actions with custom timing functions.
 *
 * Unfortunately, SKAction does not have a concept of a timing function, so
 * we need to replicate the actions using SKTEffect subclasses.
 */
@interface SKTEffect : NSObject

@property (nonatomic, weak) SKNode *node;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, copy) SKTTimingFunction timingFunction;

+ (instancetype)effectWithNode:(SKNode *)node duration:(NSTimeInterval)duration;
- (instancetype)initWithNode:(SKNode *)node duration:(NSTimeInterval)duration;

- (void)update:(float)t;

@end

/**
 * Moves a node from its current position to a new position.
 */
@interface SKTMoveEffect : SKTEffect

+ (instancetype)effectWithNode:(SKNode *)node duration:(NSTimeInterval)duration startPosition:(CGPoint)startPosition endPosition:(CGPoint)endPosition;
- (instancetype)initWithNode:(SKNode *)node duration:(NSTimeInterval)duration startPosition:(CGPoint)startPosition endPosition:(CGPoint)endPosition;

@end

/**
 * Scales a node to a certain scale factor.
 */
@interface SKTScaleEffect : SKTEffect

+ (instancetype)effectWithNode:(SKNode *)node duration:(NSTimeInterval)duration startScale:(CGPoint)startScale endScale:(CGPoint)endScale;
- (instancetype)initWithNode:(SKNode *)node duration:(NSTimeInterval)duration startScale:(CGPoint)startScale endScale:(CGPoint)endScale;

@end

/**
 * Rotates a node to a certain angle.
 */
@interface SKTRotateEffect : SKTEffect

+ (instancetype)effectWithNode:(SKNode *)node duration:(NSTimeInterval)duration startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle;
- (instancetype)initWithNode:(SKNode *)node duration:(NSTimeInterval)duration startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle;

@end

/**
 * Wrapper that allows you to use SKTEffect objects as regular SKActions.
 */
@interface SKAction (SKTEffect)

+ (instancetype)actionWithEffect:(SKTEffect *)effect;

@end

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

#import "SKTEffects.h"
#import "SKTUtils.h"

@implementation SKTEffect

+ (instancetype)effectWithNode:(SKNode *)node duration:(NSTimeInterval)duration {
  return [[[self class] alloc] initWithNode:node duration:duration];
}

- (instancetype)initWithNode:(SKNode *)node duration:(NSTimeInterval)duration {
  if ((self = [super init])) {
    _node = node;
    _duration = duration;
    _timingFunction = SKTTimingFunctionLinear;
  }
  return self;
}

- (void)dealloc
{
  //NSLog(@"dealloc %@", self);
}

- (void)update:(float)t
{
  // subclass should implement this
}

@end

@implementation SKTMoveEffect {
  CGPoint _startPosition;
  CGPoint _delta;
  CGPoint _previousPosition;
}

+ (instancetype)effectWithNode:(SKNode *)node duration:(NSTimeInterval)duration startPosition:(CGPoint)startPosition endPosition:(CGPoint)endPosition {
  return [[[self class] alloc] initWithNode:node duration:duration startPosition:startPosition endPosition:endPosition];
}

- (instancetype)initWithNode:(SKNode *)node duration:(NSTimeInterval)duration startPosition:(CGPoint)startPosition endPosition:(CGPoint)endPosition {
  if ((self = [self initWithNode:node duration:duration])) {
    _previousPosition = node.position;
    _startPosition = startPosition;
    _delta = CGPointSubtract(endPosition, _startPosition);
  }
  return self;
}

- (void)update:(float)t {
  // This allows multiple SKTMoveEffect objects to modify the same node
  // at the same time.
  CGPoint newPosition = CGPointAdd(_startPosition, CGPointMultiplyScalar(_delta, t));
  CGPoint diff = CGPointSubtract(newPosition, _previousPosition);
  _previousPosition = newPosition;
  self.node.position = CGPointAdd(self.node.position, diff);
}

@end

@implementation SKTScaleEffect {
  CGPoint _startScale;
  CGPoint _delta;
  CGPoint _previousScale;
}

+ (instancetype)effectWithNode:(SKNode *)node duration:(NSTimeInterval)duration startScale:(CGPoint)startScale endScale:(CGPoint)endScale {
  return [[[self class] alloc] initWithNode:node duration:duration startScale:startScale endScale:endScale];
}

- (instancetype)initWithNode:(SKNode *)node duration:(NSTimeInterval)duration startScale:(CGPoint)startScale endScale:(CGPoint)endScale {
  if ((self = [self initWithNode:node duration:duration])) {
    _previousScale = CGPointMake(node.xScale, node.yScale);
    _startScale = startScale;
    _delta = CGPointSubtract(endScale, _startScale);
  }
  return self;
}

- (void)update:(float)t {
  CGPoint newScale = CGPointAdd(_startScale, CGPointMultiplyScalar(_delta, t));
  CGPoint diff = CGPointDivide(newScale, _previousScale);
  _previousScale = newScale;
  self.node.xScale *= diff.x;
  self.node.yScale *= diff.y;
}

@end

@implementation SKTRotateEffect {
  CGFloat _startAngle;
  CGFloat _delta;
  CGFloat _previousAngle;
}

+ (instancetype)effectWithNode:(SKNode *)node duration:(NSTimeInterval)duration startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle {
  return [[[self class] alloc] initWithNode:node duration:duration startAngle:startAngle endAngle:endAngle];
}

- (instancetype)initWithNode:(SKNode *)node duration:(NSTimeInterval)duration startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle {
  if ((self = [self initWithNode:node duration:duration])) {
    _previousAngle = node.zRotation;
    _startAngle = startAngle;
    _delta = endAngle - _startAngle;
  }
  return self;
}

- (void)update:(float)t {
  CGFloat newAngle = _startAngle + _delta * t;
  CGFloat diff = newAngle - _previousAngle;
  _previousAngle = newAngle;
  self.node.zRotation += diff;
}

@end

@implementation SKAction (SKTEffect)

+ (instancetype)actionWithEffect:(SKTEffect *)effect {
  return [[self class] customActionWithDuration:effect.duration actionBlock:^(SKNode *node, CGFloat elapsedTime) {
    CGFloat t = elapsedTime / effect.duration;

    if (effect.timingFunction != nil) {
      t = effect.timingFunction(t);  // the magic happens here
    }

    [effect update:t];
  }];
}

@end

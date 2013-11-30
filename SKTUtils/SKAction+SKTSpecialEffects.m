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

@implementation SKAction (SKTSpecialEffects)

+ (instancetype)skt_screenShakeWithNode:(SKNode *)node amount:(CGPoint)amount oscillations:(int)oscillations duration:(NSTimeInterval)duration {
  CGPoint oldPosition = node.position;
  CGPoint newPosition = CGPointAdd(oldPosition, amount);

  SKTMoveEffect *effect = [[SKTMoveEffect alloc] initWithNode:node duration:duration startPosition:newPosition endPosition:oldPosition];
  effect.timingFunction = SKTCreateShakeFunction(oscillations);

  return [SKAction actionWithEffect:effect];
}

+ (instancetype)skt_screenTumbleWithNode:(SKNode *)node angle:(CGFloat)angle oscillations:(int)oscillations duration:(NSTimeInterval)duration {
  CGFloat oldAngle = node.zRotation;
  CGFloat newAngle = oldAngle + angle;

  SKTRotateEffect *effect = [[SKTRotateEffect alloc] initWithNode:node duration:duration startAngle:newAngle endAngle:oldAngle];
  effect.timingFunction = SKTCreateShakeFunction(oscillations);

  return [SKAction actionWithEffect:effect];
}

+ (instancetype)skt_screenZoomWithNode:(SKNode *)node amount:(CGPoint)amount oscillations:(int)oscillations duration:(NSTimeInterval)duration {
  CGPoint oldScale = CGPointMake(node.xScale, node.yScale);
  CGPoint newScale = CGPointMultiply(oldScale, amount);

  SKTScaleEffect *effect = [[SKTScaleEffect alloc] initWithNode:node duration:duration startScale:newScale endScale:oldScale];
  effect.timingFunction = SKTCreateShakeFunction(oscillations);

  return [SKAction actionWithEffect:effect];
}

+ (instancetype)skt_colorGlitchWithScene:(SKScene *)scene originalColor:(SKColor *)originalColor duration:(NSTimeInterval)duration {
  return [[self class] customActionWithDuration:duration actionBlock:^(SKNode *node, CGFloat elapsedTime)
  {
    if (elapsedTime < duration) {
      scene.backgroundColor = SKColorWithRGB(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255));
    } else {
      scene.backgroundColor = originalColor;
    }
  }];
}

@end

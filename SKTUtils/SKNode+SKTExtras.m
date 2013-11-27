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

#import "SKNode+SKTExtras.h"

@implementation SKNode (SKTExtras)

- (void)setSkt_scale:(CGPoint)scale {
  self.xScale = scale.x;
  self.yScale = scale.y;
}

- (CGPoint)skt_scale {
  return CGPointMake(self.xScale, self.yScale);
}

- (void)skt_performSelector:(SEL)selector onTarget:(id)target afterDelay:(NSTimeInterval)delay {
  [self runAction:[SKAction sequence:@[
      [SKAction waitForDuration:delay],
      [SKAction performSelector:selector onTarget:target],
    ]]];
}

- (void)skt_bringToFront {
  SKNode *parent = self.parent;
  [self removeFromParent];
  [parent addChild:self];
}

- (void)skt_rotateToVelocity:(CGVector)velocity rate:(CGFloat)rate {

  // Determine what the rotation angle of the node ought to be based on the
  // current velocity of its physics body. This assumes that at 0 degrees the
  // node is pointed up, not to the right, so to compensate we subtract π/4
  // (90 degrees) from the calculated angle.
  CGFloat newAngle = atan2(velocity.dy, velocity.dx) - M_PI_2;

  // This always makes the node rotate over the shortest possible distance.
  // Because the range of atan2() is -180 to 180 degrees, a rotation from,
  // -170 to -190 would otherwise be from -170 to 170, which makes the node
  // rotate the wrong way (and the long way) around. We adjust the angle to
  // go from 190 to 170 instead, which is equivalent to -170 to -190.
  if (newAngle - self.zRotation > M_PI) {
    self.zRotation += M_PI * 2.0;
  } else if (self.zRotation - newAngle > M_PI) {
    self.zRotation -= M_PI * 2.0;
  }

  // Use the "standard exponential slide" to slowly tween zRotation to the
  // new angle. The greater the value of rate, the faster this goes.
  self.zRotation += (newAngle - self.zRotation) * rate;
}

@end

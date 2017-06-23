/*
 * Copyright (c) 2013-2017 Razeware LLC
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

import SpriteKit

public extension SKNode {

  /** Lets you treat the node's scale as a CGPoint value. */
  public var scaleAsPoint: CGPoint {
    get {
      return CGPoint(x: xScale, y: yScale)
    }
    set {
      xScale = newValue.x
      yScale = newValue.y
    }
  }

  /**
   * Runs an action on the node that performs a closure or function after 
   * a given time.
   */
  public func afterDelay(_ delay: TimeInterval, runBlock block: @escaping () -> Void) {
    run(SKAction.sequence([SKAction.wait(forDuration: delay), SKAction.run(block)]))
  }

  /**
   * Makes this node the frontmost node in its parent.
   */
  public func bringToFront() {
    if let parent = self.parent{
      removeFromParent()
      parent.addChild(self)
    }
  }

  /**
   * Orients the node in the direction that it is moving by tweening its
   * rotation angle. This assumes that at 0 degrees the node is facing up.
   *
   * @param velocity The current speed and direction of the node. You can get
   *        this from node.physicsBody.velocity.
   * @param rate How fast the node rotates. Must have a value between 0.0 and
   *        1.0, where smaller means slower; 1.0 is instantaneous.
   */
  public func rotateToVelocity(_ velocity: CGVector, rate: CGFloat) {
    // Determine what the rotation angle of the node ought to be based on the
    // current velocity of its physics body. This assumes that at 0 degrees the
    // node is pointed up, not to the right, so to compensate we subtract π/4
    // (90 degrees) from the calculated angle.
    let newAngle = atan2(velocity.dy, velocity.dx) - π/2

    // This always makes the node rotate over the shortest possible distance.
    // Because the range of atan2() is -180 to 180 degrees, a rotation from,
    // -170 to -190 would otherwise be from -170 to 170, which makes the node
    // rotate the wrong way (and the long way) around. We adjust the angle to
    // go from 190 to 170 instead, which is equivalent to -170 to -190.
    if newAngle - zRotation > π {
      zRotation += π * 2.0
    } else if zRotation - newAngle > π {
      zRotation -= π * 2.0
    }

    // Use the "standard exponential slide" to slowly tween zRotation to the
    // new angle. The greater the value of rate, the faster this goes.
    zRotation += (newAngle - zRotation) * rate
  }
}

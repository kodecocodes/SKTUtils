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

public extension SKAction {
  /**
   * Performs an action after the specified delay.
   */
    class func after(delay: TimeInterval, performAction action: SKAction) -> SKAction {
        return SKAction.sequence([SKAction.wait(forDuration: delay), action])
    }

  /**
   * Performs a block after the specified delay.
   */
    class func after(delay: TimeInterval, runBlock block: @escaping () -> Void) -> SKAction {
        return SKAction.after(delay: delay, performAction: SKAction.run(block))
    }

  /**
   * Removes the node from its parent after the specified delay.
   */
    class func removeFromParent(with delay: TimeInterval) -> SKAction {
        return SKAction.after(delay: delay, performAction: SKAction.removeFromParent())
    }

  /**
   * Creates an action to perform a parabolic jump.
   */
    class func jump(to height: CGFloat, duration: TimeInterval, originalPosition: CGPoint) -> SKAction {
        return SKAction.customAction(withDuration: duration) {(node, elapsedTime) in
            let fraction = elapsedTime / CGFloat(duration)
            let yOffset = height * 4 * fraction * (1 - fraction)
            node.position = CGPoint(x: originalPosition.x, y: originalPosition.y + yOffset)
        }
    }
}

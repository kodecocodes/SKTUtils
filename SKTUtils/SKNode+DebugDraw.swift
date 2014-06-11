/*
 * Copyright (c) 2013-2014 Razeware LLC
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

/** Disable debug drawing by setting this to false. Default value is true. */
var debugDrawEnabled = true

extension SKNode {
  /**
   * Draws a stroked path on top of this node.
   *
   * @return the debug shape
   */
  func attachDebugFrameFromPath(path: CGPathRef, color: SKColor) -> SKShapeNode? {
    if debugDrawEnabled {
      let shape = SKShapeNode()
      shape.path = path
      shape.strokeColor = color
      shape.lineWidth = 1.0
      shape.glowWidth = 0.0
      shape.antialiased = false
      self.addChild(shape)
      return shape
    }
    return nil
  }

  /**
   * Draws a stroked rectangle on top of this node.
   *
   * @return the debug shape
   */
  func attachDebugRectWithSize(size: CGSize, color: SKColor) -> SKShapeNode? {
    if debugDrawEnabled {
      let bodyPath = CGPathCreateWithRect(CGRectMake(-size.width/2.0, -size.height/2.0, size.width, size.height), nil)
      let shape = attachDebugFrameFromPath(bodyPath, color:color)
      CGPathRelease(bodyPath)
      return shape
    }
    return nil
  }

  /**
   * Draws a stroked circle on top of this node.
   *
   * @return the debug shape
   */
  func attachDebugCircleWithRadius(radius: CGFloat, color: SKColor) -> SKShapeNode? {
    if debugDrawEnabled {
      let path = UIBezierPath(ovalInRect: CGRectMake(-radius, -radius, radius*2.0, radius*2.0))
      return attachDebugFrameFromPath(path.CGPath, color: color)
    }
    return nil
  }

  /**
   * Draws a line on top of this node.
   *
   * @return the debug shape
   */
  func attachDebugLineFromPoint(startPoint: CGPoint, toPoint endPoint: CGPoint, color: SKColor) -> SKShapeNode? {
    if debugDrawEnabled {
      let path = UIBezierPath()
      path.moveToPoint(startPoint)
      path.addLineToPoint(endPoint)
      return attachDebugFrameFromPath(path.CGPath, color: color)
    }
    return nil
  }
}

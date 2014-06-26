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

/**
 * Allows you to perform actions with custom timing functions.
 *
 * Unfortunately, SKAction does not have a concept of a timing function, so
 * we need to replicate the actions using SKTEffect subclasses.
 */
class SKTEffect {
  /*unowned*/ var node: SKNode  // TODO: make unowned (crashes on beta 1)
  var duration: NSTimeInterval
  var timingFunction: ((CGFloat) -> CGFloat)?

  init(node: SKNode, duration: NSTimeInterval) {
    self.node = node
    self.duration = duration
    timingFunction = SKTTimingFunctionLinear
  }

  func update(t: CGFloat) {
    // subclasses implement this
  }
}

/**
 * Moves a node from its current position to a new position.
 */
class SKTMoveEffect: SKTEffect {
  var startPosition: CGPoint
  var delta: CGPoint
  var previousPosition: CGPoint
  
  init(node: SKNode, duration: NSTimeInterval, startPosition: CGPoint, endPosition: CGPoint) {
    previousPosition = node.position
    self.startPosition = startPosition
    delta = endPosition - startPosition
    super.init(node: node, duration: duration)
  }
  
  override func update(t: CGFloat) {
    // This allows multiple SKTMoveEffect objects to modify the same node
    // at the same time.
    let newPosition = startPosition + delta*t
    let diff = newPosition - previousPosition
    previousPosition = newPosition
    node.position += diff
  }
}

/**
 * Scales a node to a certain scale factor.
 */
class SKTScaleEffect: SKTEffect {
  var startScale: CGPoint
  var delta: CGPoint
  var previousScale: CGPoint

  init(node: SKNode, duration: NSTimeInterval, startScale: CGPoint, endScale: CGPoint) {
    previousScale = CGPoint(x: node.xScale, y: node.yScale)
    self.startScale = startScale
    delta = endScale - startScale
    super.init(node: node, duration: duration)
  }

  override func update(t: CGFloat) {
    let newScale = startScale + delta*t
    let diff = newScale / previousScale
    previousScale = newScale
    node.xScale *= diff.x
    node.yScale *= diff.y
  }
}

/**
 * Rotates a node to a certain angle.
 */
class SKTRotateEffect: SKTEffect {
  var startAngle: CGFloat
  var delta: CGFloat
  var previousAngle: CGFloat

  init(node: SKNode, duration: NSTimeInterval, startAngle: CGFloat, endAngle: CGFloat) {
    previousAngle = node.zRotation
    self.startAngle = startAngle
    delta = endAngle - startAngle
    super.init(node: node, duration: duration)
  }

  override func update(t: CGFloat) {
    let newAngle = startAngle + delta*t
    let diff = newAngle - previousAngle
    previousAngle = newAngle
    node.zRotation += diff
  }
}

/**
 * Wrapper that allows you to use SKTEffect objects as regular SKActions.
 */
extension SKAction {
  class func actionWithEffect(effect: SKTEffect) -> SKAction! {
    return SKAction.customActionWithDuration(effect.duration) {(node, elapsedTime) in
      var t = elapsedTime / CGFloat(effect.duration)

      if let timingFunction = effect.timingFunction {
        t = timingFunction(t)  // the magic happens here
      }

      effect.update(t)
    }
  }
}

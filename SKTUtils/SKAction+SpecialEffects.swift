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
   * Creates a screen shake animation.
   *
   * @param node The node to shake. You cannot apply this effect to an SKScene.
   * @param amount The vector by which the node is displaced.
   * @param oscillations The number of oscillations; 10 is a good value.
   * @param duration How long the effect lasts. Shorter is better.
   */
  public class func screenShakeWithNode(_ node: SKNode, amount: CGPoint, oscillations: Int, duration: TimeInterval) -> SKAction {
    let oldPosition = node.position
    let newPosition = oldPosition + amount
    
    let effect = SKTMoveEffect(node: node, duration: duration, startPosition: newPosition, endPosition: oldPosition)
    effect.timingFunction = SKTCreateShakeFunction(oscillations)

    return SKAction.actionWithEffect(effect)
  }

  /**
   * Creates a screen rotation animation.
   *
   * @param node You usually want to apply this effect to a pivot node that is
   *        centered in the scene. You cannot apply the effect to an SKScene.
   * @param angle The angle in radians.
   * @param oscillations The number of oscillations; 10 is a good value.
   * @param duration How long the effect lasts. Shorter is better.
   */
  public class func screenRotateWithNode(_ node: SKNode, angle: CGFloat, oscillations: Int, duration: TimeInterval) -> SKAction {
    let oldAngle = node.zRotation
    let newAngle = oldAngle + angle
    
    let effect = SKTRotateEffect(node: node, duration: duration, startAngle: newAngle, endAngle: oldAngle)
    effect.timingFunction = SKTCreateShakeFunction(oscillations)

    return SKAction.actionWithEffect(effect)
  }

  /**
   * Creates a screen zoom animation.
   *
   * @param node You usually want to apply this effect to a pivot node that is
   *        centered in the scene. You cannot apply the effect to an SKScene.
   * @param amount How much to scale the node in the X and Y directions.
   * @param oscillations The number of oscillations; 10 is a good value.
   * @param duration How long the effect lasts. Shorter is better.
   */
  public class func screenZoomWithNode(_ node: SKNode, amount: CGPoint, oscillations: Int, duration: TimeInterval) -> SKAction {
    let oldScale = CGPoint(x: node.xScale, y: node.yScale)
    let newScale = oldScale * amount
    
    let effect = SKTScaleEffect(node: node, duration: duration, startScale: newScale, endScale: oldScale)
    effect.timingFunction = SKTCreateShakeFunction(oscillations)

    return SKAction.actionWithEffect(effect)
  }

  /**
   * Causes the scene background to flash for duration seconds.
   */
  public class func colorGlitchWithScene(_ scene: SKScene, originalColor: SKColor, duration: TimeInterval) -> SKAction {
    return SKAction.customAction(withDuration: duration) {(node, elapsedTime) in
      if elapsedTime < CGFloat(duration) {
        scene.backgroundColor = SKColorWithRGB(Int.random(0...255), g: Int.random(0...255), b: Int.random(0...255))
      } else {
        scene.backgroundColor = originalColor
      }
    }
  }
}

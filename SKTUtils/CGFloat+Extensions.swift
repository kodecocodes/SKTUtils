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

import CoreGraphics

/** The value of π as a CGFloat */
let π = CGFloat(M_PI)

public extension CGFloat {
  /**
   * Converts an angle in degrees to radians.
   */
  public func degreesToRadians() -> CGFloat {
    return π * self / 180.0
  }

  /**
   * Converts an angle in radians to degrees.
   */
  public func radiansToDegrees() -> CGFloat {
    return self * 180.0 / π
  }

  /**
   * Ensures that the float value stays between the given values, inclusive.
   */
  public func clamped(v1: CGFloat, _ v2: CGFloat) -> CGFloat {
    let min = v1 < v2 ? v1 : v2
    let max = v1 > v2 ? v1 : v2
    return self < min ? min : (self > max ? max : self)
  }

  /**
   * Ensures that the float value stays between the given values, inclusive.
   */
  public mutating func clamp(v1: CGFloat, _ v2: CGFloat) -> CGFloat {
    self = clamped(v1, v2)
    return self
  }

  /**
   * Returns 1.0 if a floating point value is positive; -1.0 if it is negative.
   */
  public func sign() -> CGFloat {
    return (self >= 0.0) ? 1.0 : -1.0
  }

  /**
   * Returns a random floating point number between 0.0 and 1.0, inclusive.
   */
  public static func random() -> CGFloat {
    return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
  }

  /**
   * Returns a random floating point number in the range min...max, inclusive.
   */
  public static func random(#min: CGFloat, max: CGFloat) -> CGFloat {
    assert(min < max)
    return CGFloat.random() * (max - min) + min
  }

  /**
   * Randomly returns either 1.0 or -1.0.
   */
  public static func randomSign() -> CGFloat {
    return (arc4random_uniform(2) == 0) ? 1.0 : -1.0
  }
}

/**
 * Returns the shortest angle between two angles. The result is always between
 * -π and π.
 */
public func shortestAngleBetween(angle1: CGFloat, angle2: CGFloat) -> CGFloat {
    let twoπ = π * 2.0
    var angle = (angle2 - angle1) % twoπ
    if (angle >= π) {
        angle = angle - twoπ
    }
    if (angle <= -π) {
        angle = angle + twoπ
    }
    return angle
}

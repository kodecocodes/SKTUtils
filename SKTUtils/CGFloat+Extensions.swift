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

/** The value of π as a Float */
let π = CGFloat(M_PI)

// These functions are needed for 32-bit architectures
#if !(arch(x86_64) || arch(arm64))
func atan2(y: CGFloat, x: CGFloat) -> CGFloat {
  return atan2f(y, x)
}

func cos(a: CGFloat) -> CGFloat {
  return cosf(a)
}

func sin(a: CGFloat) -> CGFloat {
  return sinf(a)
}

func sqrt(a: CGFloat) -> CGFloat {
  return sqrtf(a)
}

func pow(x: CGFloat, y: CGFloat) -> CGFloat {
  return powf(x, y)
}
#endif

extension CGFloat {
  /**
   * Converts an angle in degrees to radians.
   */
  func degreesToRadians() -> CGFloat {
    return π * self / 180.0
  }

  /**
   * Converts an angle in radians to degrees.
   */
  func radiansToDegrees() -> CGFloat {
    return self * 180.0 / π
  }

  /**
   * Ensures that the float value stays with the range min...max, inclusive.
   */
  func clamped(#min: CGFloat, max: CGFloat) -> CGFloat {
    assert(min < max)
    return (self < min) ? min : ((self > max) ? max : self)
  }

  /**
   * Ensures that the float value stays with the range min...max, inclusive.
   */
  mutating func clamp(#min: CGFloat, max: CGFloat) -> CGFloat {
    self = clamped(min: min, max: max)
    return self
  }

// I'm not entire sure whether a range makes sense here. What does x..y mean?
// Do we clamp it to y-FLT_EPSILON ?
//
//  /**
//   * Ensures that the float value stays with the specified range.
//   */
//  func clamped(range: Range<Float>) -> CGFloat {
//    return (self < range.startIndex) ? range.startIndex : ((self > range.endIndex) ? range.endIndex : self)
//  }
//
//  /**
//   * Ensures that the float value stays with the specified range.
//   */
//  mutating func clamp(range: Range<CGFloat>) -> CGFloat {
//    self = clamped(range)
//    return self
//  }

  /**
   * Returns 1.0 if a floating point value is positive; -1.0 if it is negative.
   */
  func sign() -> CGFloat {
    return (self >= 0.0) ? 1.0 : -1.0
  }

  /**
   * Returns a random floating point number between 0.0 and 1.0, inclusive.
   */
  static func random() -> CGFloat {
    return CGFloat(arc4random()) / 0xFFFFFFFF
  }

  /**
   * Returns a random floating point number in the range min...max, inclusive.
   */
  static func random(#min: CGFloat, max: CGFloat) -> CGFloat {
    assert(min < max)
    return CGFloat.random() * (max - min) + min
  }

// NOTE: floating-point ranges are weird in Swift. x..y works OK, but x...y
// actually reports endIndex as y + 1. AFAICT there is no way to see whether
// the endIndex is inclusive or not. Reported as bug 17221898
//
//  /**
//   * Returns a random floating point number in the specified range.
//   */
//  static func random(range: Range<CGFloat>) -> CGFloat {
//    return CGFloat.random() * (range.endIndex - range.startIndex) + range.startIndex
//  }

  /**
   * Randomly returns either 1.0 or -1.0.
   */
  static func randomSign() -> CGFloat {
    return (arc4random_uniform(2) == 0) ? 1.0 : -1.0
  }
}

/**
 * Returns the shortest angle between two angles. The result is always between
 * -π and π.
 */
func shortestAngleBetween(angle1: CGFloat, angle2: CGFloat) -> CGFloat {
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

//func clamp<T: Comparable>(value: T, min: T, max: T) -> T {
//  return value < min ? min : value > max ? max : value
//}

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
import SpriteKit

extension CGPoint {
  /**
   * Creates a new CGPoint given a CGVector.
   */
  init(vector: CGVector) {
    self.init(x: vector.dx, y: vector.dy)
  }

  /**
   * Given an angle in radians, creates a vector of length 1.0 and returns the
   * result as a new CGPoint. An angle of 0 is assumed to point to the right.
   */
  init(angle: CGFloat) {
    return self.init(x: cos(angle), y: sin(angle))
  }

  /**
   * Adds (dx, dy) to the point.
   */
  mutating func offset(#dx: CGFloat, dy: CGFloat) -> CGPoint {
    x += dx
    y += dy
    return self
  }

  /**
   * Returns the length (magnitude) of the vector described by the CGPoint.
   */
  func length() -> CGFloat {
    return sqrt(x*x + y*y)
  }

  /**
   * Returns the squared length of the vector described by the CGPoint.
   */
  func lengthSquared() -> CGFloat {
    return x*x + y*y
  }

  /**
   * Normalizes the vector described by the CGPoint to length 1.0 and returns
   * the result as a new CGPoint.
   */
  func normalized() -> CGPoint {
    let len = length()
    return len>0 ? self / len : CGPoint.zeroPoint
  }

  /**
   * Normalizes the vector described by the CGPoint to length 1.0.
   */
  mutating func normalize() -> CGPoint {
    self = normalized()
    return self
  }

  /**
   * Calculates the distance between two CGPoints. Pythagoras!
   */
  func distanceTo(point: CGPoint) -> CGFloat {
    return (self - point).length()
  }

  /**
   * Returns the angle in radians of the vector described by the CGPoint.
   * The range of the angle is -π to π; an angle of 0 points to the right.
   */
  var angle: CGFloat {
    return atan2(y, x)
  }
}

/**
 * Adds two CGPoint values and returns the result as a new CGPoint.
 */
func + (left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

/**
 * Increments a CGPoint with the value of another.
 */
func += (inout left: CGPoint, right: CGPoint) {
  left = left + right
}

/**
 * Adds a CGVector to this CGPoint and returns the result as a new CGPoint.
 */
func + (left: CGPoint, right: CGVector) -> CGPoint {
  return CGPoint(x: left.x + right.dx, y: left.y + right.dy)
}

/**
 * Increments a CGPoint with the value of a CGVector.
 */
func += (inout left: CGPoint, right: CGVector) {
  left = left + right
}

/**
 * Subtracts two CGPoint values and returns the result as a new CGPoint.
 */
func - (left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

/**
 * Decrements a CGPoint with the value of another.
 */
func -= (inout left: CGPoint, right: CGPoint) {
  left = left - right
}

/**
 * Subtracts a CGVector from a CGPoint and returns the result as a new CGPoint.
 */
func - (left: CGPoint, right: CGVector) -> CGPoint {
  return CGPoint(x: left.x - right.dx, y: left.y - right.dy)
}

/**
 * Decrements a CGPoint with the value of a CGVector.
 */
func -= (inout left: CGPoint, right: CGVector) {
  left = left - right
}

/**
 * Multiplies two CGPoint values and returns the result as a new CGPoint.
 */
func * (left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x * right.x, y: left.y * right.y)
}

/**
 * Multiplies a CGPoint with another.
 */
func *= (inout left: CGPoint, right: CGPoint) {
  left = left * right
}

/**
 * Multiplies the x and y fields of a CGPoint with the same scalar value and
 * returns the result as a new CGPoint.
 */
func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
  return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

/**
 * Multiplies the x and y fields of a CGPoint with the same scalar value.
 */
func *= (inout point: CGPoint, scalar: CGFloat) {
  point = point * scalar
}

/**
 * Multiplies a CGPoint with a CGVector and returns the result as a new CGPoint.
 */
func * (left: CGPoint, right: CGVector) -> CGPoint {
  return CGPoint(x: left.x * right.dx, y: left.y * right.dy)
}

/**
 * Multiplies a CGPoint with a CGVector.
 */
func *= (inout left: CGPoint, right: CGVector) {
  left = left * right
}

/**
 * Divides two CGPoint values and returns the result as a new CGPoint.
 */
func / (left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x / right.x, y: left.y / right.y)
}

/**
 * Divides a CGPoint by another.
 */
func /= (inout left: CGPoint, right: CGPoint) {
  left = left / right
}

/**
 * Divides the x and y fields of a CGPoint by the same scalar value and returns
 * the result as a new CGPoint.
 */
func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
  return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

/**
 * Divides the x and y fields of a CGPoint by the same scalar value.
 */
func /= (inout point: CGPoint, scalar: CGFloat) {
  point = point / scalar
}

/**
 * Divides a CGPoint by a CGVector and returns the result as a new CGPoint.
 */
func / (left: CGPoint, right: CGVector) -> CGPoint {
  return CGPoint(x: left.x / right.dx, y: left.y / right.dy)
}

/**
 * Divides a CGPoint by a CGVector.
 */
func /= (inout left: CGPoint, right: CGVector) {
  left = left / right
}

/**
 * Performs a linear interpolation between two CGPoint values.
 */
func lerp(#start: CGPoint, #end: CGPoint, #t: CGFloat) -> CGPoint {
  return CGPoint(x: start.x + (end.x - start.x)*t, y: start.y + (end.y - start.y)*t)
}

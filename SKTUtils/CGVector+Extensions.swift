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

extension CGVector {
  /**
   * Creates a new CGVector given a CGPoint.
   */
  init(point: CGPoint) {
    self.init(dx: point.x, dy: point.y)
  }
  
  /**
   * Given an angle in radians, creates a vector of length 1.0 and returns the
   * result as a new CGVector. An angle of 0 is assumed to point to the right.
   */
  init(angle: CGFloat) {
    return self.init(dx: cos(angle), dy: sin(angle))
  }

  /**
   * Adds (dx, dy) to the vector.
   */
  mutating func offset(#dx: CGFloat, dy: CGFloat) -> CGVector {
    self.dx += dx
    self.dy += dy
    return self
  }

  /**
   * Returns a string with the vector's coordinates.
   *
   * Note: You don't really need this; simply doing println(vector) also works.
   */
  func description() -> String {
    return NSStringFromCGVector(self)
  }

  /**
   * Returns the length (magnitude) of the vector described by the CGVector.
   */
  func length() -> CGFloat {
    return sqrt(dx*dx + dy*dy)
  }

  /**
   * Returns the squared length of the vector described by the CGVector.
   */
  func lengthSquared() -> CGFloat {
    return dx*dx + dy*dy
  }

  /**
   * Normalizes the vector described by the CGVector to length 1.0 and returns
   * the result as a new CGVector.
   */
  func normalized() -> CGVector {
    return self / length()
  }

  /**
   * Normalizes the vector described by the CGVector to length 1.0.
   */
  mutating func normalize() -> CGVector {
    self = normalized()
    return self
  }

  /**
   * Calculates the distance between two CGVectors. Pythagoras!
   */
  func distanceTo(vector: CGVector) -> CGFloat {
    return (self - vector).length()
  }

  /**
   * Returns the angle in radians of the vector described by the CGVector.
   * The range of the angle is -π to π; an angle of 0 points to the right.
   */
  var angle: CGFloat {
    return atan2(dy, dx)
  }
}

/**
 * Adds two CGVector values and returns the result as a new CGVector.
 */
@infix func + (left: CGVector, right: CGVector) -> CGVector {
  return CGVector(dx: left.dx + right.dx, dy: left.dy + right.dy)
}

/**
 * Increments a CGVector with the value of another.
 */
@assignment func += (inout left: CGVector, right: CGVector) {
  left = left + right
}

/**
 * Subtracts two CGVector values and returns the result as a new CGVector.
 */
@infix func - (left: CGVector, right: CGVector) -> CGVector {
  return CGVector(dx: left.dx - right.dx, dy: left.dy - right.dy)
}

/**
 * Decrements a CGVector with the value of another.
 */
@assignment func -= (inout left: CGVector, right: CGVector) {
  left = left - right
}

/**
 * Multiplies two CGVector values and returns the result as a new CGVector.
 */
@infix func * (left: CGVector, right: CGVector) -> CGVector {
  return CGVector(dx: left.dx * right.dx, dy: left.dy * right.dy)
}

/**
 * Multiplies a CGVector with another.
 */
@assignment func *= (inout left: CGVector, right: CGVector) {
  left = left * right
}

/**
 * Multiplies the x and y fields of a CGVector with the same scalar value and
 * returns the result as a new CGVector.
 */
@infix func * (vector: CGVector, scalar: CGFloat) -> CGVector {
  return CGVector(dx: vector.dx * scalar, dy: vector.dy * scalar)
}

/**
 * Multiplies the x and y fields of a CGVector with the same scalar value.
 */
@assignment func *= (inout vector: CGVector, scalar: CGFloat) {
  vector = vector * scalar
}

/**
 * Divides two CGVector values and returns the result as a new CGVector.
 */
@infix func / (left: CGVector, right: CGVector) -> CGVector {
  return CGVector(dx: left.dx / right.dx, dy: left.dy / right.dy)
}

/**
 * Divides a CGVector by another.
 */
@assignment func /= (inout left: CGVector, right: CGVector) {
  left = left / right
}

/**
 * Divides the dx and dy fields of a CGVector by the same scalar value and
 * returns the result as a new CGVector.
 */
@infix func / (vector: CGVector, scalar: CGFloat) -> CGVector {
  return CGVector(dx: vector.dx / scalar, dy: vector.dy / scalar)
}

/**
 * Divides the dx and dy fields of a CGVector by the same scalar value.
 */
@assignment func /= (inout vector: CGVector, scalar: CGFloat) {
  vector = vector / scalar
}

/**
 * Performs a linear interpolation between two CGVector values.
 */
func lerp(#start: CGVector, #end: CGVector, #t: CGFloat) -> CGVector {
  return CGVector(dx: start.dx + (end.dx - start.dx)*t, dy: start.dy + (end.dy - start.dy)*t)
}

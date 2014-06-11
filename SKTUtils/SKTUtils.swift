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

/** The value of π as a Float */
let π = Float(M_PI)

/** The value of π/2 as a Float */
let Halfπ = Float(M_PI_2)

/** The value of 2π as a Float */
let Twoπ = Float(M_PI * 2.0)

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
  init(angle: Float) {
    return self.init(x: cosf(angle), y: sinf(angle))
  }

  /**
   * Adds (dx, dy) to the point.
   */
  mutating func offset(#dx: Float, dy: Float) -> CGPoint {
    x += dx
    y += dy
    return self
  }

  /**
   * Returns a string with the point's coordinates.
   *
   * Note: You don't really need this; simply doing println(point) also works.
   */
  func description() -> String {
    return NSStringFromCGPoint(self)
  }

  /**
   * Returns the length (magnitude) of the vector described by the CGPoint.
   */
  func length() -> Float {
    return sqrtf(x*x + y*y)
  }

  /**
   * Returns the squared length of the vector described by the CGPoint.
   */
  func lengthSquared() -> Float {
    return x*x + y*y
  }

  /**
   * Normalizes the vector described by the CGPoint to length 1.0 and returns
   * the result as a new CGPoint.
   */
  func normalized() -> CGPoint {
    return self / length()
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
  func distanceTo(point: CGPoint) -> Float {
    return (self - point).length()
  }

  /**
   * Returns the angle in radians of the vector described by the CGPoint.
   * The range of the angle is -π to π; an angle of 0 points to the right.
   */
  var angle: Float {
    return atan2f(y, x)
  }
}

/**
 * Adds two CGPoint values and returns the result as a new CGPoint.
 */
@infix func + (left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

/**
 * Increments a CGPoint with the value of another.
 */
@assignment func += (inout left: CGPoint, right: CGPoint) {
  left = left + right
}

/**
 * Subtracts two CGPoint values and returns the result as a new CGPoint.
 */
@infix func - (left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

/**
 * Decrements a CGPoint with the value of another.
 */
@assignment func -= (inout left: CGPoint, right: CGPoint) {
  left = left - right
}

/**
 * Multiplies two CGPoint values and returns the result as a new CGPoint.
 */
@infix func * (left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x * right.x, y: left.y * right.y)
}

/**
 * Multiplies a CGPoint with another.
 */
@assignment func *= (inout left: CGPoint, right: CGPoint) {
  left = left * right
}

/**
 * Multiplies the x and y fields of a CGPoint with the same scalar value and
 * returns the result as a new CGPoint.
 */
@infix func * (point: CGPoint, scalar: Float) -> CGPoint {
  return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

/**
 * Multiplies the x and y fields of a CGPoint with the same scalar value.
 */
@assignment func *= (inout point: CGPoint, scalar: Float) {
  point = point * scalar
}

/**
 * Divides two CGPoint values and returns the result as a new CGPoint.
 */
@infix func / (left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x / right.x, y: left.y / right.y)
}

/**
 * Divides a CGPoint by another.
 */
@assignment func /= (inout left: CGPoint, right: CGPoint) {
  left = left / right
}

/**
 * Divides the x and y fields of a CGPoint by the same scalar value and returns
 * the result as a new CGPoint.
 */
@infix func / (point: CGPoint, scalar: Float) -> CGPoint {
  return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

/**
 * Divides the x and y fields of a CGPoint by the same scalar value.
 */
@assignment func /= (inout point: CGPoint, scalar: Float) {
  point = point / scalar
}

/**
 * Performs a linear interpolation between two CGPoint values.
 */
func lerp(#start: CGPoint, #end: CGPoint, #t: Float) -> CGPoint {
  return CGPoint(x: start.x + (end.x - start.x)*t, y: start.y + (end.y - start.y)*t)
}

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
  init(angle: Float) {
    return self.init(dx: cosf(angle), dy: sinf(angle))
  }

  /**
   * Adds (dx, dy) to the vector.
   */
  mutating func offset(#dx: Float, dy: Float) -> CGVector {
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
  func length() -> Float {
    return sqrtf(dx*dx + dy*dy)
  }

  /**
   * Returns the squared length of the vector described by the CGVector.
   */
  func lengthSquared() -> Float {
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
  func distanceTo(vector: CGVector) -> Float {
    return (self - vector).length()
  }

  /**
   * Returns the angle in radians of the vector described by the CGVector.
   * The range of the angle is -π to π; an angle of 0 points to the right.
   */
  var angle: Float {
    return atan2f(dy, dx)
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
@infix func * (vector: CGVector, scalar: Float) -> CGVector {
  return CGVector(dx: vector.dx * scalar, dy: vector.dy * scalar)
}

/**
 * Multiplies the x and y fields of a CGVector with the same scalar value.
 */
@assignment func *= (inout vector: CGVector, scalar: Float) {
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
@infix func / (vector: CGVector, scalar: Float) -> CGVector {
  return CGVector(dx: vector.dx / scalar, dy: vector.dy / scalar)
}

/**
 * Divides the dx and dy fields of a CGVector by the same scalar value.
 */
@assignment func /= (inout vector: CGVector, scalar: Float) {
  vector = vector / scalar
}

/**
 * Performs a linear interpolation between two CGVector values.
 */
func lerp(#start: CGVector, #end: CGVector, #t: Float) -> CGVector {
  return CGVector(dx: start.dx + (end.dx - start.dx)*t, dy: start.dy + (end.dy - start.dy)*t)
}

extension Int {

  /**
   * Ensures that the integer value stays with the specified range.
   */
  func clamped(range: Range<Int>) -> Int {
    return (self < range.startIndex) ? range.startIndex : ((self >= range.endIndex) ? range.endIndex - 1: self)
  }

  /**
   * Ensures that the integer value stays with the specified range.
   */
  mutating func clamp(range: Range<Int>) -> Int {
    self = clamped(range)
    return self
  }

// Prefer to use the range version.
//
//  /**
//   * Ensures that the integer value stays with the range min...max, inclusive.
//   */
//  func clamped(#min: Int, max: Int) -> Int {
//    assert(min < max)
//    return (self < min) ? min : ((self > max) ? max : self)
//  }
//
//  /**
//   * Ensures that the integer value stays with the range min...max, inclusive.
//   */
//  mutating func clamp(#min: Int, max: Int) -> Int {
//    self = clamped(min: min, max: max)
//    return self
//  }

  /**
   * Returns a random integer in the specified range.
   */
  static func random(range: Range<Int>) -> Int {
    return Int(arc4random_uniform(UInt32(range.endIndex - range.startIndex))) + range.startIndex
  }

// Prefer to use the range version.
//
//  /**
//   * Returns a random integer between 0 and n-1.
//   */
//  static func random(n: Int) -> Int {
//    return Int(arc4random_uniform(UInt32(n)))
//  }
//
//  /**
//   * Returns a random integer in the range min...max, inclusive.
//   */
//  static func random(#min: Int, max: Int) -> Int {
//    assert(min < max)
//    return Int(arc4random_uniform(UInt32(max - min + 1))) + min
//  }
}

extension Float {
  /**
   * Converts an angle in degrees to radians.
   */
  func degreesToRadians() -> Float {
    return π * self / 180.0
  }

  /**
   * Converts an angle in radians to degrees.
   */
  func radiansToDegrees() -> Float {
    return self * 180.0 / π
  }

  /**
   * Ensures that the float value stays with the range min...max, inclusive.
   */
  func clamped(#min: Float, max: Float) -> Float {
    assert(min < max)
    return (self < min) ? min : ((self > max) ? max : self)
  }

  /**
   * Ensures that the float value stays with the range min...max, inclusive.
   */
  mutating func clamp(#min: Float, max: Float) -> Float {
    self = clamped(min: min, max: max)
    return self
  }

// I'm not entire sure whether a range makes sense here. What does x..y mean?
// Do we clamp it to y-FLT_EPSILON ?
//
//  /**
//   * Ensures that the float value stays with the specified range.
//   */
//  func clamped(range: Range<Float>) -> Float {
//    return (self < range.startIndex) ? range.startIndex : ((self > range.endIndex) ? range.endIndex : self)
//  }
//
//  /**
//   * Ensures that the float value stays with the specified range.
//   */
//  mutating func clamp(range: Range<Float>) -> Float {
//    self = clamped(range)
//    return self
//  }

  /**
   * Returns 1.0 if a floating point value is positive; -1.0 if it is negative.
   */
  func sign() -> Float {
    return (self >= 0.0) ? 1.0 : -1.0
  }

  /**
   * Returns a random floating point number between 0.0 and 1.0, inclusive.
   */
  static func random() -> Float {
    return Float(arc4random()) / 0xFFFFFFFF
  }

  /**
   * Returns a random floating point number in the range min...max, inclusive.
   */
  static func random(#min: Float, max: Float) -> Float {
    assert(min < max)
    return Float.random() * (max - min) + min
  }

// NOTE: floating-point ranges are weird in Swift. x..y works OK, but x...y
// actually reports endIndex as y + 1. AFAICT there is no way to see whether
// the endIndex is inclusive or not. Reported as bug 17221898
//
//  /**
//   * Returns a random floating point number in the specified range.
//   */
//  static func random(range: Range<Float>) -> Float {
//    return Float.random() * (range.endIndex - range.startIndex) + range.startIndex
//  }

  /**
   * Randomly returns either 1.0 or -1.0.
   */
  static func randomSign() -> Float {
    return (arc4random_uniform(2) == 0) ? 1.0 : -1.0
  }
}

/**
 * Returns the shortest angle between two angles. The result is always between
 * -π and π.
 */
func shortestAngleBetween(angle1: Float, angle2: Float) -> Float {
  let twoπ = π * 2.0
  let angle = (angle1 - angle2) % twoπ
  if (angle >= π) {
    return angle - twoπ
  } else if (angle <= -π) {
    return angle + twoπ
  } else {
    return angle
  }
}

extension SKColor {
  /**
   * Creates and returns a new SKColor object using RGB components specified as
   * values from 0 to 255.
   */
  convenience init(red: Int, green: Int, blue: Int) {
    return self.init(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1.0)
  }

  /**
   * Creates and returns a new SKColor object using RGB components specified as
   * values from 0 to 255, and alpha between 0.0 and 1.0.
   */
  convenience init(r: Int, g: Int, b: Int, a: Float) {
    return self.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: a)
  }

  // NOTE: calling it init(red: Int, green: Int, blue: Int, alpha: Float)
  // crashes Xcode! Reported as bug 17221567
}

//func clamp<T: Comparable>(value: T, min: T, max: T) -> T {
//  return value < min ? min : value > max ? max : value
//}

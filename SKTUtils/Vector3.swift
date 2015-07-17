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

public struct Vector3: Equatable {
  public var x: CGFloat
  public var y: CGFloat
  public var z: CGFloat
    
  public init(x: CGFloat, y: CGFloat, z: CGFloat) {
    self.x = x
    self.y = y
    self.z = z
  }
}

/**
 * Returns true if two vectors have the same element values.
 */
public func == (lhs: Vector3, rhs: Vector3) -> Bool {
  return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
}

/**
 * Returns true if all the vector elements are equal to the provided scalar.
 */
public func == (lhs: Vector3, rhs: CGFloat) -> Bool {
  return lhs.x == rhs && lhs.y == rhs && lhs.z == rhs
}

extension Vector3 {
  /**
   * A vector constant with value (0, 0, 0).
   */
  static var zeroVector: Vector3 {
    return Vector3(x: 0, y: 0, z: 0)
  }

  /**
   * Returns true if all the vector elements are equal to the provided value.
   *
   * DEPRECATED: Use the == operator instead.
   */
  public func equalToScalar(value: CGFloat) -> Bool {
    return x == value && y == value && z == value
  }
  
  /**
   * Returns the magnitude of the vector.
   */
  public func length() -> CGFloat {
    return sqrt(x*x + y*y + z*z)
  }
  
  /**
   * Normalizes the vector and returns the result as a new vector.
   */
  public func normalized() -> Vector3 {
    let scale = 1.0/length()
    return Vector3(x: x * scale, y: y * scale, z: z * scale)
  }
  
  /**
   * Normalizes the vector described by this Vector3 object.
   */
  public mutating func normalize() {
    let scale = 1.0/length()
    x *= scale
    y *= scale
    z *= scale
  }

  /**
   * Calculates the dot product with another Vector3.
   */
  public func dot(vector: Vector3) -> CGFloat {
    return Vector3.dotProduct(self, right: vector)
  }

  /**
   * Calculates the cross product with another Vector3.
   */
  public func cross(vector: Vector3) -> Vector3 {
    return Vector3.crossProduct(self, right: vector)
  }

  /**
   * Calculates the dot product of two vectors.
   *
   * DEPRECATED: Use dot() instead.
   */
  public static func dotProduct(left: Vector3, right: Vector3) -> CGFloat {
    return left.x * right.x + left.y * right.y + left.z * right.z
  }
  
  /**
   * Calculates the cross product of two vectors.
   *
   * DEPRECATED: Use cross() instead.
   */
  public static func crossProduct(left: Vector3, right: Vector3) -> Vector3 {
    let crossProduct = Vector3(x: left.y * right.z - left.z * right.y,
                               y: left.z * right.x - left.x * right.z,
                               z: left.x * right.y - left.y * right.x)
    return crossProduct
  }
}

/**
 * Adds two Vector3 values and returns the result as a new Vector3.
 */
public func + (left: Vector3, right: Vector3) -> Vector3 {
  return Vector3(x: left.x + right.x, y: left.y + right.y, z: left.z + right.z)
}

/**
 * Increments a Vector3 with the value of another.
 */
public func += (inout left: Vector3, right: Vector3) {
  left = left + right
}

/**
 * Subtracts two Vector3 values and returns the result as a new Vector3.
 */
public func - (left: Vector3, right: Vector3) -> Vector3 {
  return Vector3(x: left.x - right.x, y: left.y - right.y, z: left.z - right.z)
}

/**
 * Decrements a Vector3 with the value of another.
 */
public func -= (inout left: Vector3, right: Vector3) {
  left = left - right
}

/**
 * Multiplies two Vector3 values and returns the result as a new Vector3.
 */
public func * (left: Vector3, right: Vector3) -> Vector3 {
  return Vector3(x: left.x * right.x, y: left.y * right.y, z: left.z * right.z)
}

/**
 * Multiplies a Vector3 with another.
 */
public func *= (inout left: Vector3, right: Vector3) {
  left = left * right
}

/**
 * Multiplies the x,y,z fields of a Vector3 with the same scalar value and
 * returns the result as a new Vector3.
 */
public func * (vector: Vector3, scalar: CGFloat) -> Vector3 {
  return Vector3(x: vector.x * scalar, y: vector.y * scalar, z: vector.z * scalar)
}

/**
 * Multiplies the x,y,z fields of a Vector3 with the same scalar value.
 */
public func *= (inout vector: Vector3, scalar: CGFloat) {
  vector = vector * scalar
}

/**
 * Divides two Vector3 values and returns the result as a new Vector3.
 */
public func / (left: Vector3, right: Vector3) -> Vector3 {
  return Vector3(x: left.x / right.x, y: left.y / right.y, z: left.z / right.z)
}

/**
 * Divides a Vector3 by another.
 */
public func /= (inout left: Vector3, right: Vector3) {
  left = left / right
}

/**
 * Divides the x,y,z fields of a Vector3 by the same scalar value and
 * returns the result as a new Vector3.
 */
public func / (vector: Vector3, scalar: CGFloat) -> Vector3 {
  return Vector3(x: vector.x / scalar, y: vector.y / scalar, z: vector.z / scalar)
}

/**
 * Divides the x,y,z fields of a Vector3 by the same scalar value.
 */
public func /= (inout vector: Vector3, scalar: CGFloat) {
  vector = vector / scalar
}

/**
 * Performs a linear interpolation between two Vector3 values.
 */
public func lerp(start start: Vector3, end: Vector3, t: CGFloat) -> Vector3 {
  return start + (end - start) * t
}

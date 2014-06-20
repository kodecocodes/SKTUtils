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

struct Vector3: Equatable {
  var x: CGFloat
  var y: CGFloat
  var z: CGFloat
    
  init(x: CGFloat, y: CGFloat, z: CGFloat) {
    self.x = x
    self.y = y
    self.z = z
  }
}

func == (lhs: Vector3, rhs: Vector3) -> Bool {
  return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
}

extension Vector3 {
  /**
   * Returns true if all the vector elements are equal to the provided value.
   */
  func equalToScalar(value: CGFloat) -> Bool {
    return x == value && y == value && z == value
  }
  
  /**
   * Returns the magnitude of the vector.
   **/
  func length() -> CGFloat {
    return sqrt(x*x + y*y + z*z)
  }
  
  /**
   * Normalizes the vector and returns the result as a new vector.
   */
  func normalized() -> Vector3 {
    let scale = 1.0/length()
    return Vector3(x: x * scale, y: y * scale, z: z * scale)
  }
  
  /**
   * Normalizes the vector described by this Vector3 object.
   */
  mutating func normalize() {
    let scale = 1.0/length()
    x *= scale
    y *= scale
    z *= scale
  }
  
  /**
   * Calculates the dot product of two vectors.
   */
  static func dotProduct(left: Vector3, right: Vector3) -> CGFloat {
    return left.x * right.x + left.y * right.y + left.z * right.z
  }
  
  /**
   * Calculates the cross product of two vectors.
   */
  static func crossProduct(left: Vector3, right: Vector3) -> Vector3 {
    let crossProduct = Vector3(x: left.y * right.z - left.z * right.y,
                               y: left.z * right.x - left.x * right.z,
                               z: left.x * right.y - left.y * right.x)
    return crossProduct
  }
}

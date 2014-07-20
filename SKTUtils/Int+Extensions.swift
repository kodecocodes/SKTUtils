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

  /**
   * Ensures that the integer value stays between the given values, inclusive.
   */
  func clamped(v1: Int, _ v2: Int) -> Int {
    let min = v1 < v2 ? v1 : v2
    let max = v1 > v2 ? v1 : v2
    return self < min ? min : (self > max ? max : self)
  }

  /**
   * Ensures that the integer value stays between the given values, inclusive.
   */
  mutating func clamp(v1: Int, _ v2: Int) -> Int {
    self = clamped(v1, v2)
    return self
  }

  /**
   * Returns a random integer in the specified range.
   */
  static func random(range: Range<Int>) -> Int {
    return Int(arc4random_uniform(UInt32(range.endIndex - range.startIndex))) + range.startIndex
  }

  /**
   * Returns a random integer between 0 and n-1.
   */
  static func random(n: Int) -> Int {
    return Int(arc4random_uniform(UInt32(n)))
  }

  /**
   * Returns a random integer in the range min...max, inclusive.
   */
  static func random(#min: Int, max: Int) -> Int {
    assert(min < max)
    return Int(arc4random_uniform(UInt32(max - min + 1))) + min
  }
}


import XCTest
import CoreGraphics
import SpriteKit

class CGVectorTests: XCTestCase {
  var v1 = CGVector(dx: 100, dy: 50)
  let v2 = CGVector(dx: 10, dy: 5)

  func testAddingTwoVectors() {
    XCTAssertEqual(v1 + v2, CGVector(dx: 110, dy: 55))
  }

  func testAddingVectorToVector() {
    v1 += v2
    XCTAssertEqual(v1, CGVector(dx: 110, dy: 55))
  }

  func testSubtractingTwoVectors() {
    XCTAssertEqual(v1 - v2, CGVector(dx: 90, dy: 45))
  }

  func testSubtractingVectorFromVector() {
    v1 -= v2
    XCTAssertEqual(v1, CGVector(dx: 90, dy: 45))
  }

  func testMultiplyingTwoVectors() {
    XCTAssertEqual(v1 * v2, CGVector(dx: 1000, dy: 250))
  }

  func testMultiplyingVectorByVector() {
    v1 *= v2
    XCTAssertEqual(v1, CGVector(dx: 1000, dy: 250))
  }

  func testMultiplyingVectorAndFloat() {
    XCTAssertEqual(v1 * 2.5, CGVector(dx: 250, dy: 125))
  }

  func testMultiplyingVectorByFloat() {
    v1 *= 2.5
    XCTAssertEqual(v1, CGVector(dx: 250, dy: 125))
  }

  func testDividingTwoVectors() {
    XCTAssertEqual(v1 / v2, CGVector(dx: 10, dy: 10))
  }

  func testDividingVectorByVector() {
    v1 /= v2
    XCTAssertEqual(v1, CGVector(dx: 10, dy: 10))
  }

  func testDividingVectorAndFloat() {
    XCTAssertEqual(v1 / 2.5, CGVector(dx: 40, dy: 20))
  }

  func testDividingVectorByFloat() {
    v1 /= 2.5
    XCTAssertEqual(v1, CGVector(dx: 40, dy: 20))
  }

  func testOffsettingVector() {
    v1.offset(dx: 10, dy: 5)
    XCTAssertEqual(v1, CGVector(dx: 110, dy: 55))
  }

  func testThatOffsetReturnsNewValue() {
    XCTAssertEqual(v1.offset(dx: 10, dy: 5), v1)
  }

  func testInitWithPoint() {
    let pt = CGPoint(x: -10, y: -20)
    let v = CGVector(point: pt)
    XCTAssertEqual(v.dx, pt.x)
    XCTAssertEqual(v.dy, pt.y)
  }
  
  func testInitWithZeroDegreeAngle() {
    let a: CGFloat = 0
    let v = CGVector(angle: a)
    XCTAssertEqual(v.dx, 1.0)
    XCTAssertEqual(v.dy, 0.0)
  }

  func testInitWith45DegreeAngle() {
    let a = π/4.0
    let v = CGVector(angle: a)
    XCTAssertEqualWithAccuracy(v.dx, 1.0/sqrt(2.0), CGFloat(FLT_EPSILON))
    XCTAssertEqualWithAccuracy(v.dy, 1.0/sqrt(2.0), CGFloat(FLT_EPSILON))
  }

  func testInitWith90DegreeAngle() {
    let a = π/2.0
    let v = CGVector(angle: a)
    XCTAssertEqualWithAccuracy(v.dx, 0.0, CGFloat(FLT_EPSILON))
    XCTAssertEqual(v.dy, 1.0)
  }

  func testInitWith180DegreeAngle() {
    let a = π
    let v = CGVector(angle: a)
    XCTAssertEqual(v.dx, -1.0)
    XCTAssertEqualWithAccuracy(v.dy, 0.0, CGFloat(FLT_EPSILON))
  }

  func testInitWithMinus135DegreeAngle() {
    let a = -3.0*π/4.0
    let v = CGVector(angle: a)
    XCTAssertEqualWithAccuracy(v.dx, -1.0/sqrt(2.0), CGFloat(FLT_EPSILON))
    XCTAssertEqualWithAccuracy(v.dy, -1.0/sqrt(2.0), CGFloat(FLT_EPSILON))
  }

  func testZeroDegreeAngle() {
    let v = CGVector(dx: 1.0, dy: 0.0)
    XCTAssertEqual(v.angle, 0)
  }

  func test45DegreeAngle() {
    let v = CGVector(dx: 1.0/sqrt(2.0), dy: 1.0/sqrt(2.0))
    XCTAssertEqual(v.angle, π/4.0)
  }

  func test90DegreeAngle() {
    let v = CGVector(dx: 0.0, dy: 1.0)
    XCTAssertEqual(v.angle, π/2.0)
  }

  func test180DegreeAngle() {
    let v = CGVector(dx: -1.0, dy: 0.0)
    XCTAssertEqualWithAccuracy(v.angle, π, 1.0e-6)
  }

  func testMinus135DegreeAngle() {
    let v = CGVector(dx: -1.0/sqrt(2.0), dy: -1.0/sqrt(2.0))
    XCTAssertEqualWithAccuracy(v.angle, -3.0*π/4.0, CGFloat(FLT_EPSILON))
  }

  func testLengthHorizontalUnitVector() {
    let v = CGVector(dx: 1.0, dy: 0.0)
    XCTAssertEqual(v.length(), 1.0)
  }

  func testLengthVerticalUnitVector() {
    let v = CGVector(dx: 0.0, dy: 1.0)
    XCTAssertEqual(v.length(), 1.0)
  }

  func testLength() {
    let v = CGVector(dx: 1.0, dy: 1.0)
    XCTAssertEqual(v.length(), sqrt(2.0))
  }

  func testLengthIsPositive() {
    let v = CGVector(dx: -1.0, dy: -1.0)
    XCTAssertEqual(v.length(), sqrt(2.0))
  }

  func testLengthSquared() {
    let v = CGVector(dx: 1.0, dy: 1.0)
    XCTAssertEqual(v.lengthSquared(), 2.0)
  }

  func testDistance() {
    XCTAssertEqualWithAccuracy(v1.distanceTo(v2), 100.6230589874, CGFloat(FLT_EPSILON))
  }

  func testThatLengthEqualsDistance() {
    XCTAssertEqualWithAccuracy(v1.distanceTo(v2), (v1 - v2).length(), CGFloat(FLT_EPSILON))
  }

  func testNormalized() {
    let normalized = v1.normalized()
    XCTAssertEqualWithAccuracy(normalized.dx, 2.0/sqrt(5.0), CGFloat(FLT_EPSILON))
    XCTAssertEqualWithAccuracy(normalized.dy, 1.0/sqrt(5.0), CGFloat(FLT_EPSILON))
  }

  func testThatNormalizedDoesNotChangeOriginalValue() {
    let old = v1
    let normalized = v1.normalized()
    XCTAssertEqual(v1.dx, old.dx)
    XCTAssertEqual(v1.dy, old.dy)
  }

  func testThatNormalizeReturnsNewValue() {
    v1.normalize()
    XCTAssertEqualWithAccuracy(v1.dx, 2.0/sqrt(5.0), CGFloat(FLT_EPSILON))
    XCTAssertEqualWithAccuracy(v1.dy, 1.0/sqrt(5.0), CGFloat(FLT_EPSILON))
  }

  func testThatNormalizingKeepsSameAngle() {
    let angle = v1.angle
    XCTAssertEqual(angle, v1.normalize().angle)
  }

  func testLerp() {
    let start = CGVector(dx: -100, dy: -75)
    let end = CGVector(dx: 100, dy: 25)

    let expected = [
      CGVector(dx: -100, dy: -75),
      CGVector(dx: -80, dy: -65),
      CGVector(dx: -60, dy: -55),
      CGVector(dx: -40, dy: -45),
      CGVector(dx: -20, dy: -35),
      CGVector(dx: 0, dy: -25),
      CGVector(dx: 20, dy: -15),
      CGVector(dx: 40, dy: -5),
      CGVector(dx: 60, dy: 5),
      CGVector(dx: 80, dy: 15),
      CGVector(dx: 100, dy: 25)
      ]

    var i = 0
    for var t = 0.0; t <= 1.0; t += 0.1, ++i {
      let lerped = lerp(start: start, end: end, t: CGFloat(t))
      XCTAssertEqualWithAccuracy(lerped.dx, expected[i].dx, 1.0e6)
      XCTAssertEqualWithAccuracy(lerped.dy, expected[i].dy, 1.0e6)
    }
  }
}

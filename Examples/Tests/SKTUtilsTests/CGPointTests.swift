
import XCTest
import CoreGraphics
import SpriteKit

class CGPointTests: XCTestCase {
  var pt1 = CGPoint(x: 100, y: 50)
  let pt2 = CGPoint(x: 10, y: 5)
  let v = CGVector(dx: 2, dy: 0.5)

  func testAddingTwoPoints() {
    XCTAssertEqual(pt1 + pt2, CGPoint(x: 110, y: 55))
  }

  func testAddingPointToPoint() {
    pt1 += pt2
    XCTAssertEqual(pt1, CGPoint(x: 110, y: 55))
  }

  func testAddingVectorToPoint() {
    pt1 += v
    XCTAssertEqual(pt1, CGPoint(x: 102, y: 50.5))
  }

  func testSubtractingTwoPoints() {
    XCTAssertEqual(pt1 - pt2, CGPoint(x: 90, y: 45))
  }

  func testSubtractingPointFromPoint() {
    pt1 -= pt2
    XCTAssertEqual(pt1, CGPoint(x: 90, y: 45))
  }

  func testSubtractingVectorFromPoint() {
    pt1 -= v
    XCTAssertEqual(pt1, CGPoint(x: 98, y: 49.5))
  }

  func testMultiplyingTwoPoints() {
    XCTAssertEqual(pt1 * pt2, CGPoint(x: 1000, y: 250))
  }

  func testMultiplyingPointByPoint() {
    pt1 *= pt2
    XCTAssertEqual(pt1, CGPoint(x: 1000, y: 250))
  }

  func testMultiplyingPointAndFloat() {
    XCTAssertEqual(pt1 * 2.5, CGPoint(x: 250, y: 125))
  }

  func testMultiplyingPointByFloat() {
    pt1 *= 2.5
    XCTAssertEqual(pt1, CGPoint(x: 250, y: 125))
  }

  func testMultiplyingPointAndVector() {
    XCTAssertEqual(pt1 * v, CGPoint(x: 200, y: 25))
  }

  func testMultiplyingPointByVector() {
    pt1 *= v
    XCTAssertEqual(pt1, CGPoint(x: 200, y: 25))
  }

  func testDividingTwoPoints() {
    XCTAssertEqual(pt1 / pt2, CGPoint(x: 10, y: 10))
  }

  func testDividingPointByPoint() {
    pt1 /= pt2
    XCTAssertEqual(pt1, CGPoint(x: 10, y: 10))
  }

  func testDividingPointAndFloat() {
    XCTAssertEqual(pt1 / 2.5, CGPoint(x: 40, y: 20))
  }

  func testDividingPointByFloat() {
    pt1 /= 2.5
    XCTAssertEqual(pt1, CGPoint(x: 40, y: 20))
  }

  func testDividingPointAndVector() {
    XCTAssertEqual(pt1 / v, CGPoint(x: 50, y: 100))
  }

  func testDividingPointByVector() {
    pt1 /= v
    XCTAssertEqual(pt1, CGPoint(x: 50, y: 100))
  }

  func testOffsettingPoint() {
    pt1.offset(dx: 10, dy: 5)
    XCTAssertEqual(pt1, CGPoint(x: 110, y: 55))
  }

  func testThatOffsetReturnsNewValue() {
    XCTAssertEqual(pt1.offset(dx: 10, dy: 5), pt1)
  }

  func testInitWithVector() {
    let v = CGVector(dx: -10, dy: -20)
    let pt = CGPoint(vector: v)
    XCTAssertEqual(v.dx, pt.x)
    XCTAssertEqual(v.dy, pt.y)
  }
  
  func testInitWithZeroDegreeAngle() {
    let a: CGFloat = 0
    let pt = CGPoint(angle: a)
    XCTAssertEqual(pt.x, CGFloat(1.0))
    XCTAssertEqual(pt.y, CGFloat(0.0))
  }

  func testInitWith45DegreeAngle() {
    let a = π/4.0
    let pt = CGPoint(angle: a)
    XCTAssertEqualWithAccuracy(pt.x, 1.0/sqrt(2.0), accuracy: CGFloat(FLT_EPSILON))
    XCTAssertEqualWithAccuracy(pt.y, 1.0/sqrt(2.0), accuracy: CGFloat(FLT_EPSILON))
  }

  func testInitWith90DegreeAngle() {
    let a = π/2.0
    let pt = CGPoint(angle: a)
    XCTAssertEqualWithAccuracy(pt.x, CGFloat(0.0), accuracy: CGFloat(FLT_EPSILON))
    XCTAssertEqual(pt.y, CGFloat(1.0))
  }

  func testInitWith180DegreeAngle() {
    let a = π
    let pt = CGPoint(angle: a)
    XCTAssertEqual(pt.x, -1.0)
    XCTAssertEqualWithAccuracy(pt.y, CGFloat(0.0), accuracy: CGFloat(FLT_EPSILON))
  }

  func testInitWithMinus135DegreeAngle() {
    let a = -3.0*π/4.0
    let pt = CGPoint(angle: a)
    XCTAssertEqualWithAccuracy(pt.x, -1.0/sqrt(2.0), accuracy: CGFloat(FLT_EPSILON))
    XCTAssertEqualWithAccuracy(pt.y, -1.0/sqrt(2.0), accuracy: CGFloat(FLT_EPSILON))
  }

  func testZeroDegreeAngle() {
    let pt = CGPoint(x: 1.0, y: 0.0)
    XCTAssertEqual(pt.angle, CGFloat(0))
  }

  func test45DegreeAngle() {
    let pt = CGPoint(x: 1.0/sqrt(2.0), y: 1.0/sqrt(2.0))
    XCTAssertEqual(pt.angle, π/4.0)
  }

  func test90DegreeAngle() {
    let pt = CGPoint(x: 0.0, y: 1.0)
    XCTAssertEqual(pt.angle, π/2.0)
  }

  func test180DegreeAngle() {
    let pt = CGPoint(x: -1.0, y: 0.0)
    XCTAssertEqualWithAccuracy(pt.angle, π, accuracy: 1.0e-6)
  }

  func testMinus135DegreeAngle() {
    let pt = CGPoint(x: -1.0/sqrt(2.0), y: -1.0/sqrt(2.0))
    XCTAssertEqualWithAccuracy(pt.angle, -3.0*π/4.0, accuracy: CGFloat(FLT_EPSILON))
  }

  func testLengthHorizontalUnitVector() {
    let pt = CGPoint(x: 1.0, y: 0.0)
    XCTAssertEqual(pt.length(), CGFloat(1.0))
  }

  func testLengthVerticalUnitVector() {
    let pt = CGPoint(x: 0.0, y: 1.0)
    XCTAssertEqual(pt.length(), CGFloat(1.0))
  }
  
  func testLength() {
    let pt = CGPoint(x: 1.0, y: 1.0)
    XCTAssertEqual(pt.length(), sqrt(2.0))
  }

  func testLengthIsPositive() {
    let pt = CGPoint(x: -1.0, y: -1.0)
    XCTAssertEqual(pt.length(), sqrt(2.0))
  }

  func testLengthSquared() {
    let pt = CGPoint(x: 1.0, y: 1.0)
    XCTAssertEqual(pt.lengthSquared(), CGFloat(2.0))
  }

  func testDistance() {
    XCTAssertEqualWithAccuracy(pt1.distanceTo(pt2), CGFloat(100.6230589874), accuracy: CGFloat(FLT_EPSILON))
  }

  func testThatLengthEqualsDistance() {
    XCTAssertEqualWithAccuracy(pt1.distanceTo(pt2), (pt1 - pt2).length(), accuracy: CGFloat(FLT_EPSILON))
  }

  func testNormalized() {
    let normalized = pt1.normalized()
    XCTAssertEqualWithAccuracy(normalized.x, 2.0/sqrt(5.0), accuracy: CGFloat(FLT_EPSILON))
    XCTAssertEqualWithAccuracy(normalized.y, 1.0/sqrt(5.0), accuracy: CGFloat(FLT_EPSILON))
  }

  func testThatNormalizedDoesNotChangeOriginalValue() {
    let old = pt1
    _ = pt1.normalized()
    XCTAssertEqual(pt1.x, old.x)
    XCTAssertEqual(pt1.y, old.y)
  }

  func testThatNormalizeReturnsNewValue() {
    pt1.normalize()
    XCTAssertEqualWithAccuracy(pt1.x, 2.0/sqrt(5.0), accuracy: CGFloat(FLT_EPSILON))
    XCTAssertEqualWithAccuracy(pt1.y, 1.0/sqrt(5.0), accuracy: CGFloat(FLT_EPSILON))
  }
  
  func testThatNormalizingKeepsSameAngle() {
    let angle = pt1.angle
    XCTAssertEqual(angle, pt1.normalize().angle)
  }

  func testLerp() {
    let start = CGPoint(x: -100, y: -75)
    let end = CGPoint(x: 100, y: 25)

    let expected = [
      CGPoint(x: -100, y: -75),
      CGPoint(x: -80, y: -65),
      CGPoint(x: -60, y: -55),
      CGPoint(x: -40, y: -45),
      CGPoint(x: -20, y: -35),
      CGPoint(x: 0, y: -25),
      CGPoint(x: 20, y: -15),
      CGPoint(x: 40, y: -5),
      CGPoint(x: 60, y: 5),
      CGPoint(x: 80, y: 15),
      CGPoint(x: 100, y: 25)
      ]

    var i = 0
    for t in 0.0.stride(through: 1.0, by: 0.1) {
      let lerped = lerp(start: start, end: end, t: CGFloat(t))
      print("\(i), \(t)")
      XCTAssertEqualWithAccuracy(lerped.x, expected[i].x, accuracy: 1.0e6)
      XCTAssertEqualWithAccuracy(lerped.y, expected[i].y, accuracy: 1.0e6)
      i += 1
    }
  }
}

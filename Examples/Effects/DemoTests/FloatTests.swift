
import XCTest
import CoreGraphics

class FloatTests: XCTestCase {

  func testClamped() {
    XCTAssertEqual(CGFloat(10).clamped(min: -5, max: 6), 6)
    XCTAssertEqual(CGFloat(7).clamped(min: -5, max: 6), 6)
    XCTAssertEqual(CGFloat(6).clamped(min: -5, max: 6), 6)
    XCTAssertEqual(CGFloat(5).clamped(min: -5, max: 6), 5)
    XCTAssertEqual(CGFloat(1).clamped(min: -5, max: 6), 1)
    XCTAssertEqual(CGFloat(0).clamped(min: -5, max: 6), 0)
    XCTAssertEqual(CGFloat(-4).clamped(min: -5, max: 6), -4)
    XCTAssertEqual(CGFloat(-5).clamped(min: -5, max: 6), -5)
    XCTAssertEqual(CGFloat(-6).clamped(min: -5, max: 6), -5)
    XCTAssertEqual(CGFloat(-10).clamped(min: -5, max: 6), -5)
  }

  func testThatClampedDoesNotChangeOriginalValue() {
    let original: CGFloat = 50
    let clamped = original.clamped(min: 100, max: 200)
    XCTAssertEqual(original, 50)
  }

  func testThatClampReturnsNewValue() {
    var original: CGFloat = 50
    original.clamp(min: 100, max: 200)
    XCTAssertEqual(original, 100)
  }

  func testThatRandomStaysBetweenOneAndZero() {
    for i in 0..1000 {
      let value = CGFloat.random()
      XCTAssert(value >= 0 && value <= 1)
    }
  }

  func testThatRandomStaysInRange() {
    for i in 0..1000 {
      let value = CGFloat.random(min: -10, max: 10)
      XCTAssert(value >= -10 && value <= 10)
    }
  }

  func testThatRandomSignIsMinusOrPlusOne() {
    for i in 0..1000 {
      let value = CGFloat.randomSign()
      XCTAssert(value == -1.0 || value == 1.0)
    }
  }
  
  func testSign() {
    XCTAssertEqual(CGFloat(-100.0).sign(), -1.0)
    XCTAssertEqual(CGFloat(100.0).sign(), 1.0)
    XCTAssertEqual(CGFloat(0.0).sign(), 1.0)
  }

  func testDegreesToRadians() {
    XCTAssertEqualWithAccuracy(CGFloat(0).degreesToRadians(), 0, CGFloat(FLT_EPSILON))
    XCTAssertEqualWithAccuracy(CGFloat(45).degreesToRadians(), π/4, CGFloat(FLT_EPSILON))
    XCTAssertEqualWithAccuracy(CGFloat(90).degreesToRadians(), π/2, CGFloat(FLT_EPSILON))
    XCTAssertEqualWithAccuracy(CGFloat(135).degreesToRadians(), 3*π/4, CGFloat(FLT_EPSILON))
    XCTAssertEqualWithAccuracy(CGFloat(180).degreesToRadians(), π, CGFloat(FLT_EPSILON))
    XCTAssertEqualWithAccuracy(CGFloat(-135).degreesToRadians(), -3*π/4, CGFloat(FLT_EPSILON))
    XCTAssertEqualWithAccuracy(CGFloat(-90).degreesToRadians(), -π/2, CGFloat(FLT_EPSILON))
    XCTAssertEqualWithAccuracy(CGFloat(-45).degreesToRadians(), -π/4, CGFloat(FLT_EPSILON))
  }

  func testRadiansToDegrees() {
    XCTAssertEqualWithAccuracy(CGFloat(0).radiansToDegrees(), CGFloat(0), CGFloat(FLT_EPSILON))
    XCTAssertEqualWithAccuracy((π/4).radiansToDegrees(), CGFloat(45), CGFloat(FLT_EPSILON))
    XCTAssertEqualWithAccuracy((π/2).radiansToDegrees(), CGFloat(90), CGFloat(FLT_EPSILON))
    XCTAssertEqualWithAccuracy((3*π/4).radiansToDegrees(), CGFloat(135), CGFloat(FLT_EPSILON))
    XCTAssertEqualWithAccuracy(π.radiansToDegrees(), CGFloat(180), CGFloat(FLT_EPSILON))
    XCTAssertEqualWithAccuracy((-3*π/4).radiansToDegrees(), CGFloat(-135), CGFloat(FLT_EPSILON))
    XCTAssertEqualWithAccuracy((-π/2).radiansToDegrees(), CGFloat(-90), CGFloat(FLT_EPSILON))
    XCTAssertEqualWithAccuracy((-π/4).radiansToDegrees(), CGFloat(-45), CGFloat(FLT_EPSILON))
  }

  func testAllAngles() {
    for var angle: CGFloat = -360; angle <= 360; angle += 0.5 {
      let radians = angle.degreesToRadians()
      XCTAssertEqualWithAccuracy(radians.radiansToDegrees(), angle, 1.0e6)
    }
  }

  func testShortestAngleBetween() {
    // TODO!
  }
}

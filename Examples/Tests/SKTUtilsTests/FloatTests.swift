
import XCTest
import CoreGraphics

class FloatTests: XCTestCase {

  func testClamped() {
    XCTAssertEqual(CGFloat(10).clamped(-5, 6), CGFloat(6))
    XCTAssertEqual(CGFloat(7).clamped(-5, 6), CGFloat(6))
    XCTAssertEqual(CGFloat(6).clamped(-5, 6), CGFloat(6))
    XCTAssertEqual(CGFloat(5).clamped(-5, 6), CGFloat(5))
    XCTAssertEqual(CGFloat(1).clamped(-5, 6), CGFloat(1))
    XCTAssertEqual(CGFloat(0).clamped(-5, 6), CGFloat(0))
    XCTAssertEqual(CGFloat(-4).clamped(-5, 6), CGFloat(-4))
    XCTAssertEqual(CGFloat(-5).clamped(-5, 6), CGFloat(-5))
    XCTAssertEqual(CGFloat(-6).clamped(-5, 6), CGFloat(-5))
    XCTAssertEqual(CGFloat(-10).clamped(-5, 6), CGFloat(-5))
  }

  func testClampedReverseOrder() {
    XCTAssertEqual(CGFloat(10).clamped(6, -5), CGFloat(6))
    XCTAssertEqual(CGFloat(7).clamped(6, -5), CGFloat(6))
    XCTAssertEqual(CGFloat(6).clamped(6, -5), CGFloat(6))
    XCTAssertEqual(CGFloat(5).clamped(6, -5), CGFloat(5))
    XCTAssertEqual(CGFloat(1).clamped(6, -5), CGFloat(1))
    XCTAssertEqual(CGFloat(0).clamped(6, -5), CGFloat(0))
    XCTAssertEqual(CGFloat(-4).clamped(6, -5), CGFloat(-4))
    XCTAssertEqual(CGFloat(-5).clamped(6, -5), CGFloat(-5))
    XCTAssertEqual(CGFloat(-6).clamped(6, -5), CGFloat(-5))
    XCTAssertEqual(CGFloat(-10).clamped(6, -5), CGFloat(-5))
  }

  func testThatClampedDoesNotChangeOriginalValue() {
    let original: CGFloat = 50
    _ = original.clamped(100, 200)
    XCTAssertEqual(original, CGFloat(50))
  }

  func testThatClampReturnsNewValue() {
    var original: CGFloat = 50
    original.clamp(100, 200)
    XCTAssertEqual(original, CGFloat(100))
  }

  func testThatRandomStaysBetweenOneAndZero() {
    for _ in 0..<1000 {
      let value = CGFloat.random()
      XCTAssert(value >= 0 && value <= 1)
    }
  }

  func testThatRandomStaysInRange() {
    for _ in 0..<1000 {
      let value = CGFloat.random(min: -10, max: 10)
      XCTAssert(value >= -10 && value <= 10)
    }
  }

  func testThatRandomSignIsMinusOrPlusOne() {
    for _ in 0..<1000 {
      let value = CGFloat.randomSign()
      XCTAssert(value == -1.0 || value == 1.0)
    }
  }
  
  func testSign() {
    XCTAssertEqual(CGFloat(-100.0).sign(), -1.0)
    XCTAssertEqual(CGFloat(100.0).sign(), CGFloat(1.0))
    XCTAssertEqual(CGFloat(0.0).sign(), CGFloat(1.0))
  }

  func testDegreesToRadians() {
    XCTAssertEqualWithAccuracy(CGFloat(0).degreesToRadians(), CGFloat(0), accuracy: CGFloat(FLT_EPSILON))
    XCTAssertEqualWithAccuracy(CGFloat(45).degreesToRadians(), π/4, accuracy: CGFloat(FLT_EPSILON))
    XCTAssertEqualWithAccuracy(CGFloat(90).degreesToRadians(), π/2, accuracy: CGFloat(FLT_EPSILON))
    XCTAssertEqualWithAccuracy(CGFloat(135).degreesToRadians(), 3*π/4, accuracy: CGFloat(FLT_EPSILON))
    XCTAssertEqualWithAccuracy(CGFloat(180).degreesToRadians(), π, accuracy: CGFloat(FLT_EPSILON))
    XCTAssertEqualWithAccuracy(CGFloat(-135).degreesToRadians(), -3*π/4, accuracy: CGFloat(FLT_EPSILON))
    XCTAssertEqualWithAccuracy(CGFloat(-90).degreesToRadians(), -π/2, accuracy: CGFloat(FLT_EPSILON))
    XCTAssertEqualWithAccuracy(CGFloat(-45).degreesToRadians(), -π/4, accuracy: CGFloat(FLT_EPSILON))
  }

  func testRadiansToDegrees() {
    XCTAssertEqualWithAccuracy(CGFloat(0).radiansToDegrees(), CGFloat(0), accuracy: CGFloat(FLT_EPSILON))
    XCTAssertEqualWithAccuracy((π/4).radiansToDegrees(), CGFloat(45), accuracy: CGFloat(FLT_EPSILON))
    XCTAssertEqualWithAccuracy((π/2).radiansToDegrees(), CGFloat(90), accuracy: CGFloat(FLT_EPSILON))
    XCTAssertEqualWithAccuracy((3*π/4).radiansToDegrees(), CGFloat(135), accuracy: CGFloat(FLT_EPSILON))
    XCTAssertEqualWithAccuracy(π.radiansToDegrees(), CGFloat(180), accuracy: CGFloat(FLT_EPSILON))
    XCTAssertEqualWithAccuracy((-3*π/4).radiansToDegrees(), CGFloat(-135), accuracy: CGFloat(FLT_EPSILON))
    XCTAssertEqualWithAccuracy((-π/2).radiansToDegrees(), CGFloat(-90), accuracy: CGFloat(FLT_EPSILON))
    XCTAssertEqualWithAccuracy((-π/4).radiansToDegrees(), CGFloat(-45), accuracy: CGFloat(FLT_EPSILON))
  }

  func testAllAngles() {
    let startAngle = CGFloat(-360)
    let endAngle = CGFloat(360)
    for angle in startAngle.stride(through: endAngle, by: 0.5) {
      let radians = angle.degreesToRadians()
      XCTAssertEqualWithAccuracy(radians.radiansToDegrees(), angle, accuracy: 1.0e6)
    }
  }

  func testShortestAngleBetween() {
    // TODO!
  }
}

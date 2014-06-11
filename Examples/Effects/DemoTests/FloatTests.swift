
import XCTest

class FloatTests: XCTestCase {

  func testClamped() {
    XCTAssertEqual(Float(10).clamped(min: -5, max: 6), 6)
    XCTAssertEqual(Float(7).clamped(min: -5, max: 6), 6)
    XCTAssertEqual(Float(6).clamped(min: -5, max: 6), 6)
    XCTAssertEqual(Float(5).clamped(min: -5, max: 6), 5)
    XCTAssertEqual(Float(1).clamped(min: -5, max: 6), 1)
    XCTAssertEqual(Float(0).clamped(min: -5, max: 6), 0)
    XCTAssertEqual(Float(-4).clamped(min: -5, max: 6), -4)
    XCTAssertEqual(Float(-5).clamped(min: -5, max: 6), -5)
    XCTAssertEqual(Float(-6).clamped(min: -5, max: 6), -5)
    XCTAssertEqual(Float(-10).clamped(min: -5, max: 6), -5)
  }

  func testThatClampedDoesNotChangeOriginalValue() {
    let original: Float = 50
    let clamped = original.clamped(min: 100, max: 200)
    XCTAssertEqual(original, 50)
  }

  func testThatClampReturnsNewValue() {
    var original: Float = 50
    original.clamp(min: 100, max: 200)
    XCTAssertEqual(original, 100)
  }

  func testThatRandomStaysBetweenOneAndZero() {
    for i in 0..1000 {
      let value = Float.random()
      XCTAssert(value >= 0 && value <= 1)
    }
  }

  func testThatRandomStaysInRange() {
    for i in 0..1000 {
      let value = Float.random(min: -10, max: 10)
      XCTAssert(value >= -10 && value <= 10)
    }
  }

  func testThatRandomSignIsMinusOrPlusOne() {
    for i in 0..1000 {
      let value = Float.randomSign()
      XCTAssert(value == -1.0 || value == 1.0)
    }
  }
  
  func testSign() {
    XCTAssertEqual(Float(-100.0).sign(), -1.0)
    XCTAssertEqual(Float(100.0).sign(), 1.0)
    XCTAssertEqual(Float(0.0).sign(), 1.0)
  }

  func testDegreesToRadians() {
    XCTAssertEqualWithAccuracy(Float(0).degreesToRadians(), 0, FLT_EPSILON)
    XCTAssertEqualWithAccuracy(Float(45).degreesToRadians(), π/4, FLT_EPSILON)
    XCTAssertEqualWithAccuracy(Float(90).degreesToRadians(), π/2, FLT_EPSILON)
    XCTAssertEqualWithAccuracy(Float(135).degreesToRadians(), 3*π/4, FLT_EPSILON)
    XCTAssertEqualWithAccuracy(Float(180).degreesToRadians(), π, FLT_EPSILON)
    XCTAssertEqualWithAccuracy(Float(-135).degreesToRadians(), -3*π/4, FLT_EPSILON)
    XCTAssertEqualWithAccuracy(Float(-90).degreesToRadians(), -π/2, FLT_EPSILON)
    XCTAssertEqualWithAccuracy(Float(-45).degreesToRadians(), -π/4, FLT_EPSILON)
  }

  func testRadiansToDegrees() {
    XCTAssertEqualWithAccuracy(Float(0).radiansToDegrees(), Float(0), FLT_EPSILON)
    XCTAssertEqualWithAccuracy((π/4).radiansToDegrees(), Float(45), FLT_EPSILON)
    XCTAssertEqualWithAccuracy((π/2).radiansToDegrees(), Float(90), FLT_EPSILON)
    XCTAssertEqualWithAccuracy((3*π/4).radiansToDegrees(), Float(135), FLT_EPSILON)
    XCTAssertEqualWithAccuracy(π.radiansToDegrees(), Float(180), FLT_EPSILON)
    XCTAssertEqualWithAccuracy((-3*π/4).radiansToDegrees(), Float(-135), FLT_EPSILON)
    XCTAssertEqualWithAccuracy((-π/2).radiansToDegrees(), Float(-90), FLT_EPSILON)
    XCTAssertEqualWithAccuracy((-π/4).radiansToDegrees(), Float(-45), FLT_EPSILON)
  }

  func testAllAngles() {
    for var angle: Float = -360; angle <= 360; angle += 0.5 {
      let radians = angle.degreesToRadians()
      XCTAssertEqualWithAccuracy(radians.radiansToDegrees(), angle, 1.0e6)
    }
  }

  func testShortestAngleBetween() {
    // TODO!
  }
}

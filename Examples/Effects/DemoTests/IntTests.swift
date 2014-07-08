
import XCTest

class IntTests: XCTestCase {

  func testClampedHalfOpenRange() {
    XCTAssertEqual(10.clamped(-5 ..< 7), 6)
    XCTAssertEqual(7.clamped(-5 ..< 7), 6)
    XCTAssertEqual(6.clamped(-5 ..< 7), 6)
    XCTAssertEqual(5.clamped(-5 ..< 7), 5)
    XCTAssertEqual(1.clamped(-5 ..< 7), 1)
    XCTAssertEqual(0.clamped(-5 ..< 7), 0)
    XCTAssertEqual((-4).clamped(-5 ..< 7), -4)
    XCTAssertEqual((-5).clamped(-5 ..< 7), -5)
    XCTAssertEqual((-6).clamped(-5 ..< 7), -5)
    XCTAssertEqual((-10).clamped(-5 ..< 7), -5)
  }

  func testClampedEmptyHalfOpenRange() {
    XCTAssertEqual(10.clamped(7 ..< 7), 6)     // weird, huh!
    XCTAssertEqual((-10).clamped(7 ..< 7), 7)
  }

  func testClampedInverseHalfOpenRange() {
    XCTAssertEqual(10.clamped(7 ..< -5), -6)    // !?
    XCTAssertEqual((-10).clamped(7 ..< -5), 7)  // !?
  }

  func testClampedOpenRange() {
    XCTAssertEqual(10.clamped(-5 ... 7), 7)
    XCTAssertEqual(8.clamped(-5 ... 7), 7)
    XCTAssertEqual(7.clamped(-5 ... 7), 7)
    XCTAssertEqual(6.clamped(-5 ... 7), 6)
    XCTAssertEqual(1.clamped(-5 ... 7), 1)
    XCTAssertEqual(0.clamped(-5 ... 7), 0)
    XCTAssertEqual((-4).clamped(-5 ... 7), -4)
    XCTAssertEqual((-5).clamped(-5 ... 7), -5)
    XCTAssertEqual((-6).clamped(-5 ... 7), -5)
    XCTAssertEqual((-10).clamped(-5 ... 7), -5)
  }

  func testClampedEmptyOpenRange() {
    XCTAssertEqual(10.clamped(7 ... 7), 7)
    XCTAssertEqual((-10).clamped(7 ... 7), 7)
  }

  func testClampedInverseOpenRange() {
    XCTAssertEqual(10.clamped(7 ... -5), -5)    // !?
    XCTAssertEqual((-10).clamped(7 ... -5), 7)  // !?
  }

//  func testClamped() {
//    XCTAssertEqual(10.clamped(min: -5, max: 6), 6)
//    XCTAssertEqual(7.clamped(min: -5, max: 6), 6)
//    XCTAssertEqual(6.clamped(min: -5, max: 6), 6)
//    XCTAssertEqual(5.clamped(min: -5, max: 6), 5)
//    XCTAssertEqual(1.clamped(min: -5, max: 6), 1)
//    XCTAssertEqual(0.clamped(min: -5, max: 6), 0)
//    XCTAssertEqual((-4).clamped(min: -5, max: 6), -4)
//    XCTAssertEqual((-5).clamped(min: -5, max: 6), -5)
//    XCTAssertEqual((-6).clamped(min: -5, max: 6), -5)
//    XCTAssertEqual((-10).clamped(min: -5, max: 6), -5)
//  }

  func testThatClampedDoesNotChangeOriginalValue() {
    let original = 50
    let clamped = original.clamped(100 ... 200)
    XCTAssertEqual(original, 50)
  }

  func testThatClampReturnsNewValue() {
    var original = 50
    original.clamp(100 ... 200)
    XCTAssertEqual(original, 100)
  }

  func testThatRandomStaysInHalfOpenRange() {
    for i in 0..<1000 {
      let value = Int.random(-10 ..< 10)
      XCTAssert(value >= -10 && value < 10)
    }
  }

  func testThatRandomStaysInOpenRange() {
    for i in 0..<1000 {
      let value = Int.random(-10 ... 10)
      XCTAssert(value >= -10 && value <= 10)
    }
  }
}

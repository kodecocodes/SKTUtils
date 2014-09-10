
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

  func testClamped() {
    XCTAssertEqual(10.clamped(-5, 6), 6)
    XCTAssertEqual(7.clamped(-5, 6), 6)
    XCTAssertEqual(6.clamped(-5, 6), 6)
    XCTAssertEqual(5.clamped(-5, 6), 5)
    XCTAssertEqual(1.clamped(-5, 6), 1)
    XCTAssertEqual(0.clamped(-5, 6), 0)
    XCTAssertEqual((-4).clamped(-5, 6), -4)
    XCTAssertEqual((-5).clamped(-5, 6), -5)
    XCTAssertEqual((-6).clamped(-5, 6), -5)
    XCTAssertEqual((-10).clamped(-5, 6), -5)
  }

  func testClampedReverseOrder() {
    XCTAssertEqual(10.clamped(6, -5), 6)
    XCTAssertEqual(7.clamped(6, -5), 6)
    XCTAssertEqual(6.clamped(6, -5), 6)
    XCTAssertEqual(5.clamped(6, -5), 5)
    XCTAssertEqual(1.clamped(6, -5), 1)
    XCTAssertEqual(0.clamped(6, -5), 0)
    XCTAssertEqual((-4).clamped(6, -5), -4)
    XCTAssertEqual((-5).clamped(6, -5), -5)
    XCTAssertEqual((-6).clamped(6, -5), -5)
    XCTAssertEqual((-10).clamped(6, -5), -5)
  }

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
      let v = Int.random(-10 ..< 10)
      XCTAssert(v >= -10 && v < 10)

      let w = Int.random(10)
      XCTAssert(w >= 0 && w < 10)
    }
  }

  func testThatRandomStaysInOpenRange() {
    for i in 0..<1000 {
      let v = Int.random(-10 ... 10)
      XCTAssert(v >= -10 && v <= 10)

      let w = Int.random(min: -10, max: 10)
      XCTAssert(w >= -10 && w <= 10)
    }
  }
}

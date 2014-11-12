
import XCTest
import SpriteKit

class Vector3Tests: XCTestCase {
  var v1 = Vector3(x: 100, y: 50, z: 25)
  let v2 = Vector3(x: 10, y: 5, z: 5)

  func testAddingTwoVectors() {
    XCTAssertEqual(v1 + v2, Vector3(x: 110, y: 55, z: 30))
  }

  func testAddingVectorToVector() {
    v1 += v2
    XCTAssertEqual(v1, Vector3(x: 110, y: 55, z: 30))
  }

  func testSubtractingTwoVectors() {
    XCTAssertEqual(v1 - v2, Vector3(x: 90, y: 45, z: 20))
  }

  func testSubtractingVectorFromVector() {
    v1 -= v2
    XCTAssertEqual(v1, Vector3(x: 90, y: 45, z: 20))
  }

  func testMultiplyingTwoVectors() {
    XCTAssertEqual(v1 * v2, Vector3(x: 1000, y: 250, z: 125))
  }

  func testMultiplyingVectorByVector() {
    v1 *= v2
    XCTAssertEqual(v1, Vector3(x: 1000, y: 250, z: 125))
  }

  func testMultiplyingVectorAndFloat() {
    XCTAssertEqual(v1 * 2.5, Vector3(x: 250, y: 125, z: 62.5))
  }

  func testMultiplyingVectorByFloat() {
    v1 *= 2.5
    XCTAssertEqual(v1, Vector3(x: 250, y: 125, z: 62.5))
  }

  func testDividingTwoVectors() {
    XCTAssertEqual(v1 / v2, Vector3(x: 10, y: 10, z: 5))
  }

  func testDividingVectorByVector() {
    v1 /= v2
    XCTAssertEqual(v1, Vector3(x: 10, y: 10, z: 5))
  }

  func testDividingVectorAndFloat() {
    XCTAssertEqual(v1 / 2.5, Vector3(x: 40, y: 20, z: 10))
  }

  func testDividingVectorByFloat() {
    v1 /= 2.5
    XCTAssertEqual(v1, Vector3(x: 40, y: 20, z: 10))
  }

  func testEquality() {
    let v3 = v1
    XCTAssert(v1 == v3)
    XCTAssertFalse(v1 == v2)
  }

  func testEqualityScalar() {
    let v3 = Vector3(x: 3.0, y: 3.0, z: 3.0)
    XCTAssertFalse(v1 == 3.0)
    XCTAssert(v3 == 3.0)
  }

  func testInit() {
    let v = Vector3(x: -10, y: -20, z: -30)
    XCTAssertEqual(v.x, CGFloat(-10))
    XCTAssertEqual(v.y, CGFloat(-20))
    XCTAssertEqual(v.z, CGFloat(-30))
  }

  func testLengthXUnitVector() {
    let v = Vector3(x: 1.0, y: 0.0, z: 0.0)
    XCTAssertEqual(v.length(), CGFloat(1.0))
  }

  func testLengthYUnitVector() {
    let v = Vector3(x: 0.0, y: 1.0, z: 0.0)
    XCTAssertEqual(v.length(), CGFloat(1.0))
  }

  func testLengthZUnitVector() {
    let v = Vector3(x: 0.0, y: 0.0, z: 1.0)
    XCTAssertEqual(v.length(), CGFloat(1.0))
  }

  func testLength() {
    let v = Vector3(x: 1.0, y: 1.0, z: 1.0)
    XCTAssertEqual(v.length(), sqrt(3.0))
  }

  func testLengthIsPositive() {
    let v = Vector3(x: -1.0, y: -1.0, z: -1.0)
    XCTAssertEqual(v.length(), sqrt(3.0))
  }

  func testNormalized() {
    let normalized = v1.normalized()
    XCTAssertEqualWithAccuracy(normalized.x, 4.0/sqrt(21.0), CGFloat(FLT_EPSILON))
    XCTAssertEqualWithAccuracy(normalized.y, 2.0/sqrt(21.0), CGFloat(FLT_EPSILON))
    XCTAssertEqualWithAccuracy(normalized.z, 1.0/sqrt(21.0), CGFloat(FLT_EPSILON))
  }

  func testThatNormalizedDoesNotChangeOriginalValue() {
    let old = v1
    let normalized = v1.normalized()
    XCTAssertEqual(v1.x, old.x)
    XCTAssertEqual(v1.y, old.y)
    XCTAssertEqual(v1.z, old.z)
  }

  func testThatNormalizeReturnsNewValue() {
    v1.normalize()
    XCTAssertEqualWithAccuracy(v1.x, 4.0/sqrt(21.0), CGFloat(FLT_EPSILON))
    XCTAssertEqualWithAccuracy(v1.y, 2.0/sqrt(21.0), CGFloat(FLT_EPSILON))
    XCTAssertEqualWithAccuracy(v1.z, 1.0/sqrt(21.0), CGFloat(FLT_EPSILON))
  }

  func testLerp() {
    let start = Vector3(x: -100, y: -75, z:-3)
    let end = Vector3(x: 100, y: 25, z: 7)

    let expected = [
      Vector3(x: -100, y: -75, z: -3),
      Vector3(x: -80, y: -65, z: -2),
      Vector3(x: -60, y: -55, z: -1),
      Vector3(x: -40, y: -45, z: 0),
      Vector3(x: -20, y: -35, z: 1),
      Vector3(x: 0, y: -25, z: 2),
      Vector3(x: 20, y: -15, z: 3),
      Vector3(x: 40, y: -5, z: 4),
      Vector3(x: 60, y: 5, z: 5),
      Vector3(x: 80, y: 15, z: 6),
      Vector3(x: 100, y: 25, z: 7)
    ]

    var i = 0
    for var t = 0.0; t <= 1.0; t += 0.1, ++i {
      let lerped = lerp(start: start, end: end, t: CGFloat(t))
      XCTAssertEqualWithAccuracy(lerped.x, expected[i].x, 1.0e6)
      XCTAssertEqualWithAccuracy(lerped.y, expected[i].y, 1.0e6)
      XCTAssertEqualWithAccuracy(lerped.z, expected[i].z, 1.0e6)
    }
  }

  func testDotProduct() {
    let v1 = Vector3(x: -1.0, y: 2.0, z: -3.0)
    let v2 = Vector3(x: 4.0, y: -5.0, z: -6.0)

    // test class dot product
    let r1 = Vector3.dotProduct(v1, right: v2)
    XCTAssertEqual(r1,CGFloat(4.0))

    // test member dot product
    let r2 = v1.dot(v2)
    XCTAssertEqual(r2,CGFloat(4.0))
    XCTAssertEqual(v1.x,CGFloat(-1.0))
    XCTAssertEqual(v1.y,CGFloat(2.0))
    XCTAssertEqual(v1.z,CGFloat(-3.0))
  }

  func testCrossProduct() {
    let v1 = Vector3(x: -1.0, y: 2.0, z: -3.0)
    let v2 = Vector3(x: 4.0, y: -5.0, z: -6.0)

    // test class cross product
    let r1 = Vector3.crossProduct(v1, right: v2)
    XCTAssertEqual(r1.x,CGFloat(-27.0))
    XCTAssertEqual(r1.y,CGFloat(-18.0))
    XCTAssertEqual(r1.z,CGFloat(-3.0))

    // test member cross product
    let r2 = v1.cross(v2)
    XCTAssertEqual(r2.x,CGFloat(-27.0))
    XCTAssertEqual(r2.y,CGFloat(-18.0))
    XCTAssertEqual(r2.z,CGFloat(-3.0))
    XCTAssertEqual(v1.x,CGFloat(-1.0))
    XCTAssertEqual(v1.y,CGFloat(2.0))
    XCTAssertEqual(v1.z,CGFloat(-3.0))
  }
}

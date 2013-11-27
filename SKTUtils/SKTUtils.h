/*
 * Copyright (c) 2013 Razeware LLC
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

#import <CoreGraphics/CoreGraphics.h>
#import <GLKit/GLKMath.h>
#import <SpriteKit/SpriteKit.h>

#define SKT_INLINE static __inline__

/**
 * Converts a CGPoint into a GLKVector2 so you can use it with the GLKMath
 * functions from GL Kit.
 */
SKT_INLINE GLKVector2 GLKVector2FromCGPoint(CGPoint point) {
  return GLKVector2Make(point.x, point.y);
}

/**
 * Converts a GLKVector2 into a CGPoint.
 */
SKT_INLINE CGPoint CGPointFromGLKVector2(GLKVector2 vector) {
  return CGPointMake(vector.x, vector.y);
}

/**
 * Converts a CGPoint into a CGVector.
 */
SKT_INLINE CGVector CGVectorFromCGPoint(CGPoint point) {
  return CGVectorMake(point.x, point.y);
}

/**
 * Converts a CGVector into a CGPoint.
 */
SKT_INLINE CGPoint CGPointFromCGVector(CGVector vector) {
  return CGPointMake(vector.dx, vector.dy);
}

/**
 * Adds (dx, dy) to the point.
 */
SKT_INLINE CGPoint CGPointOffset(CGPoint point, CGFloat dx, CGFloat dy) {
  return CGPointMake(point.x + dx, point.y + dy);
}

/**
 * Adds two CGPoint values and returns the result as a new CGPoint.
 */
SKT_INLINE CGPoint CGPointAdd(CGPoint point1, CGPoint point2) {
  return CGPointMake(point1.x + point2.x, point1.y + point2.y);
}

/**
 * Subtracts point2 from point1 and returns the result as a new CGPoint.
 */
SKT_INLINE CGPoint CGPointSubtract(CGPoint point1, CGPoint point2) {
  return CGPointMake(point1.x - point2.x, point1.y - point2.y);
}

/**
 * Multiplies two CGPoint values and returns the result as a new CGPoint.
 */
SKT_INLINE CGPoint CGPointMultiply(CGPoint point1, CGPoint point2) {
  return CGPointMake(point1.x * point2.x, point1.y * point2.y);
}

/**
 * Divides point1 by point2 and returns the result as a new CGPoint.
 */
SKT_INLINE CGPoint CGPointDivide(CGPoint point1, CGPoint point2) {
  return CGPointMake(point1.x / point2.x, point1.y / point2.y);
}

/**
 * Multiplies the x and y fields of a CGPoint with the same scalar value and
 * returns the result as a new CGPoint.
 */
SKT_INLINE CGPoint CGPointMultiplyScalar(CGPoint point, CGFloat value) {
  return CGPointFromGLKVector2(GLKVector2MultiplyScalar(GLKVector2FromCGPoint(point), value));
}

/**
 * Divides the x and y fields of a CGPoint by the same scalar value and returns
 * the result as a new CGPoint.
 */
SKT_INLINE CGPoint CGPointDivideScalar(CGPoint point, CGFloat value) {
  return CGPointFromGLKVector2(GLKVector2DivideScalar(GLKVector2FromCGPoint(point), value));
}

/**
 * Returns the length (magnitude) of the vector described by a CGPoint.
 */
SKT_INLINE CGFloat CGPointLength(CGPoint point) {
  return GLKVector2Length(GLKVector2FromCGPoint(point));
}

/**
 * Normalizes the vector described by a CGPoint to length 1.0 and returns the
 * result as a new CGPoint.
 */
SKT_INLINE CGPoint CGPointNormalize(CGPoint point) {
  return CGPointFromGLKVector2(GLKVector2Normalize(GLKVector2FromCGPoint(point)));
}

/**
 * Calculates the distance between two CGPoints. Pythagoras!
 */
SKT_INLINE CGFloat CGPointDistance(CGPoint point1, CGPoint point2) {
  return CGPointLength(CGPointSubtract(point1, point2));
}

/**
 * Returns the angle in radians of the vector described by a CGPoint. The range
 * of the angle is -M_PI to M_PI; an angle of 0 points to the right.
 */
SKT_INLINE CGFloat CGPointToAngle(CGPoint point) {
  return atan2(point.y, point.x);
}

/**
 * Given an angle in radians, creates a vector of length 1.0 and returns the
 * result as a new CGPoint. An angle of 0 is assumed to point to the right.
 */
SKT_INLINE CGPoint CGPointForAngle(CGFloat angle) {
  return CGPointMake(cos(angle), sin(angle));
}

/**
 * Performs a linear interpolation between two CGPoint values.
 */
SKT_INLINE CGPoint CGPointLerp(CGPoint startPoint, CGPoint endPoint, CGFloat t) {
  return CGPointMake(startPoint.x + (endPoint.x - startPoint.x)*t, startPoint.y + (endPoint.y - startPoint.y)*t);
}

/**
 * Ensures that a scalar value stays with the range [min..max], inclusive.
 */
SKT_INLINE CGFloat Clamp(CGFloat value, CGFloat min, CGFloat max) {
  return value < min ? min : value > max ? max : value;
}

/**
 * Returns 1.0 if a floating point value is positive; -1.0 if it is negative.
 */
SKT_INLINE CGFloat ScalarSign(CGFloat value) {
  return (value >= 0.0) ? 1.0 : -1.0;
}

/**
 * Returns the shortest angle between two angles. The result is always between
 * -M_PI and M_PI.
 */
SKT_INLINE CGFloat ScalarShortestAngleBetween(CGFloat angle1, CGFloat angle2) {
  CGFloat angle = fmod(angle1 - angle2, M_PI * 2.0);
  if (angle >= M_PI) {
    angle -= M_PI * 2.0;
  }
  if (angle <= -M_PI) {
    angle += M_PI * 2.0;
  }
  return angle;
}

/**
 * Converts an angle in degrees to radians.
 */
SKT_INLINE CGFloat DegreesToRadians(CGFloat degrees) {
  return M_PI * degrees / 180.0;
}

/**
 * Converts an angle in radians to degrees.
 */
SKT_INLINE CGFloat RadiansToDegrees(CGFloat radians) {
  return radians * 180.0 / M_PI;
}

/**
 * Returns a random floating point number between 0.0 and 1.0, inclusive.
 */
SKT_INLINE CGFloat RandomFloat(void) {
  return (CGFloat)arc4random() / 0xFFFFFFFFu;
}

/**
 * Returns a random floating point number in the range [min..max], inclusive.
 */
SKT_INLINE CGFloat RandomFloatRange(CGFloat min, CGFloat max) {
  return ((CGFloat)arc4random() / 0xFFFFFFFFu) * (max - min) + min;
}

/**
 * Randomly returns either 1.0 or -1.0.
 */
SKT_INLINE CGFloat RandomSign(void) {
  return (arc4random_uniform(2) == 0) ? 1.0 : -1.0;
}

/**
 * Creates and returns a new SKColor object using RGB components specified as
 * values from 0 to 255.
 */
SKT_INLINE SKColor *SKColorWithRGB(int r, int g, int b) {
  return [SKColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
}

/**
 * Creates and returns a new SKColor object using RGBA components specified as
 * values from 0 to 255.
 */
SKT_INLINE SKColor *SKColorWithRGBA(int r, int g, int b, int a) {
  return [SKColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/255.0];
}

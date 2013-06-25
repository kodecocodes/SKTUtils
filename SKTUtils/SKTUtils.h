//
//  SKTUtils.h
//  SKTUtils
//
//  Created by Main Account on 6/24/13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <GLKit/GLKMath.h>

#pragma mark -
#pragma mark Define

#define SKT_INLINE      static __inline__

// Chapters 1-3
#define ARC4RANDOM_MAX      0x100000000

#pragma mark -
#pragma mark Prototypes

SKT_INLINE GLKVector2   GLKVector2FromCGPoint(CGPoint point);

SKT_INLINE CGPoint      CGPointFromGLKVector2(GLKVector2 vector);
SKT_INLINE CGPoint      CGPointSubtract(CGPoint point1, CGPoint point2);
SKT_INLINE CGPoint      CGPointAdd(CGPoint point1, CGPoint point2);
SKT_INLINE CGPoint      CGPointMultiply(CGPoint point1, CGFloat point2);
SKT_INLINE CGPoint      CGPointNormalize(CGPoint point);
SKT_INLINE CGPoint      CGPointForAngle(CGFloat value);

SKT_INLINE CGFloat      CGPointLength(CGPoint point);
SKT_INLINE CGFloat      CGPointToAngle(CGPoint point);
SKT_INLINE CGFloat      ScalarSign(CGFloat value);
SKT_INLINE CGFloat      ScalarShortestAngleBetween(CGFloat value1, CGFloat value2);
SKT_INLINE CGFloat      ScalarRandRange(CGFloat min, CGFloat max);
    
#pragma mark -
#pragma mark Implementations

SKT_INLINE CGPoint CGPointFromGLKVector2(GLKVector2 vector)
{
    return CGPointMake(vector.x, vector.y);
}

SKT_INLINE GLKVector2 GLKVector2FromCGPoint(CGPoint point)
{
    return GLKVector2Make(point.x, point.y);
}

SKT_INLINE CGPoint CGPointSubtract(CGPoint point1, CGPoint point2)
{
    return CGPointFromGLKVector2(GLKVector2Subtract(GLKVector2FromCGPoint(point1), GLKVector2FromCGPoint(point2)));
}

SKT_INLINE CGPoint CGPointAdd(CGPoint point1, CGPoint point2) {
    return CGPointFromGLKVector2(GLKVector2Add(GLKVector2FromCGPoint(point1), GLKVector2FromCGPoint(point2)));
}

SKT_INLINE CGPoint CGPointMultiplyScalar(CGPoint point, CGFloat value) {
    return CGPointFromGLKVector2(GLKVector2MultiplyScalar(GLKVector2FromCGPoint(point), value));
}

SKT_INLINE CGFloat CGPointLength(CGPoint point) {
    return GLKVector2Length(GLKVector2FromCGPoint(point));
}

SKT_INLINE CGPoint CGPointNormalize(CGPoint point) {
    return CGPointFromGLKVector2(GLKVector2Normalize(GLKVector2FromCGPoint(point)));
}

SKT_INLINE CGFloat CGPointToAngle(CGPoint point) {
    return atan2f(point.y, point.x);
}

SKT_INLINE CGPoint CGPointForAngle(CGFloat value) {
	return CGPointMake(cosf(value), sinf(value));
}

SKT_INLINE CGFloat ScalarSign(CGFloat value) {
    return value >= 0 ? 1 : -1;
}

// Returns shortest angle between two angles, between -M_PI and M_PI
static inline CGFloat ScalarShortestAngleBetween(CGFloat value1, CGFloat value2) {
    CGFloat difference = value2 - value1;
    CGFloat angle = fmodf(difference, M_PI * 2);
    if (angle >= M_PI) {
        angle -= M_PI * 2;
    }
    if (angle <= -M_PI) {
        angle += M_PI * 2;
    }
    return angle;
}

static inline CGFloat ScalarRandomRange(CGFloat min, CGFloat max) {
    return floorf(((double)arc4random() / ARC4RANDOM_MAX) * (max - min) + min);
}
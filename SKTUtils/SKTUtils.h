//
//  SKTUtils.h
//  SKTUtils
//
//  Created by Main Account on 6/24/13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <SpriteKit/SpriteKit.h>
#import <GLKit/GLKMath.h>

#define SKT_INLINE      static __inline__

// Chapters 1-3
#define ARC4RANDOM_MAX      0xFFFFFFFFu

#define DegreesToRadians(d) (M_PI * (d) / 180.0f)
#define RadiansToDegrees(r) ((r) * 180.0f / M_PI)

SKT_INLINE CGPoint CGPointFromGLKVector2(GLKVector2 vector) {
    return CGPointMake(vector.x, vector.y);
}

SKT_INLINE GLKVector2 GLKVector2FromCGPoint(CGPoint point) {
    return GLKVector2Make(point.x, point.y);
}

SKT_INLINE CGPoint CGPointAdd(CGPoint point1, CGPoint point2) {
    return CGPointMake(point1.x + point2.x, point1.y + point2.y);
}

SKT_INLINE CGPoint CGPointSubtract(CGPoint point1, CGPoint point2) {
    return CGPointMake(point1.x - point2.x, point1.y - point2.y);
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
SKT_INLINE CGFloat ScalarShortestAngleBetween(CGFloat value1, CGFloat value2) {
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

SKT_INLINE CGFloat RandomFloat(void) {
    return (CGFloat)arc4random()/ARC4RANDOM_MAX;
}

SKT_INLINE CGFloat RandomFloatRange(CGFloat min, CGFloat max) {
    return floorf(((double)arc4random() / ARC4RANDOM_MAX) * (max - min) + min);
}

SKT_INLINE SKColor *SKColorWithRGB(int r, int g, int b) {
    return [SKColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f];
}

SKT_INLINE SKColor *SKColorWithRGBA(int r, int g, int b, int a) {
    return [SKColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a/255.0f];
}

SKT_INLINE CGFloat Clamp(CGFloat value, CGFloat min, CGFloat max) {
  return value < min ? min : value > max ? max : value;
}

//
//  SKTUtils.h
//  SKTUtils
//
//  Created by Main Account on 6/24/13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

// Chapters 1-3
#define SKT_DEGREES_TO_RADIANS(__DEGREES__) ((__DEGREES__) * M_PI / 180)
#define SKT_RADIANS_TO_DEGREES(__RADIANS__) ((__RADIANS__) * 180 / M_PI)
#define ARC4RANDOM_MAX      0x100000000

static inline CGPoint SKTAdd(const CGPoint a, const CGPoint b) {
    return CGPointMake(a.x + b.x, a.y + b.y);
}

static inline CGPoint SKTSub(const CGPoint a, const CGPoint b) {
    return CGPointMake(a.x - b.x, a.y - b.y);
}

static inline CGPoint SKTMult(const CGPoint a, CGFloat b) {
    return CGPointMake(a.x * b, a.y * b);
}

static inline CGFloat SKTLength(const CGPoint a) {
    return sqrtf(a.x * a.x + a.y * a.y);
}

static inline CGPoint SKTNormalize(const CGPoint a) {
    CGFloat length = SKTLength(a);
    return CGPointMake(a.x / length, a.y / length);
}

static inline CGFloat SKTToAngle(const CGPoint a) {
    return atan2f(a.y, a.x);
}

static inline CGPoint SKTForAngle(const CGFloat a) {
	return CGPointMake(cosf(a), sinf(a));
}

static inline CGFloat SKTSign(const CGFloat a) {
    return a >= 0 ? 1 : -1;
}

// Returns shortest angle between two angles, between -M_PI and M_PI
static inline CGFloat SKTShortestAngleBetween(const CGFloat a, const CGFloat b) {
    CGFloat difference = b - a;
    CGFloat angle = fmodf(difference, M_PI * 2);
    if (angle >= M_PI) {
        angle -= M_PI * 2;
    }
    if (angle <= -M_PI) {
        angle += M_PI * 2;
    }
    return angle;
}

static inline CGFloat SKTRandRange(const CGFloat min, const CGFloat max) {
    return floorf(((double)arc4random() / ARC4RANDOM_MAX) * (max - min) + min);
}
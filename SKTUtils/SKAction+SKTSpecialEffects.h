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

#import <SpriteKit/SpriteKit.h>

@interface SKAction (SKTSpecialEffects)

/**
 * Creates a screen shake animation.
 *
 * \param amount The vector by which the node is displaced.
 * \param oscillations The number of oscillations. 10 is a good value.
 *
 * \note You cannot apply this to an SKScene.
 */
+ (instancetype)skt_screenShakeWithNode:(SKNode *)node amount:(CGPoint)amount oscillations:(int)oscillations duration:(NSTimeInterval)duration;

/**
 * Creates a screen rotation animation.
 *
 * \param angle The angle in radians.
 * \param oscillations The number of oscillations. 10 is a good value.
 *
 * \note You cannot apply this to an SKScene. You usually want to apply this to
 * a pivot node that is centered in the scene.
 */
+ (instancetype)skt_screenTumbleWithNode:(SKNode *)node angle:(CGFloat)angle oscillations:(int)oscillations duration:(NSTimeInterval)duration;

/**
 * Creates a screen zoom animation.
 *
 * \param amount How much to scale the node in the X and Y directions.
 * \param oscillations The number of oscillations. 10 is a good value.
 *
 * \note You cannot apply this to an SKScene. You usually want to apply this to
 * a pivot node that is centered in the scene.
 */
+ (instancetype)skt_screenZoomWithNode:(SKNode *)node amount:(CGPoint)amount oscillations:(int)oscillations duration:(NSTimeInterval)duration;

/**
 * Causes the scene background to flash for duration seconds.
 */
+ (instancetype)skt_colorGlitchWithScene:(SKScene *)scene originalColor:(SKColor *)color duration:(NSTimeInterval)duration;

@end

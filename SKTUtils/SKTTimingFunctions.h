/*
 * Timing functions for SKTEffects. Based on Robert Penner's easing equations
 * http://robertpenner.com/easing/ and https://github.com/warrenm/AHEasing
 *
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

typedef float (^SKTTimingFunction)(float y);

extern SKTTimingFunction SKTTimingFunctionLinear;

extern SKTTimingFunction SKTTimingFunctionQuadraticEaseIn;
extern SKTTimingFunction SKTTimingFunctionQuadraticEaseOut;
extern SKTTimingFunction SKTTimingFunctionQuadraticEaseInOut;

extern SKTTimingFunction SKTTimingFunctionCubicEaseIn;
extern SKTTimingFunction SKTTimingFunctionCubicEaseOut;
extern SKTTimingFunction SKTTimingFunctionCubicEaseInOut;

extern SKTTimingFunction SKTTimingFunctionQuarticEaseIn;
extern SKTTimingFunction SKTTimingFunctionQuarticEaseOut;
extern SKTTimingFunction SKTTimingFunctionQuarticEaseInOut;

extern SKTTimingFunction SKTTimingFunctionQuinticEaseIn;
extern SKTTimingFunction SKTTimingFunctionQuinticEaseOut;
extern SKTTimingFunction SKTTimingFunctionQuinticEaseInOut;

extern SKTTimingFunction SKTTimingFunctionSineEaseIn;
extern SKTTimingFunction SKTTimingFunctionSineEaseOut;
extern SKTTimingFunction SKTTimingFunctionSineEaseInOut;

extern SKTTimingFunction SKTTimingFunctionCircularEaseIn;
extern SKTTimingFunction SKTTimingFunctionCircularEaseOut;
extern SKTTimingFunction SKTTimingFunctionCircularEaseInOut;

extern SKTTimingFunction SKTTimingFunctionExponentialEaseIn;
extern SKTTimingFunction SKTTimingFunctionExponentialEaseOut;
extern SKTTimingFunction SKTTimingFunctionExponentialEaseInOut;

extern SKTTimingFunction SKTTimingFunctionElasticEaseIn;
extern SKTTimingFunction SKTTimingFunctionElasticEaseOut;
extern SKTTimingFunction SKTTimingFunctionElasticEaseInOut;

extern SKTTimingFunction SKTTimingFunctionBackEaseIn;
extern SKTTimingFunction SKTTimingFunctionBackEaseOut;
extern SKTTimingFunction SKTTimingFunctionBackEaseInOut;

extern SKTTimingFunction SKTTimingFunctionExtremeBackEaseIn;
extern SKTTimingFunction SKTTimingFunctionExtremeBackEaseOut;
extern SKTTimingFunction SKTTimingFunctionExtremeBackEaseInOut;

extern SKTTimingFunction SKTTimingFunctionBounceEaseIn;
extern SKTTimingFunction SKTTimingFunctionBounceEaseOut;
extern SKTTimingFunction SKTTimingFunctionBounceEaseInOut;

extern SKTTimingFunction SKTTimingFunctionSmoothstep;

static __inline__ SKTTimingFunction SKTCreateShakeFunction(float oscillations) {
  return ^(float t) {
    return -powf(2.0f, -10.0f * t) * sinf(t * M_PI * oscillations * 2.0f) + 1.0f;
  };
}

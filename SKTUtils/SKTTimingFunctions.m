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

#import "SKTTimingFunctions.h"

SKTTimingFunction SKTTimingFunctionLinear = ^(float t) {
  return t;
};

SKTTimingFunction SKTTimingFunctionQuadraticEaseIn = ^(float t) {
  return t * t;
};

SKTTimingFunction SKTTimingFunctionQuadraticEaseOut = ^(float t) {
  return t * (2.0f - t);
};

SKTTimingFunction SKTTimingFunctionQuadraticEaseInOut = ^(float t) {
  if (t < 0.5f) {
    return 2.0f * t * t;
  } else {
    const float f = t - 1.0f;
    return 1.0f - 2.0f * f * f;
  }
};

SKTTimingFunction SKTTimingFunctionCubicEaseIn = ^(float t) {
  return t * t * t;
};

SKTTimingFunction SKTTimingFunctionCubicEaseOut = ^(float t) {
  const float f = t - 1.0f;
  return 1.0f + f * f * f;
};

SKTTimingFunction SKTTimingFunctionCubicEaseInOut = ^(float t) {
  if (t < 0.5f) {
    return 4.0f * t * t * t;
  } else {
    const float f = t - 1.0f;
    return 1.0f + 4.0f * f * f * f;
  }
};

SKTTimingFunction SKTTimingFunctionQuarticEaseIn = ^(float t) {
  return t * t * t * t;
};

SKTTimingFunction SKTTimingFunctionQuarticEaseOut = ^(float t) {
  const float f = t - 1.0f;
  return 1.0f + f * f * f * f;
};

SKTTimingFunction SKTTimingFunctionQuarticEaseInOut = ^(float t) {
  if (t < 0.5f) {
    return 8.0f * t * t * t * t;
  } else {
    const float f = t - 1.0f;
    return 1.0f - 8.0f * f * f * f * f;
  }
};

SKTTimingFunction SKTTimingFunctionQuinticEaseIn = ^(float t) {
  return t * t * t * t * t;
};

SKTTimingFunction SKTTimingFunctionQuinticEaseOut = ^(float t) {
  const float f = t - 1.0f;
  return 1.0f + f * f * f * f * f;
};

SKTTimingFunction TimingFunctionQuinticEaseInOut = ^(float t) {
  if (t < 0.5f) {
    return 16.0f * t * t * t * t * t;
  } else {
    const float f = t - 1.0f;
    return 1.0f + 16.0f * f * f * f * f * f;
  }
};

SKTTimingFunction SKTTimingFunctionSineEaseIn = ^(float t) {
  return sinf((t - 1.0f) * M_PI_2) + 1.0f;
};

SKTTimingFunction SKTTimingFunctionSineEaseOut = ^(float t) {
  return sinf(t * M_PI_2);
};

SKTTimingFunction SKTTimingFunctionSineEaseInOut = ^(float t) {
  return 0.5f * (1.0f - cosf(t * M_PI));
};

SKTTimingFunction SKTTimingFunctionCircularEaseIn = ^(float t) {
  return 1.0f - sqrtf(1.0f - t * t);
};

SKTTimingFunction SKTTimingFunctionCircularEaseOut = ^(float t) {
  return sqrtf((2.0f - t) * t);
};

SKTTimingFunction SKTTimingFunctionCircularEaseInOut = ^(float t) {
  if (t < 0.5f) {
    return 0.5f * (1.0f - sqrtf(1.0f - 4.0f * t * t));
  } else {
    return 0.5f * sqrtf(-4.0f * t * t + 8.0f * t - 3.0f) + 0.5f;
  }
};

SKTTimingFunction SKTTimingFunctionExponentialEaseIn = ^(float t) {
  return (t == 0.0f) ? t : powf(2.0f, 10.0f * (t - 1.0f));
};

SKTTimingFunction SKTTimingFunctionExponentialEaseOut = ^(float t) {
  return (t == 1.0f) ? t : 1.0f - powf(2.0f, -10.0f * t);
};

SKTTimingFunction SKTTimingFunctionExponentialEaseInOut = ^(float t) {
  if (t == 0.0f || t == 1.0f) {
    return t;
  } else if (t < 0.5f) {
    return 0.5f * powf(2.0f, 20.0f * t - 10.0f);
  } else {
    return 1.0f - 0.5f * powf(2.0f, -20.0f * t + 10.0f);
  }
};

SKTTimingFunction SKTTimingFunctionElasticEaseIn = ^(float t) {
  return sinf(13.0f * M_PI_2 * t) * powf(2.0f, 10.0f * (t - 1.0f));
};

SKTTimingFunction SKTTimingFunctionElasticEaseOut = ^(float t) {
  return sinf(-13.0f * M_PI_2 * (t + 1.0f)) * powf(2.0f, -10.0f * t) + 1.0f;
};

SKTTimingFunction SKTTimingFunctionElasticEaseInOut = ^(float t) {
  if (t < 0.5f) {
    return 0.5f * sinf(13.0f * M_PI * t) * powf(2.0f, 20.0f * t - 10.0f);
  } else {
    return 0.5f * sinf(-13.0f * M_PI * t) * powf(2.0f, -20.0f * t + 10.0f) + 1.0f;
  }
};

SKTTimingFunction SKTTimingFunctionBackEaseIn = ^(float t) {
  const float s = 1.70158f;
  return ((s + 1.0f) * t - s) * t * t;
};

SKTTimingFunction SKTTimingFunctionBackEaseOut = ^(float t) {
  const float s = 1.70158f;
  const float f = 1.0f - t;
  return 1.0f - ((s + 1.0f) * f - s) * f * f;
};

SKTTimingFunction SKTTimingFunctionBackEaseInOut = ^(float t) {
  const float s = 1.70158f;
  if (t < 0.5f) {
    const float f = 2.0f * t;
    return 0.5f * ((s + 1.0f) * f - s) * f * f;
  } else {
    const float f = 2.0f * (1.0f - t);
    return 1.0f - 0.5f * ((s + 1.0f) * f - s) * f * f;
  }
};

SKTTimingFunction SKTTimingFunctionExtremeBackEaseIn = ^(float t) {
  return (t * t - sinf(t * M_PI)) * t;
};

SKTTimingFunction SKTTimingFunctionExtremeBackEaseOut = ^(float t) {
  const float f = 1.0f - t;
  return 1.0f - (f * f - sinf(f * M_PI)) * f;
};

SKTTimingFunction SKTTimingFunctionExtremeBackEaseInOut = ^(float t) {
  if (t < 0.5f) {
    const float f = 2.0f * t;
    return 0.5f * (f * f - sinf(f * M_PI)) * f;
  } else {
    const float f = 2.0f * (1.0f - t);
    return 1.0f - 0.5f * (f * f - sinf(f * M_PI)) * f;
  }
};

SKTTimingFunction SKTTimingFunctionBounceEaseIn = ^(float t) {
  return 1.0f - SKTTimingFunctionBounceEaseOut(1.0f - t);
};

SKTTimingFunction SKTTimingFunctionBounceEaseOut = ^(float t) {
  if (t < 1.0f / 2.75f) {
    return 7.5625f * t * t;
  } else if (t < 2.0f / 2.75f) {
    t -= 1.5f / 2.75f;
    return 7.5625f * t * t + 0.75f;
  } else if (t < 2.5f / 2.75f) {
    t -= 2.25f / 2.75f;
    return 7.5625f * t * t + 0.9375f;
  } else {
    t -= 2.625f / 2.75f;
    return 7.5625f * t * t + 0.984375f;
  }
};

SKTTimingFunction SKTTimingFunctionBounceEaseInOut = ^(float t) {
  if (t < 0.5f) {
    return 0.5f * SKTTimingFunctionBounceEaseIn(t * 2.0f);
  } else {
    return 0.5f * SKTTimingFunctionBounceEaseOut(t * 2.0f - 1.0f) + 0.5f;
  }
};

SKTTimingFunction SKTTimingFunctionSmoothstep = ^(float t) {
  return t * t * (3 - 2 * t);
};

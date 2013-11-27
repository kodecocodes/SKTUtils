
#import <GLKit/GLKMath.h>
#import "ViewController.h"

////////////////////////////////////////////////////////////////////////////////

#pragma mark - Helper Functions

#define SKT_INLINE static __inline__

SKT_INLINE CGPoint CGPointFromGLKVector2(GLKVector2 vector) {
  return CGPointMake(vector.x, vector.y);
}

SKT_INLINE GLKVector2 GLKVector2FromCGPoint(CGPoint point) {
  return GLKVector2Make(point.x, point.y);
}

SKT_INLINE CGFloat RandomFloat(void) {
  return (CGFloat)arc4random() / 0xFFFFFFFFu;
}

////////////////////////////////////////////////////////////////////////////////

#pragma mark - Functions to Test

SKT_INLINE CGPoint CGPointAdd_1(CGPoint point1, CGPoint point2) {
  return CGPointFromGLKVector2(GLKVector2Add(GLKVector2FromCGPoint(point1), GLKVector2FromCGPoint(point2)));
}

SKT_INLINE CGPoint CGPointAdd_2(CGPoint point1, CGPoint point2) {
  return CGPointMake(point1.x + point2.x, point1.y + point2.y);
}

SKT_INLINE CGPoint CGPointSubtract_1(CGPoint point1, CGPoint point2) {
  return CGPointFromGLKVector2(GLKVector2Subtract(GLKVector2FromCGPoint(point1), GLKVector2FromCGPoint(point2)));
}

SKT_INLINE CGPoint CGPointSubtract_2(CGPoint point1, CGPoint point2) {
  return CGPointMake(point1.x - point2.x, point1.y - point2.y);
}

SKT_INLINE CGPoint CGPointMultiplyScalar_1(CGPoint point, CGFloat value) {
  return CGPointFromGLKVector2(GLKVector2MultiplyScalar(GLKVector2FromCGPoint(point), value));
}

SKT_INLINE CGPoint CGPointMultiplyScalar_2(CGPoint point, CGFloat value) {
  return CGPointMake(point.x * value, point.y * value);
}

SKT_INLINE CGPoint CGPointMultiplyScalar_3(CGPoint point, CGFloat value) {
  return (CGPoint){ point.x * value, point.y * value };
}

SKT_INLINE CGPoint CGPointDivideScalar_1(CGPoint point, CGFloat value) {
  return CGPointFromGLKVector2(GLKVector2DivideScalar(GLKVector2FromCGPoint(point), value));
}

SKT_INLINE CGPoint CGPointDivideScalar_2(CGPoint point, CGFloat value) {
  return CGPointMake(point.x / value, point.y / value);
}

SKT_INLINE CGFloat CGPointLength_1(CGPoint point) {
  return GLKVector2Length(GLKVector2FromCGPoint(point));
}

SKT_INLINE CGFloat CGPointLength_2(CGPoint point) {
  return sqrtf(point.x * point.x + point.y * point.y);
}

SKT_INLINE CGPoint CGPointNormalize_1(CGPoint point) {
  return CGPointFromGLKVector2(GLKVector2Normalize(GLKVector2FromCGPoint(point)));
}

SKT_INLINE CGPoint CGPointNormalize_2(CGPoint point) {
  CGFloat scale = 1.0f / sqrtf(point.x * point.x + point.y * point.y);
  return CGPointMake(point.x * scale, point.y * scale);
}

SKT_INLINE CGPoint CGPointNormalize_3(CGPoint point) {
  return CGPointMultiplyScalar_2(point, 1.0f/CGPointLength_2(point));
}

SKT_INLINE CGPoint CGPointNormalize_4(CGPoint point) {
  return CGPointDivideScalar_2(point, CGPointLength_2(point));
}

////////////////////////////////////////////////////////////////////////////////

#pragma mark - Test Code

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  #if defined(__ARM_NEON__)
  NSLog(@"Compiled for ARM NEON");
  #endif
}

- (IBAction)runTest:(id)sender
{
  const int Iterations = 500000000;  // iPhone 4
  //const int Iterations = 1000000000;  // iPhone 5

  const int SampleSize = 1000000;
  CGPoint *testValues = calloc(SampleSize, sizeof(CGPoint));
  for (int t = 0; t < SampleSize; ++t) {
    testValues[t] = CGPointMake(RandomFloat() * 1000.0f, RandomFloat() * 2000.0f);
  }

  //////////////////////////////////////////////////////////////////////////////

  NSLog(@"---------------------");
  NSLog(@"ADD TEST");

  {
    CFTimeInterval start = CACurrentMediaTime();

    CGPoint p3;
    for (int t = 0; t < Iterations; ++t) {
      CGPoint p1 = testValues[t % SampleSize];
      CGPoint p2 = CGPointMake(t*2, t*2);
      p3 = CGPointAdd_1(p1, p2);
    }

    CFTimeInterval end = CACurrentMediaTime();
    NSLog(@"result = %@", NSStringFromCGPoint(p3));
    NSLog(@"Add_1 = %f seconds", end - start);
  }

  {
    CFTimeInterval start = CACurrentMediaTime();

    CGPoint p3;
    for (int t = 0; t < Iterations; ++t) {
      CGPoint p1 = testValues[t % SampleSize];
      CGPoint p2 = CGPointMake(t*2, t*2);
      p3 = CGPointAdd_2(p1, p2);
    }

    CFTimeInterval end = CACurrentMediaTime();
    NSLog(@"result = %@", NSStringFromCGPoint(p3));
    NSLog(@"Add_2 = %f seconds", end - start);
  }

  //////////////////////////////////////////////////////////////////////////////

  NSLog(@"---------------------");
  NSLog(@"SUBTRACT TEST");

  {
    CFTimeInterval start = CACurrentMediaTime();

    CGPoint p3;
    for (int t = 0; t < Iterations; ++t) {
      CGPoint p1 = testValues[t % SampleSize];
      CGPoint p2 = CGPointMake(t*2, t*2);
      p3 = CGPointSubtract_1(p1, p2);
    }

    CFTimeInterval end = CACurrentMediaTime();
    NSLog(@"result = %@", NSStringFromCGPoint(p3));
    NSLog(@"Subtract_1 = %f seconds", end - start);
  }

  {
    CFTimeInterval start = CACurrentMediaTime();

    CGPoint p3;
    for (int t = 0; t < Iterations; ++t) {
      CGPoint p1 = testValues[t % SampleSize];
      CGPoint p2 = CGPointMake(t*2, t*2);
      p3 = CGPointSubtract_2(p1, p2);
    }

    CFTimeInterval end = CACurrentMediaTime();
    NSLog(@"result = %@", NSStringFromCGPoint(p3));
    NSLog(@"Subtract_2 = %f seconds", end - start);
  }

  //////////////////////////////////////////////////////////////////////////////

  NSLog(@"---------------------");
  NSLog(@"MULTIPLY SCALAR TEST");

  {
    CFTimeInterval start = CACurrentMediaTime();

    CGPoint p2;
    for (int t = 0; t < Iterations; ++t) {
      CGPoint p1 = testValues[t % SampleSize];
      p2 = CGPointMultiplyScalar_1(p1, t);
    }

    CFTimeInterval end = CACurrentMediaTime();
    NSLog(@"result = %@", NSStringFromCGPoint(p2));
    NSLog(@"MultiplyScalar_1 = %f seconds", end - start);
  }

  {
    CFTimeInterval start = CACurrentMediaTime();

    CGPoint p2;
    for (int t = 0; t < Iterations; ++t) {
      CGPoint p1 = testValues[t % SampleSize];
      p2 = CGPointMultiplyScalar_2(p1, t);
    }

    CFTimeInterval end = CACurrentMediaTime();
    NSLog(@"result = %@", NSStringFromCGPoint(p2));
    NSLog(@"MultiplyScalar_2 = %f seconds", end - start);
  }

  //////////////////////////////////////////////////////////////////////////////

  NSLog(@"---------------------");
  NSLog(@"LENGTH TEST");

  const int LengthIterations = Iterations / 10;

  {
    CFTimeInterval start = CACurrentMediaTime();

    CGFloat l = 0;
    for (int t = 0; t < LengthIterations; ++t) {
      CGPoint p1 = testValues[t % SampleSize];
      l += CGPointLength_1(p1);
    }

    CFTimeInterval end = CACurrentMediaTime();
    NSLog(@"result = %f", l);
    NSLog(@"Length_1 = %f seconds", end - start);
  }

  {
    CFTimeInterval start = CACurrentMediaTime();

    CGFloat l = 0;
    for (int t = 0; t < LengthIterations; ++t) {
      CGPoint p1 = testValues[t % SampleSize];
      l += CGPointLength_2(p1);
    }

    CFTimeInterval end = CACurrentMediaTime();
    NSLog(@"result = %f", l);
    NSLog(@"Length_2 = %f seconds", end - start);
  }

  //////////////////////////////////////////////////////////////////////////////

  NSLog(@"---------------------");
  NSLog(@"NORMALIZE TEST");

  const int NormalizeIterations = Iterations / 10;

  {
    CFTimeInterval start = CACurrentMediaTime();

    CGPoint p2;
    for (int t = 0; t < NormalizeIterations; ++t) {
      CGPoint p1 = testValues[t % SampleSize];
      p2 = CGPointNormalize_1(p1);
    }

    CFTimeInterval end = CACurrentMediaTime();
    NSLog(@"result = %@", NSStringFromCGPoint(p2));
    NSLog(@"Normalize_1 = %f seconds", end - start);
  }

  {
    CFTimeInterval start = CACurrentMediaTime();

    CGPoint p2;
    for (int t = 0; t < NormalizeIterations; ++t) {
      CGPoint p1 = testValues[t % SampleSize];
      p2 = CGPointNormalize_2(p1);
    }

    CFTimeInterval end = CACurrentMediaTime();
    NSLog(@"result = %@", NSStringFromCGPoint(p2));
    NSLog(@"Normalize_2 = %f seconds", end - start);
  }

  //////////////////////////////////////////////////////////////////////////////

  free(testValues);

  NSLog(@"=== END ===");
}

@end

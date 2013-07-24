//
//  ViewController.m
//  SpeedTest
//
//  Created by Matthijs on 24-07-13.
//  Copyright (c) 2013 Razeware. All rights reserved.
//

#import <GLKit/GLKMath.h>
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#define SKT_INLINE      static __inline__

SKT_INLINE CGPoint CGPointFromGLKVector2(GLKVector2 vector)
{
    return CGPointMake(vector.x, vector.y);
}

SKT_INLINE GLKVector2 GLKVector2FromCGPoint(CGPoint point)
{
    return GLKVector2Make(point.x, point.y);
}

SKT_INLINE CGPoint CGPointAdd1(CGPoint point1, CGPoint point2) {
    return CGPointFromGLKVector2(GLKVector2Add(GLKVector2FromCGPoint(point1), GLKVector2FromCGPoint(point2)));
}

SKT_INLINE CGPoint CGPointAdd2(CGPoint point1, CGPoint point2) {
	return CGPointMake(point1.x + point2.x, point1.y + point2.y);
}

SKT_INLINE CGPoint CGPointSubtract1(CGPoint point1, CGPoint point2)
{
    return CGPointFromGLKVector2(GLKVector2Subtract(GLKVector2FromCGPoint(point1), GLKVector2FromCGPoint(point2)));
}

SKT_INLINE CGPoint CGPointSubtract2(CGPoint point1, CGPoint point2) {
    return CGPointMake(point1.x - point2.x, point1.y - point2.y);
}

SKT_INLINE CGPoint CGPointMultiplyScalar1(CGPoint point, CGFloat value) {
    return CGPointFromGLKVector2(GLKVector2MultiplyScalar(GLKVector2FromCGPoint(point), value));
}

SKT_INLINE CGPoint CGPointMultiplyScalar2(CGPoint point, CGFloat value) {
	return CGPointMake(point.x * value, point.y * value);
}

//SKT_INLINE CGPoint CGPointMultiplyScalar2(CGPoint point, CGFloat value) {
//	return (CGPoint){ point.x * value, point.y * value };
//}

SKT_INLINE CGFloat CGPointLength1(CGPoint point) {
    return GLKVector2Length(GLKVector2FromCGPoint(point));
}

SKT_INLINE CGFloat CGPointLength2(CGPoint point) {
	return sqrtf(point.x * point.x + point.y * point.y);
}

SKT_INLINE CGPoint CGPointNormalize1(CGPoint point) {
    return CGPointFromGLKVector2(GLKVector2Normalize(GLKVector2FromCGPoint(point)));
}

//SKT_INLINE CGPoint CGPointNormalize2(CGPoint point) {
//	return CGPointMultiplyScalar2(point, 1.0f/CGPointLength2(point));
//}

SKT_INLINE CGPoint CGPointNormalize2(CGPoint point) {
	CGFloat scale = 1.0f / sqrtf(point.x * point.x + point.y * point.y);
	return CGPointMake(point.x * scale, point.y * scale);
}

//SKT_INLINE CGPoint CGPointDivideScalar2(CGPoint point, CGFloat value) {
//	return CGPointMake(point.x / value, point.y / value);
//}
//
//SKT_INLINE CGPoint CGPointNormalize2(CGPoint point) {
//	return CGPointDivideScalar2(point, CGPointLength2(point));
//}

#define ARC4RANDOM_MAX      0xFFFFFFFFu

SKT_INLINE CGFloat RandomFloat(void) {
	return (CGFloat)arc4random()/ARC4RANDOM_MAX;
}

#if defined(__ARM_NEON__)
#warning Compiling for ARM NEON!
#endif

- (IBAction)runTest:(id)sender
{
	const int Iterations = 500000000;  // iPhone 4
	//const int Iterations = 1000000000;  // iPhone 5

	const int SampleSize = 1000000;
	CGPoint *testValues = calloc(SampleSize, sizeof(CGPoint));
	for (int t = 0; t < SampleSize; ++t)
		testValues[t] = CGPointMake(RandomFloat() * 1000.0f, RandomFloat() * 2000.0f);

	NSLog(@"---------------------");
	NSLog(@"ADD TEST");

	{
		CFTimeInterval start = CACurrentMediaTime();
		
		CGPoint p3;
		for (int t = 0; t < Iterations; ++t)
		{
			//CGPoint p1 = CGPointMake(t, t);
			CGPoint p1 = testValues[t % SampleSize];
			CGPoint p2 = CGPointMake(t*2, t*2);
			p3 = CGPointAdd1(p1, p2);
		}

		CFTimeInterval end = CACurrentMediaTime();
		NSLog(@"p3 = %@", NSStringFromCGPoint(p3));
		NSLog(@"Add1 = %f seconds", end - start);
	}

	{
		CFTimeInterval start = CACurrentMediaTime();
		
		CGPoint p3;
		for (int t = 0; t < Iterations; ++t)
		{
			//CGPoint p1 = CGPointMake(t, t);
			CGPoint p1 = testValues[t % SampleSize];
			CGPoint p2 = CGPointMake(t*2, t*2);
			p3 = CGPointAdd2(p1, p2);
		}

		CFTimeInterval end = CACurrentMediaTime();
		NSLog(@"p3 = %@", NSStringFromCGPoint(p3));
		NSLog(@"Add2 = %f seconds", end - start);
	}

	NSLog(@"---------------------");
	NSLog(@"SUBTRACT TEST");

	{
		CFTimeInterval start = CACurrentMediaTime();
		
		CGPoint p3;
		for (int t = 0; t < Iterations; ++t)
		{
			//CGPoint p1 = CGPointMake(t, t);
			CGPoint p1 = testValues[t % SampleSize];
			CGPoint p2 = CGPointMake(t*2, t*2);
			p3 = CGPointSubtract1(p1, p2);
		}

		CFTimeInterval end = CACurrentMediaTime();
		NSLog(@"p3 = %@", NSStringFromCGPoint(p3));
		NSLog(@"Subtract1 = %f seconds", end - start);
	}

	{
		CFTimeInterval start = CACurrentMediaTime();
		
		CGPoint p3;
		for (int t = 0; t < Iterations; ++t)
		{
			//CGPoint p1 = CGPointMake(t, t);
			CGPoint p1 = testValues[t % SampleSize];
			CGPoint p2 = CGPointMake(t*2, t*2);
			p3 = CGPointSubtract2(p1, p2);
		}

		CFTimeInterval end = CACurrentMediaTime();
		NSLog(@"p3 = %@", NSStringFromCGPoint(p3));
		NSLog(@"Subtract2 = %f seconds", end - start);
	}

	NSLog(@"---------------------");
	NSLog(@"MULTIPLY TEST");

	{
		CFTimeInterval start = CACurrentMediaTime();
		
		CGPoint p2;
		for (int t = 0; t < Iterations; ++t)
		{
			//CGPoint p1 = CGPointMake(t, t);
			CGPoint p1 = testValues[t % SampleSize];
			p2 = CGPointMultiplyScalar1(p1, t);
		}

		CFTimeInterval end = CACurrentMediaTime();
		NSLog(@"p2 = %@", NSStringFromCGPoint(p2));
		NSLog(@"Multiply1 = %f seconds", end - start);
	}

	{
		CFTimeInterval start = CACurrentMediaTime();
		
		CGPoint p2;
		for (int t = 0; t < Iterations; ++t)
		{
			//CGPoint p1 = CGPointMake(t, t);
			CGPoint p1 = testValues[t % SampleSize];
			p2 = CGPointMultiplyScalar2(p1, t);
		}

		CFTimeInterval end = CACurrentMediaTime();
		NSLog(@"p2 = %@", NSStringFromCGPoint(p2));
		NSLog(@"Multiply2 = %f seconds", end - start);
	}
	
	NSLog(@"---------------------");
	NSLog(@"LENGTH TEST");

	const int LengthIterations = Iterations / 10;

	{
		CFTimeInterval start = CACurrentMediaTime();

		CGFloat l = 0;
		for (int t = 0; t < LengthIterations; ++t)
		{
			//CGPoint p1 = CGPointMake((float)t/LengthIterations, (float)t*2/LengthIterations);
			CGPoint p1 = testValues[t % SampleSize];
			l += CGPointLength1(p1);
		}

		CFTimeInterval end = CACurrentMediaTime();
		NSLog(@"l = %f", l);
		NSLog(@"Length1 = %f seconds", end - start);
	}

	{
		CFTimeInterval start = CACurrentMediaTime();

		CGFloat l = 0;
		for (int t = 0; t < LengthIterations; ++t)
		{
			//CGPoint p1 = CGPointMake((float)t/LengthIterations, (float)t*2/LengthIterations);
			CGPoint p1 = testValues[t % SampleSize];
			l += CGPointLength2(p1);
		}

		CFTimeInterval end = CACurrentMediaTime();
		NSLog(@"l = %f", l);
		NSLog(@"Length2 = %f seconds", end - start);
	}

	NSLog(@"---------------------");
	NSLog(@"NORMALIZE TEST");

	const int NormalizeIterations = Iterations / 10;

	{
		CFTimeInterval start = CACurrentMediaTime();

		CGPoint p2;
		for (int t = 0; t < NormalizeIterations; ++t)
		{
			//CGPoint p1 = CGPointMake((float)t/NormalizeIterations, (float)t*2/NormalizeIterations);
			CGPoint p1 = testValues[t % SampleSize];
			p2 = CGPointNormalize1(p1);
		}

		CFTimeInterval end = CACurrentMediaTime();
		NSLog(@"p2 = %@", NSStringFromCGPoint(p2));
		NSLog(@"Normalize1 = %f seconds", end - start);
	}

	{
		CFTimeInterval start = CACurrentMediaTime();

		CGPoint p2;
		for (int t = 0; t < NormalizeIterations; ++t)
		{
			//CGPoint p1 = CGPointMake((float)t/NormalizeIterations, (float)t*2/NormalizeIterations);
			CGPoint p1 = testValues[t % SampleSize];
			p2 = CGPointNormalize2(p1);
		}

		CFTimeInterval end = CACurrentMediaTime();
		NSLog(@"p2 = %@", NSStringFromCGPoint(p2));
		NSLog(@"Normalize2 = %f seconds", end - start);
	}

	free(testValues);

	NSLog(@"===END===");
}

@end

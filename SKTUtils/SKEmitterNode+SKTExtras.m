
#import "SKEmitterNode+SKTExtras.h"

@implementation SKEmitterNode (SKTExtras)

+ (instancetype)skt_emitterNamed:(NSString *)name
{
	return [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:name ofType:@"sks"]];
}

@end

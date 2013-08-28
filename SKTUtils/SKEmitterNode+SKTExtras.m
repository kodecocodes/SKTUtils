
#import "SKEmitterNode+SKTExtras.h"

@implementation SKEmitterNode (SKTExtras)

+ (instancetype)skt_emitterNamed:(NSString *)name
{
	SKEmitterNode *emitter = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:name ofType:@"sks"]];
	emitter.particleTexture.filteringMode = SKTextureFilteringNearest;
	return emitter;
}

@end


#import "SKAction+SKTExtras.h"

@implementation SKAction (SKTExtras)

+ (instancetype)skt_afterDelay:(NSTimeInterval)duration perform:(SKAction *)action
{
	return [SKAction sequence:@[[SKAction waitForDuration:duration], action]];
}

+ (instancetype)skt_afterDelay:(NSTimeInterval)duration runBlock:(dispatch_block_t)block
{
	return [self skt_afterDelay:duration perform:[SKAction runBlock:block]];
}

+ (instancetype)skt_removeFromParentAfterDelay:(NSTimeInterval)duration
{
	return [self skt_afterDelay:duration perform:[SKAction removeFromParent]];
}

@end


#import "SKNode+SKTExtras.h"

@implementation SKNode (SKTExtras)

- (void)skt_performSelector:(SEL)selector onTarget:(id)target afterDelay:(NSTimeInterval)delay
{
	[self runAction:
		[SKAction sequence:@[
			[SKAction waitForDuration:delay],
			[SKAction performSelector:selector onTarget:target],
			]]];
}

- (void)skt_bringToFront
{
	SKNode *parent = self.parent;
	[self removeFromParent];
	[parent addChild:self];
}

@end

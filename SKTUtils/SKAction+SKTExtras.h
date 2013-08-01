
#import <SpriteKit/SpriteKit.h>

@interface SKAction (SKTExtras)

// Shorthand for:
//   [SKAction sequence:@[[SKAction waitForDuration:duration], action]]
//
+ (instancetype)skt_afterDelay:(NSTimeInterval)duration perform:(SKAction *)action;

// Shorthand for:
//   [SKAction sequence:@[[SKAction waitForDuration:duration], [SKAction runBlock:^{ ... }]]]
//
+ (instancetype)skt_afterDelay:(NSTimeInterval)duration runBlock:(dispatch_block_t)block;

// Shorthand for:
//   [SKAction sequence:@[[SKAction waitForDuration:duration], [SKAction removeFromParent]]]
//
+ (instancetype)skt_removeFromParentAfterDelay:(NSTimeInterval)duration;

@end

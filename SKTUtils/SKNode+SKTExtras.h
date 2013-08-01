
#import <SpriteKit/SpriteKit.h>

@interface SKNode (SKTExtras)

- (void)skt_performSelector:(SEL)selector onTarget:(id)target afterDelay:(NSTimeInterval)delay;

- (void)skt_bringToFront;

@end

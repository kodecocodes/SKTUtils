
#import "MyScene.h"
#import "SKTUtils.h"
#import "SKTEffects.h"
#import "SKAction+SKTExtras.h"
#import "SKAction+SKTSpecialEffects.h"
#import "SKNode+SKTExtras.h"
#import "SKNode+SKTDebugDraw.h"

// These flags enable (1) or disable (0) the various effects that happen when
// a ball collides with a border, the barrier, or another ball. Turning them
// all on at the same time might result in sea sickness... ;-)
#define FLASH_BALL     0
#define FLASH_BORDER   1
#define FLASH_BARRIER  1
#define SCALE_BALL     1
#define SCALE_BORDER   1
#define SCALE_BARRIER  1
#define SQUASH_BALL    0
#define STRETCH_BALL   0
#define SCREEN_SHAKE   1
#define SCREEN_ZOOM    1
#define SCREEN_TUMBLE  1
#define COLOR_GLITCH   0
#define BARRIER_JELLY  1

// How fat the borders around the screen are
static const CGFloat BorderThickness = 20.0;

// Categories for physics collisions
static const uint32_t BallCategory    = 1 << 0;
static const uint32_t BorderCategory  = 1 << 1;
static const uint32_t BarrierCategory = 1 << 2;

@interface MyScene () <SKPhysicsContactDelegate>

@end

@implementation MyScene {
  // The layer that contains all the nodes. Having a separate world node is
  // necessary for the screen shake effect because you cannot apply that to
  // an SKScene directly.
  SKNode *_worldLayer;

  // For screen zoom and tumble, the world layer must sit in a separate pivot
  // node that centers the world on the screen.
  SKNode *_worldPivot;

  SKColor *_sceneBackgroundColor;
  SKColor *_borderColor;
  SKColor *_borderFlashColor;
  SKColor *_barrierColor;
  SKColor *_barrierFlashColor;
  SKColor *_ballFlashColor;
}

- (id)initWithSize:(CGSize)size {
  if (self = [super initWithSize:size]) {
    [self setUpScene];
  }
  return self;
}

#pragma mark - Initialization

- (void)setUpScene {

  // Preload the font, otherwise there is a small delay when creating the
  // first text label.
  [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue-Light"];

  // Set this to YES to enable debug shapes.
  SKTDebugDrawEnabled = NO;

  _sceneBackgroundColor = SKColorWithRGB(8, 57, 71);
  _borderColor = SKColorWithRGB(160, 160, 160);
  _borderFlashColor = [SKColor whiteColor];
  _barrierColor = SKColorWithRGB(212, 212, 212);
  _barrierFlashColor = _borderFlashColor;
  _ballFlashColor = [SKColor redColor];

  self.scaleMode = SKSceneScaleModeResizeFill;
  self.backgroundColor = _sceneBackgroundColor;

  // By placing the scene's anchor point in the center of the screen and the
  // world layer at the scene's origin, you can make the entire scene rotate
  // around its center (for example for the screen tumble effect). You need
  // to set the anchor point before you add the world pivot node.
  self.anchorPoint = CGPointMake(0.5, 0.5);

  // The origin of the pivot node must be the center of the screen.
  _worldPivot = [SKNode node];
  [self addChild:_worldPivot];

  // Create the world layer. This is the only node that is added directly
  // to the pivot node. If you have a HUD layer you would add that directly
  // to the scene and make it sit above the world layer.
  _worldLayer = [SKNode node];
  _worldLayer.position = self.frame.origin;
  [_worldPivot addChild:_worldLayer];

  self.physicsWorld.gravity = CGVectorMake(0, 0);
  self.physicsWorld.contactDelegate = self;

  // Put the game objects into the world. We use delays here to make some
  // objects appear earlier than others, which looks cooler.
  [self addBorders];
  [self skt_performSelector:@selector(addBarrier) onTarget:self afterDelay:1.5];
  [self skt_performSelector:@selector(addBalls) onTarget:self afterDelay:2.5];
  [self skt_performSelector:@selector(showLabel) onTarget:self afterDelay:6.0];

  // Make the barrier rotate around its center.
  [self skt_performSelector:@selector(animateBarrier) onTarget:self afterDelay:4.0];
}

- (void)addBorders {
  // Create four border nodes, one for each screen edge. The nodes all have
  // the same shape -- a rectangle that is taller than it is wide -- but are
  // rotated by different angles.

  const CGFloat Distance = 50.0;

  SKNode *leftBorder = [self newBorderNodeWithLength:self.size.height horizontal:NO];
  leftBorder.position = CGPointMake(BorderThickness / 2.0 - Distance, self.size.height / 2.0);
  [_worldLayer addChild:leftBorder];

  SKNode *rightBorder = [self newBorderNodeWithLength:self.size.height horizontal:NO];
  rightBorder.position = CGPointMake(self.size.width - BorderThickness/2.0 + Distance, self.size.height / 2.0);
  rightBorder.zRotation = M_PI;
  [_worldLayer addChild:rightBorder];

  SKNode *topBorder = [self newBorderNodeWithLength:self.size.width horizontal:YES];
  topBorder.position = CGPointMake(self.size.width / 2.0, self.size.height - BorderThickness / 2.0 + Distance);
  topBorder.zRotation = -M_PI_2;
  [_worldLayer addChild:topBorder];

  SKNode *bottomBorder = [self newBorderNodeWithLength:self.size.width horizontal:YES];
  bottomBorder.position = CGPointMake(self.size.width / 2.0, BorderThickness / 2.0 - Distance);
  bottomBorder.zRotation = M_PI_2;
  [_worldLayer addChild:bottomBorder];

  // Make the borders appear with a bounce animation.

  [self addEffectToBorder:leftBorder startPosition:leftBorder.position endPosition:CGPointMake(leftBorder.position.x + Distance, leftBorder.position.y) delay:0.5];

  [self addEffectToBorder:rightBorder startPosition:rightBorder.position endPosition:CGPointMake(rightBorder.position.x - Distance, rightBorder.position.y) delay:0.5];

  [self addEffectToBorder:topBorder startPosition:topBorder.position endPosition:CGPointMake(topBorder.position.x, topBorder.position.y - Distance) delay:1.0];

  [self addEffectToBorder:bottomBorder startPosition:bottomBorder.position endPosition:CGPointMake(bottomBorder.position.x, bottomBorder.position.y + Distance) delay:1.0];
}

- (SKNode *)newBorderNodeWithLength:(CGFloat)length horizontal:(BOOL)horizontal {
  UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0.0, 0.0, BorderThickness, length)];

  SKPhysicsBody *body = [SKPhysicsBody bodyWithPolygonFromPath:path.CGPath];
  body.dynamic = NO;
  body.friction = 0.0;
  body.linearDamping = 0.0;
  body.angularDamping = 0.0;
  body.restitution = 0.0;
  body.categoryBitMask = BorderCategory;
  body.collisionBitMask = BallCategory;
  body.contactTestBitMask = BallCategory;

  SKShapeNode *node = [SKShapeNode node];
  node.path = path.CGPath;
  node.fillColor = _borderColor;
  node.strokeColor = [SKColor clearColor];
  node.lineWidth = 0.0;
  node.glowWidth = 0.0;
  node.physicsBody = body;
  node.name = horizontal ? @"horizontalBorder" : @"verticalBorder";
  node.position = CGPointMake(-BorderThickness / 2.0, -length / 2.0);

  SKNode *pivotNode = [SKNode node];
  [pivotNode addChild:node];
  return pivotNode;
}

- (void)addEffectToBorder:(SKNode *)border startPosition:(CGPoint)startPosition endPosition:(CGPoint)endPosition delay:(NSTimeInterval)delay {
  SKTMoveEffect *moveEffect = [SKTMoveEffect effectWithNode:border duration:0.5 startPosition:startPosition endPosition:endPosition];
  moveEffect.timingFunction = SKTTimingFunctionBounceEaseOut;
  [border runAction:[SKAction skt_afterDelay:delay perform:[SKAction actionWithEffect:moveEffect]]];
}

- (void)addBarrier {
  // Create a node that sits in the middle of the screen so the balls have
  // something to bump into.

  // SKShapeNode does not have an anchorPoint property, so create a pivot
  // node that acts as the anchor point, and place it in the screen center.
  SKNode *pivotNode = [SKNode node];
  pivotNode.name = @"barrier";
  pivotNode.position = CGPointMake(self.size.width / 2.0, self.size.height / 2.0);
  pivotNode.zRotation = M_PI_2;
  [_worldLayer addChild:pivotNode];

  const CGFloat width = BorderThickness * 2;
  const CGFloat height = 140;
  UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, width, height)];

  // Create the shape node that draws the barrier on the screen. This is a
  // child of the pivot node, so it rotates and scales along with the pivot.
  SKShapeNode *node = [SKShapeNode node];
  node.path = path.CGPath;
  node.fillColor = _barrierColor;
  node.strokeColor = [SKColor clearColor];
  node.lineWidth = 0.0;
  node.glowWidth = 0.0;
  node.position = CGPointMake(-width/2.0, -height/2.0);
  [pivotNode addChild:node];

  // Create the physics body. This has the same shape as the shape node
  // but is attached to the pivot node. (It could also have been attached
  // to the shape node -- it doesn't really matter where it goes.)
  SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(width, height)];
  body.dynamic = NO;
  body.friction = 0.0;
  body.linearDamping = 0.0;
  body.angularDamping = 0.0;
  body.restitution = 0.0;
  body.categoryBitMask = BarrierCategory;
  body.collisionBitMask = BallCategory;
  body.contactTestBitMask = body.collisionBitMask;
  pivotNode.physicsBody = body;
  
  // Make the barrier shape appear with an animation. We have to run this
  // action on the pivot node, otherwise it happens from the barrier shape's
  // bottom-left corner instead of its center.

  pivotNode.xScale = pivotNode.yScale = 0.15;
  pivotNode.alpha = 0.0;

  SKTScaleEffect *scaleEffect = [SKTScaleEffect effectWithNode:pivotNode duration:1.0 startScale:pivotNode.skt_scale endScale:CGPointMake(1.0, 1.0)];
  scaleEffect.timingFunction = SKTTimingFunctionBackEaseOut;

  SKTRotateEffect *rotateEffect = [SKTRotateEffect effectWithNode:pivotNode duration:1.0 startAngle:RandomFloat() * M_PI_4 endAngle:pivotNode.zRotation];
  rotateEffect.timingFunction = SKTTimingFunctionBackEaseOut;

  SKAction *action = [SKAction group:@[
    [SKAction fadeInWithDuration:1.0],
    [SKAction actionWithEffect:scaleEffect],
    [SKAction actionWithEffect:rotateEffect]]];

  [pivotNode runAction:action];
}

- (SKNode *)barrierNode {
  return [_worldLayer childNodeWithName:@"barrier"];
}

- (void)animateBarrier {
  // Rotate the barrier by 45 degrees with a "back ease in-out", which makes
  // it look very mechanical.

  SKNode *barrierNode = [self barrierNode];
  [barrierNode runAction:[SKAction repeatActionForever:[SKAction sequence:@[
    [SKAction waitForDuration:0.75],
    [SKAction runBlock:^{
      SKTRotateEffect *effect = [SKTRotateEffect effectWithNode:barrierNode duration:0.25 startAngle:barrierNode.zRotation endAngle:barrierNode.zRotation + M_PI_4];
      effect.timingFunction = SKTTimingFunctionBackEaseInOut;

      [barrierNode runAction:[SKAction actionWithEffect:effect]];
    }]]]]];
}

- (void)addBalls {
  // Add a ball sprite on the left side of the screen...
  SKNode *ball1 = [self newBallNode];
  ball1.position = CGPointMake(100, self.size.height / 2.0);
  [_worldLayer addChild:ball1];

  // ...and add a ball sprite on the right side of the screen.
  SKNode *ball2 = [self newBallNode];
  ball2.position = CGPointMake(self.size.width - 100, self.size.height / 2.0);
  [_worldLayer addChild:ball2];

  [self addEffectToBall:ball1];
  [self addEffectToBall:ball2];
}

- (void)addEffectToBall:(SKNode *)ball {
  ball.xScale = ball.yScale = 0.2;

  SKTScaleEffect *scaleEffect = [SKTScaleEffect effectWithNode:ball duration:0.5 startScale:ball.skt_scale endScale:CGPointMake(1.0, 1.0)];
  scaleEffect.timingFunction = SKTTimingFunctionBackEaseOut;

  [ball runAction:[SKAction actionWithEffect:scaleEffect]];
}

- (SKNode *)newBallNode {
  // Create the sprite.
  SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Ball"];

  // Attach debug shapes.
  [sprite skt_attachDebugCircleWithRadius:sprite.size.width/2.0 color:[SKColor yellowColor]];
  [sprite skt_attachDebugLineFromPoint:CGPointZero toPoint:CGPointMake(0, sprite.size.height / 2.0) color:[SKColor yellowColor]];

  // Assign a random angle to the ball's velocity.
  const CGFloat ballSpeed = 200;
  const CGFloat angle = DegreesToRadians(RandomFloat() * 360);
  const CGVector velocity = CGVectorMake(cos(angle)*ballSpeed, sin(angle)*ballSpeed);

  // Create a circular physics body. It collides with the borders and
  // with other balls. It is slightly smaller than the sprite.
  SKPhysicsBody *body = [SKPhysicsBody bodyWithCircleOfRadius:(sprite.size.width / 2.0) * 0.9];
  body.dynamic = YES;
  body.velocity = velocity;
  body.friction = 0.0;
  body.linearDamping = 0.0;
  body.angularDamping = 0.0;
  body.restitution = 0.9;
  body.categoryBitMask = BallCategory;
  body.collisionBitMask = BorderCategory | BarrierCategory | BallCategory;
  body.contactTestBitMask = body.collisionBitMask;

  // Create a new node to hold the sprite. This is necessary for combining
  // nonuniform scaling effects with rotation. Some of the effects are placed
  // directly on the sprite, some on this pivot node.
  SKNode *pivotNode = [SKNode node];
  pivotNode.name = @"ball";
  pivotNode.physicsBody = body;
  [pivotNode addChild:sprite];
  return pivotNode;
}

- (void)showLabel {
  // Adds a label with instructions.

  SKLabelNode *labelNode = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue-Light"];
  labelNode.text = NSLocalizedString(@"Tap to apply random impulse", @"IntroMessage");
  labelNode.fontSize = 12;
  [self addChild:labelNode];

  labelNode.position = CGPointOffset(labelNode.position, 0.0, 100.0);

  SKTMoveEffect *moveEffect = [SKTMoveEffect effectWithNode:labelNode duration:4.0 startPosition:labelNode.position endPosition:CGPointOffset(labelNode.position, 0.0, 20.0)];

  moveEffect.timingFunction = SKTTimingFunctionSmoothstep;
  [labelNode runAction:[SKAction actionWithEffect:moveEffect]];

  labelNode.alpha = 0.0;
  [labelNode runAction:[SKAction sequence:@[
	[SKAction waitForDuration:0.5],
    [SKAction fadeInWithDuration:2.0],
	[SKAction waitForDuration:1.0],
	[SKAction fadeOutWithDuration:1.0]
    ]]];
}

#pragma mark - Touch Handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  // Add a random impulse to the balls whenever the user taps the screen.
  [_worldLayer enumerateChildNodesWithName:@"ball" usingBlock:^(SKNode *node, BOOL *stop) {
    const CGFloat max = 50.0;
    const CGVector impulse = CGVectorMake(RandomFloatRange(-max, max), RandomFloatRange(-max, max));
    [node.physicsBody applyImpulse:impulse];

    #if STRETCH_BALL
    [self stretchBall:node.children[0]];
    #endif
  }];
}

#pragma mark - Game Logic

- (void)update:(CFTimeInterval)currentTime {
  // do nothing
}

- (void)didSimulatePhysics {
  // Rotate the balls into the direction that they're flying.
  [_worldLayer enumerateChildNodesWithName:@"ball" usingBlock:^(SKNode *node, BOOL *stop) {
    [node skt_rotateToVelocity:node.physicsBody.velocity rate:0.1];
  }];
}

- (void)didBeginContact:(SKPhysicsContact *)contact {
  [self checkContactBetweenBody1:contact.bodyA body2:contact.bodyB contactPoint:contact.contactPoint];
  [self checkContactBetweenBody1:contact.bodyB body2:contact.bodyA contactPoint:contact.contactPoint];
}

- (void)checkContactBetweenBody1:(SKPhysicsBody *)body1 body2:(SKPhysicsBody *)body2 contactPoint:(CGPoint)contactPoint {
  if (body1.categoryBitMask & BallCategory) {
    [self handleBallCollision:(SKSpriteNode *)body1.node];

    if (body2.categoryBitMask & BorderCategory) {
      [self handleCollisionBetweenBall:body1.node border:(SKShapeNode *)body2.node contactPoint:contactPoint];
    } else if (body2.categoryBitMask & BarrierCategory) {
      [self handleCollisionBetweenBall:body1.node barrier:(SKShapeNode *)body2.node];
    }
  }
}

- (void)handleBallCollision:(SKNode *)node {
  // This method gets called when a ball hits any other node.

  SKSpriteNode *ballSprite = node.children[0];

  #if FLASH_BALL
  [self flashSpriteNode:ballSprite withColor:_ballFlashColor];
  #endif

  #if SCALE_BALL
  [self scaleBall:ballSprite];
  #endif

  #if SQUASH_BALL
  [self squashBall:ballSprite];
  #endif

  #if SCREEN_SHAKE
  [self screenShakeWithVelocity:node.physicsBody.velocity];
  #endif

  #if SCREEN_ZOOM
  [self screenZoomWithVelocity:node.physicsBody.velocity];
  #endif
}

- (void)handleCollisionBetweenBall:(SKNode *)ball border:(SKShapeNode *)border contactPoint:(CGPoint)contactPoint {
  // Draw the flashing border above the other borders.
  [border skt_bringToFront];

  #if FLASH_BORDER
  [self flashShapeNode:border fromColor:_borderFlashColor toColor:_borderColor];
  #endif

  #if BARRIER_JELLY
  [self jelly:[self barrierNode]];
  #endif

  #if SCREEN_TUMBLE
  [self screenTumbleAtContactPoint:contactPoint border:border];
  #endif
  
  #if SCALE_BORDER
  [self scaleBorder:border];
  #endif
}

- (void)handleCollisionBetweenBall:(SKNode *)ball barrier:(SKShapeNode *)barrier {

  #if SCALE_BARRIER
  [self scaleBarrier:barrier];
  #endif

  #if FLASH_BARRIER
  SKShapeNode *node = (SKShapeNode *)barrier.children[0];
  [self flashShapeNode:node fromColor:_barrierFlashColor toColor:_barrierColor];
  #endif

  #if COLOR_GLITCH
  [self runAction:[SKAction skt_colorGlitchWithScene:self originalColor:_sceneBackgroundColor duration:0.1]];
  #endif
}

#pragma mark - Special Effects

- (void)flashSpriteNode:(SKNode *)node withColor:(SKColor *)color {
  // Colorizes the node for a brief moment and then fades back to
  // the original color.

  SKAction *action = [SKAction sequence:@[
    [SKAction colorizeWithColor:color colorBlendFactor:1.0 duration:0.025],
    [SKAction waitForDuration:0.05],
    [SKAction colorizeWithColorBlendFactor:0.0 duration:0.1]]];

  [node runAction:action];
}

- (void)flashShapeNode:(SKShapeNode *)node fromColor:(SKColor *)fromColor toColor:(SKColor *)toColor {
  // Changes the fill color of the node for a brief moment and then
  // restores the original color.

  node.fillColor = fromColor;

  SKAction *action = [SKAction sequence:@[
    [SKAction waitForDuration:0.15],
    [SKAction runBlock:^{ node.fillColor = toColor; }]]];

  [node runAction:action];
}

- (void)scaleBall:(SKNode *)node {
  // Scales the ball up and then down again. This effect is cumulative; if
  // the ball collides again while still scaled up, it scales up even more.

  CGPoint currentScale = [node skt_scale];
  CGPoint newScale = CGPointMultiplyScalar(currentScale, 1.2);

  SKTScaleEffect *effect = [SKTScaleEffect effectWithNode:node duration:1.5 startScale:newScale endScale:currentScale];
  effect.timingFunction = SKTTimingFunctionElasticEaseOut;

  [node runAction:[SKAction actionWithEffect:effect]];
}

- (void)squashBall:(SKNode *)node {
  // Makes the ball wider but flatter, keeping the overall volume the same.
  // Squashing is useful for when an object collides with another object.

  const CGFloat ratio = 1.5;
  CGPoint currentScale = [node skt_scale];
  CGPoint newScale = CGPointMultiply(currentScale, CGPointMake(ratio, 1.0/ratio));

  SKTScaleEffect *effect = [SKTScaleEffect effectWithNode:node duration:1.5 startScale:newScale endScale:currentScale];
  effect.timingFunction = SKTTimingFunctionElasticEaseOut;

  [node runAction:[SKAction actionWithEffect:effect]];
}

- (void)stretchBall:(SKNode *)node {
  // Makes the ball thinner but taller, keeping the overall volume the same.
  // Stretching is useful for when an object accelerates.

  const CGFloat ratio = 1.5;
  CGPoint currentScale = [node skt_scale];
  CGPoint newScale = CGPointMultiply(currentScale, CGPointMake(1.0/ratio, ratio));

  SKTScaleEffect *effect = [SKTScaleEffect effectWithNode:node duration:0.5 startScale:newScale endScale:currentScale];
  effect.timingFunction = SKTTimingFunctionCubicEaseOut;

  [node runAction:[SKAction actionWithEffect:effect]];
}

- (void)scaleBorder:(SKNode *)node {
  // Scale the border in the X direction. Because shape nodes do not have an
  // anchor point, this keeps the bottom-left corner fixed. Because the border
  // nodes are rotated, this makes them grow into the scene, which looks cool.

  CGPoint currentScale = [node skt_scale];
  CGPoint newScale = CGPointMake(currentScale.x * 2.0, currentScale.y);

  SKTScaleEffect *effect = [SKTScaleEffect effectWithNode:node duration:1.0 startScale:newScale endScale:currentScale];
  effect.timingFunction = SKTTimingFunctionElasticEaseOut;

  [node runAction:[SKAction actionWithEffect:effect]];
}

- (void)scaleBarrier:(SKNode *)node {
  // Quickly scale the barrier down and up again.

  CGPoint currentScale = [node skt_scale];
  CGPoint newScale = CGPointMultiplyScalar(currentScale, 0.5);

  SKTScaleEffect *effect = [SKTScaleEffect effectWithNode:node duration:0.5 startScale:newScale endScale:currentScale];
  effect.timingFunction = SKTTimingFunctionElasticEaseOut;

  [node runAction:[SKAction actionWithEffect:effect]];
}

- (void)screenShakeWithVelocity:(CGVector)velocity {
  // Creates a screen shake in the direction of the velocity vector, with
  // an intensity that is proportional to the velocity's magnitude.

  // Note: The velocity is from *after* the collision, so the ball is already
  // travelling in the opposite direction. To find the impact vector we have
  // to negate the velocity. Unfortunately, if the collision is only in the X
  // direction, the Y direction also gets flipped (and vice versa). It would
  // be better if we could get the velocity at exactly the moment of impact,
  // but Sprite Kit doesn't seem to make this easy.

  CGPoint inverseVelocity = CGPointMake(-velocity.dx, -velocity.dy);
  CGPoint hitVector = CGPointDivideScalar(inverseVelocity, 50.0);

  [_worldLayer runAction:[SKAction skt_screenShakeWithNode:_worldLayer amount:hitVector oscillations:10 duration:3.0]];
}

- (void)screenZoomWithVelocity:(CGVector)velocity {
  // Magnify the screen by a tiny amount (102%) and bounce back to 100%.
  CGPoint amount = CGPointMake(1.02, 1.02);
  [_worldPivot runAction:[SKAction skt_screenZoomWithNode:_worldPivot amount:amount oscillations:10 duration:3.0]];
}

- (void)screenTumbleAtContactPoint:(CGPoint)point border:(SKShapeNode *)border {
  // Rotate the scene around its center. The amount of rotation depends on
  // where the ball hit the border (further from the center is a bigger angle).

  CGFloat length;
  if ([border.name isEqualToString:@"horizontalBorder"]) {
    length = self.size.width / 2.0;
  } else {
    length = self.size.height / 2.0;
  }

  point = [self convertPoint:point toNode:border];
  CGFloat distanceToCenter = (point.y - length) / length;
  CGFloat angle = DegreesToRadians(10) * distanceToCenter;

  [_worldPivot runAction:[SKAction skt_screenTumbleWithNode:_worldPivot angle:angle oscillations:1 duration:1]];
}

- (void)jelly:(SKNode *)node {
  // Scales up the node and then scales it back down with "bounce ease out"
  // timing, making it wobble like jelly.

  SKTScaleEffect *effect = [SKTScaleEffect effectWithNode:node duration:0.25 startScale:CGPointMake(1.25, 1.25) endScale:[node skt_scale]];

  effect.timingFunction = SKTTimingFunctionBounceEaseOut;
  [node runAction:[SKAction actionWithEffect:effect]];
}

@end

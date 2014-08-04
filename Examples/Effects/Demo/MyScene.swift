
import SpriteKit

// These flags enable or disable the various effects that happen when a ball
// collides with a border, the barrier, or another ball. Turning them all on
// at the same time might result in sea sickness... ;-)
let FLASH_BALL     = false
let FLASH_BORDER   = true
let FLASH_BARRIER  = true
let SCALE_BALL     = true
let SCALE_BORDER   = true
let SCALE_BARRIER  = true
let SQUASH_BALL    = false
let STRETCH_BALL   = false
let SCREEN_SHAKE   = true
let SCREEN_ZOOM    = true
let SCREEN_TUMBLE  = true
let COLOR_GLITCH   = false
let BARRIER_JELLY  = true

// How fat the borders around the screen are.
let BorderThickness: CGFloat = 20.0

// Categories for physics collisions.
let BallCategory: UInt32    = 1 << 0
let BorderCategory: UInt32  = 1 << 1
let BarrierCategory: UInt32 = 1 << 2

class MyScene: SKScene, SKPhysicsContactDelegate {

  // The layer that contains all the nodes. Having a separate world node is
  // necessary for the screen shake effect because you cannot apply that to
  // an SKScene directly.
  let worldLayer = SKNode()

  // For screen zoom and tumble, the world layer must sit in a separate pivot
  // node that centers the world on the screen.
  let worldPivot = SKNode()

  let sceneBackgroundColor = SKColorWithRGB(8, 57, 71)
  let borderColor = SKColorWithRGB(160, 160, 160)
  let borderFlashColor = SKColor.whiteColor()
  let barrierColor = SKColorWithRGB(212, 212, 212)
  let barrierFlashColor = SKColor.whiteColor()
  let ballFlashColor  = SKColor.redColor()

  // ---- Initialization ----

  required init(coder aDecoder: NSCoder!) {
    super.init(coder: aDecoder)
  }

  override init(size: CGSize) {
    super.init(size: size)

    // Preload the font, otherwise there is a small delay when creating the
    // first text label.
    let tempLabel = SKLabelNode(fontNamed: "HelveticaNeue-Light")

    scaleMode = .ResizeFill
    backgroundColor = sceneBackgroundColor

    // By placing the scene's anchor point in the center of the screen and the
    // world layer at the scene's origin, you can make the entire scene rotate
    // around its center (for example for the screen tumble effect). You need
    // to set the anchor point before you add the world pivot node.
    anchorPoint = CGPoint(x: 0.5, y: 0.5)

    // The origin of the pivot node must be the center of the screen.
    addChild(worldPivot)

    // Create the world layer. This is the only node that is added directly
    // to the pivot node. If you have a HUD layer you would add that directly
    // to the scene and make it sit above the world layer.
    worldLayer.position = frame.origin
    worldPivot.addChild(worldLayer)

    physicsWorld.gravity = CGVector(dx: 0, dy: 0)
    physicsWorld.contactDelegate = self

    // Put the game objects into the world. We use delays here to make some
    // objects appear earlier than others, which looks cooler.
    addBorders()
    afterDelay(1.5, runBlock: addBarrier)
    afterDelay(2.5, runBlock: addBalls)
    afterDelay(6.0, runBlock: showLabel)

    // Make the barrier rotate around its center.
    afterDelay(4.0, runBlock: animateBarrier)
  }

  /**
   * Creates four border nodes, one for each screen edge. The nodes all have
   * the same shape -- a rectangle that is taller than it is wide -- but are
   * rotated by different angles.
   */
  func addBorders() {
    let distance: CGFloat = 50.0

    let leftBorder = newBorderNodeWithLength(size.height, horizontal: false)
    leftBorder.position = CGPointMake(BorderThickness / 2.0 - distance, size.height / 2.0)
    worldLayer.addChild(leftBorder)

    let rightBorder = newBorderNodeWithLength(size.height, horizontal: false)
    rightBorder.position = CGPointMake(size.width - BorderThickness/2.0 + distance, size.height / 2.0)
    rightBorder.zRotation = π
    worldLayer.addChild(rightBorder)

    let topBorder = newBorderNodeWithLength(size.width, horizontal: true)
    topBorder.position = CGPointMake(size.width / 2.0, size.height - BorderThickness / 2.0 + distance)
    topBorder.zRotation = -π/2
    worldLayer.addChild(topBorder)

    let bottomBorder = newBorderNodeWithLength(size.width, horizontal: true)
    bottomBorder.position = CGPointMake(size.width / 2.0, BorderThickness / 2.0 - distance)
    bottomBorder.zRotation = π/2
    worldLayer.addChild(bottomBorder)

    // Make the borders appear with a bounce animation.

    addEffectToBorder(leftBorder, startPosition: leftBorder.position, endPosition: CGPointMake(leftBorder.position.x + distance, leftBorder.position.y), delay: 0.5)

    addEffectToBorder(rightBorder, startPosition: rightBorder.position, endPosition: CGPointMake(rightBorder.position.x - distance, rightBorder.position.y), delay: 0.5)

    addEffectToBorder(topBorder, startPosition: topBorder.position, endPosition: CGPointMake(topBorder.position.x, topBorder.position.y - distance), delay: 1.0)

    addEffectToBorder(bottomBorder, startPosition: bottomBorder.position, endPosition: CGPointMake(bottomBorder.position.x, bottomBorder.position.y + distance), delay: 1.0)
  }

  func newBorderNodeWithLength(length: CGFloat, horizontal: Bool) -> SKNode {
    // IMPORTANT: When using SKTScaleEffect, the node that you're scaling must
    // not have a physics body, otherwise the physics body gets scaled as well
    // and weird stuff will happen. So make a new SKNode, give it the physics
    // body, and add the node that you're scaling as a child node!

    var rect = CGRectMake(0, 0, BorderThickness, length)

    let node = SKShapeNode()
    node.path = UIBezierPath(rect: rect).CGPath
    node.fillColor = borderColor
    node.strokeColor = SKColor.clearColor()
    node.lineWidth = 0
    node.glowWidth = 0
    node.name = horizontal ? "horizontalBorder" : "verticalBorder"
    node.position = CGPointMake(-BorderThickness/2.0, -length/2.0)
  
    rect.offset(dx: -BorderThickness/2.0, dy: -length/2.0)

    let body = SKPhysicsBody(polygonFromPath: UIBezierPath(rect: rect).CGPath)
    body.dynamic = false
    body.friction = 0
    body.linearDamping = 0
    body.angularDamping = 0
    body.restitution = 0
    body.categoryBitMask = BorderCategory
    body.collisionBitMask = BallCategory
    body.contactTestBitMask = BallCategory

    let pivotNode = SKNode()
    pivotNode.addChild(node)
    pivotNode.physicsBody = body
    return pivotNode
  }

  func addEffectToBorder(border: SKNode, startPosition: CGPoint, endPosition: CGPoint, delay: NSTimeInterval) {
    let moveEffect = SKTMoveEffect(node: border, duration: 0.5, startPosition: startPosition, endPosition: endPosition)
    moveEffect.timingFunction = SKTTimingFunctionBounceEaseOut
    border.runAction(SKAction.afterDelay(delay, performAction: SKAction.actionWithEffect(moveEffect)))
  }

  /** 
   * Creates a node that sits in the middle of the screen so the balls have
   * something to bump into.
   */
  func addBarrier() {
    // SKShapeNode does not have an anchorPoint property, so create a pivot
    // node that acts as the anchor point, and place it in the screen center.
    let pivotNode = SKNode()
    pivotNode.name = "barrier"
    pivotNode.position = CGPointMake(size.width / 2.0, size.height / 2.0)
    pivotNode.zRotation = π/2
    worldLayer.addChild(pivotNode)

    let width = BorderThickness * 2
    let height: CGFloat = 140
    let path = UIBezierPath(rect: CGRectMake(0, 0, width, height))

    // Create the shape node that draws the barrier on the screen. This is a
    // child of the pivot node, so it rotates and scales along with the pivot.
    let shapeNode = SKShapeNode()
    shapeNode.path = path.CGPath
    shapeNode.fillColor = barrierColor
    shapeNode.strokeColor = SKColor.clearColor()
    shapeNode.lineWidth = 0
    shapeNode.glowWidth = 0
    shapeNode.position = CGPointMake(-width/2.0, -height/2.0)

    // Because of SKTScaleEffect we cannot scale the pivotNode directly. It
    // also doesn't look good to scale the SKShapeNode because its "anchor
    // point" is always in its bottom-left corner. To solve this, we add
    // another node that sits between pivotNode and shapeNode, so that any
    // scaling appears to happen from the barrier shape's center.
    let containerNode = SKNode()
    pivotNode.addChild(containerNode)
    containerNode.addChild(shapeNode)

    // Create the physics body. This has the same shape as the shape node
    // but is attached to the pivot node. (You don't want to attach it directly
    // to the shape node because that causes trouble with SKTScaleEffect.)
    let body = SKPhysicsBody(rectangleOfSize: CGSizeMake(width, height))
    body.dynamic = false
    body.friction = 0
    body.linearDamping = 0
    body.angularDamping = 0
    body.restitution = 0
    body.categoryBitMask = BarrierCategory
    body.collisionBitMask = BallCategory
    body.contactTestBitMask = body.collisionBitMask
    pivotNode.physicsBody = body

    // Zoom in the barrier shape. Because of SKTScaleEffect we do this on the
    // container node, not on the SKShapeNode directly.
    containerNode.xScale = 0.15
    containerNode.yScale = 0.15

    let scaleEffect = SKTScaleEffect(node: containerNode, duration: 1.0, startScale: CGPointMake(containerNode.xScale, containerNode.yScale), endScale: CGPointMake(1.0, 1.0))
    scaleEffect.timingFunction = SKTTimingFunctionBackEaseOut

    containerNode.runAction(SKAction.actionWithEffect(scaleEffect))

    // Also rotate and fade in the barrier. It's OK to apply these to the 
    // pivotNode directly.
    let rotateEffect = SKTRotateEffect(node: pivotNode, duration: 1.0, startAngle: CGFloat.random() * π/4, endAngle:pivotNode.zRotation)
    rotateEffect.timingFunction = SKTTimingFunctionBackEaseOut

    pivotNode.alpha = 0.0
    pivotNode.runAction(SKAction.group([
      SKAction.fadeInWithDuration(1.0),
      SKAction.actionWithEffect(rotateEffect)
      ]))
  }

  func barrierNode() -> SKNode! {
    return worldLayer.childNodeWithName("barrier")
  }

  /**
   * Rotates the barrier by 45 degrees with a "back ease in-out", which makes
   * it look realistically mechanical.
   */
  func animateBarrier() {
    let node = barrierNode()
    node.runAction(SKAction.repeatActionForever(SKAction.sequence([
      SKAction.waitForDuration(0.75),
      SKAction.runBlock {
        let effect = SKTRotateEffect(node: node, duration: 0.25, startAngle: node.zRotation, endAngle:node.zRotation + π/4)
        effect.timingFunction = SKTTimingFunctionBackEaseInOut
        node.runAction(SKAction.actionWithEffect(effect))
      }])))
  }

  func addBalls() {
    // Add a ball sprite on the left side of the screen...
    let ball1 = newBallNode()
    ball1.position = CGPointMake(100, size.height / 2.0)
    worldLayer.addChild(ball1)

    // ...and add a ball sprite on the right side of the screen.
    let ball2 = newBallNode()
    ball2.position = CGPointMake(size.width - 100, size.height / 2.0)
    worldLayer.addChild(ball2)

    for ball in [ball1, ball2] {
      addEffectToBall(ball)

      ball.runAction(SKAction.afterDelay(1.0, runBlock:{
        // Assign a random angle to the ball's velocity.
        let ballSpeed: CGFloat = 200
        let angle = (CGFloat.random() * 360).degreesToRadians()
        ball.physicsBody.velocity = CGVectorMake(cos(angle)*ballSpeed, sin(angle)*ballSpeed)
      }))
    }
  }

  func newBallNode() -> SKNode {
    let sprite = SKSpriteNode(imageNamed: "Ball")

    // Create a circular physics body. It collides with the borders and
    // with other balls. It is slightly smaller than the sprite.
    let body = SKPhysicsBody(circleOfRadius:(sprite.size.width / 2.0) * 0.9)
    body.dynamic = true
    body.friction = 0
    body.linearDamping = 0
    body.angularDamping = 0
    body.restitution = 0.9
    body.categoryBitMask = BallCategory
    body.collisionBitMask = BorderCategory | BarrierCategory | BallCategory
    body.contactTestBitMask = body.collisionBitMask

    // Create a new node to hold the sprite. This is necessary for combining
    // nonuniform scaling effects with rotation. Some of the effects are placed
    // directly on the sprite, some on this pivot node.
    let pivotNode = SKNode()
    pivotNode.name = "ball"
    pivotNode.physicsBody = body
    pivotNode.addChild(sprite)
    return pivotNode
  }

  func addEffectToBall(ball: SKNode) {
    let spriteNode = ball.children[0] as SKSpriteNode

    spriteNode.xScale = 0.2
    spriteNode.yScale = 0.2

    // TODO: Instead of doing CGPointMake(spriteNode.xScale, spriteNode.yScale)
    // you should be able to use spriteNode.scaleAsPoint. However, in Xcode 6
    // beta 1, this crashes the compiler.

    let scaleEffect = SKTScaleEffect(node: spriteNode, duration: 0.5, startScale:CGPointMake(spriteNode.xScale, spriteNode.yScale), endScale:CGPointMake(1.0, 1.0))
    scaleEffect.timingFunction = SKTTimingFunctionBackEaseOut

    spriteNode.runAction(SKAction.actionWithEffect(scaleEffect))
  }

  /**
   * Adds a label with instructions.
   */
  func showLabel() {
    let labelNode = SKLabelNode(fontNamed: "HelveticaNeue-Light")
    labelNode.text = NSLocalizedString("Tap to apply random impulse", comment: "IntroMessage")
    labelNode.fontSize = 12
    addChild(labelNode)

    labelNode.position = labelNode.position.offset(dx: 0, dy: 100)

    let moveEffect = SKTMoveEffect(node: labelNode, duration: 4.0, startPosition: labelNode.position, endPosition:labelNode.position.offset(dx: 0, dy: 20))
    
    moveEffect.timingFunction = SKTTimingFunctionSmoothstep
    labelNode.runAction(SKAction.actionWithEffect(moveEffect))

    labelNode.alpha = 0.0
    labelNode.runAction(SKAction.sequence([
      SKAction.waitForDuration(0.5),
      SKAction.fadeInWithDuration(2.0),
      SKAction.waitForDuration(1.0),
      SKAction.fadeOutWithDuration(1.0)
      ]))
  }

  // ---- Touch Handling ----

  /**
   * Adds a random impulse to the balls whenever the user taps the screen.
   */
  override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
    worldLayer.enumerateChildNodesWithName("ball") {(node, stop) in
      let speed: CGFloat = 50
      let impulse = CGVectorMake(CGFloat.random(min: -speed, max: speed), CGFloat.random(min: -speed, max: speed))
      node.physicsBody.applyImpulse(impulse)

      if STRETCH_BALL {
        self.stretchBall(node.children[0] as SKNode)
      }
    }
  }

  // ---- Game Logic ----

  /**
   * Rotates the balls into the direction that they're flying.
   */
  override func didSimulatePhysics() {
    worldLayer.enumerateChildNodesWithName("ball") {(node, stop) in
      if node.physicsBody.velocity.length() > 0.0 {
        node.rotateToVelocity(node.physicsBody.velocity, rate:0.1)
      }
    }
  }

  func didBeginContact(contact: SKPhysicsContact!) {
    checkContactBetweenBody1(contact.bodyA, body2: contact.bodyB, contactPoint: contact.contactPoint)
    checkContactBetweenBody1(contact.bodyB, body2: contact.bodyA, contactPoint: contact.contactPoint)
  }

  func checkContactBetweenBody1(body1: SKPhysicsBody, body2: SKPhysicsBody, contactPoint: CGPoint) {
    if body1.categoryBitMask & BallCategory != 0 {
      handleBallCollision(body1.node)

      if body2.categoryBitMask & BorderCategory != 0 {
        handleCollisionBetweenBall(body1.node, border:body2.node, contactPoint:contactPoint)
      } else if body2.categoryBitMask & BarrierCategory != 0 {
        handleCollisionBetweenBall(body1.node, barrier:body2.node)
      }
    }
  }

  /**
   * This method gets called when a ball hits any other node.
   */
  func handleBallCollision(node: SKNode) {
    let ballSprite = node.children[0] as SKSpriteNode

    if FLASH_BALL {
      flashSpriteNode(ballSprite, withColor: ballFlashColor)
    }

    if SCALE_BALL {
      scaleBall(ballSprite)
    }

    if SQUASH_BALL {
      squashBall(ballSprite)
    }

    if SCREEN_SHAKE {
      screenShakeWithVelocity(node.physicsBody.velocity)
    }

    if SCREEN_ZOOM {
      screenZoomWithVelocity(node.physicsBody.velocity)
    }
  }

  func handleCollisionBetweenBall(ball: SKNode, border: SKNode, contactPoint: CGPoint) {
    let borderShapeNode = border.children[0] as SKShapeNode
  
    // Draw the flashing border above the other borders.
    border.bringToFront()

    if FLASH_BORDER {
      flashShapeNode(borderShapeNode, fromColor: borderFlashColor, toColor: borderColor)
    }

    if BARRIER_JELLY {
      jelly(barrierNode())
    }

    if SCREEN_TUMBLE {
      screenTumbleAtContactPoint(contactPoint, border: borderShapeNode)
    }

    if SCALE_BORDER {
      scaleBorder(borderShapeNode)
    }
  }

  func handleCollisionBetweenBall(ball: SKNode, barrier: SKNode) {
    if SCALE_BARRIER {
      scaleBarrier(barrier)
    }

    if FLASH_BARRIER {
      let containerNode = barrier.children[0] as SKNode
      let shapeNode = containerNode.children[0] as SKShapeNode
      flashShapeNode(shapeNode, fromColor: barrierFlashColor, toColor: barrierColor)
    }

    if COLOR_GLITCH {
      runAction(SKAction.colorGlitchWithScene(self, originalColor: sceneBackgroundColor, duration:0.1))
    }
  }

  // ---- Special Effects ----

  /**
   * Colorizes the node for a brief moment and then fades back to
   * the original color.
   */
  func flashSpriteNode(spriteNode: SKSpriteNode, withColor color: SKColor) {

    let action = SKAction.sequence([
      SKAction.colorizeWithColor(color, colorBlendFactor: 1.0, duration: 0.025),
      SKAction.waitForDuration(0.05),
      SKAction.colorizeWithColorBlendFactor(0.0, duration:0.1)])

    spriteNode.runAction(action)
  }

  /**
   * Changes the fill color of the node for a brief moment and then
   * restores the original color.
   */
  func flashShapeNode(node: SKShapeNode, fromColor: SKColor, toColor: SKColor) {
    node.fillColor = fromColor

    let action = SKAction.sequence([
      SKAction.waitForDuration(0.15),
      SKAction.runBlock { node.fillColor = toColor }])

    node.runAction(action)
  }

  /**
   * Scales the ball up and then down again. This effect is cumulative; if
   * the ball collides again while still scaled up, it scales up even more.
   */
  func scaleBall(node: SKSpriteNode) {
    let currentScale = CGPointMake(node.xScale, node.yScale)
    let newScale = currentScale * 1.2

    let scaleEffect = SKTScaleEffect(node: node, duration: 1.5, startScale: newScale, endScale: currentScale)
    scaleEffect.timingFunction = SKTTimingFunctionElasticEaseOut

    node.runAction(SKAction.actionWithEffect(scaleEffect))
  }

  /**
   * Makes the ball wider but flatter, keeping the overall volume the same.
   * Squashing is useful for when an object collides with another object.
   */
  func squashBall(node: SKNode) {
    let ratio: CGFloat = 1.5
    let currentScale = CGPointMake(node.xScale, node.yScale)
    let newScale = currentScale * CGPointMake(ratio, 1.0/ratio)

    let scaleEffect = SKTScaleEffect(node: node, duration: 1.5, startScale: newScale, endScale: currentScale)
    scaleEffect.timingFunction = SKTTimingFunctionElasticEaseOut

    node.runAction(SKAction.actionWithEffect(scaleEffect))
  }

  /**
   * Makes the ball thinner but taller, keeping the overall volume the same.
   * Stretching is useful for when an object accelerates.
   */
  func stretchBall(node: SKNode) {
    let ratio: CGFloat = 1.5
    let currentScale = CGPointMake(node.xScale, node.yScale)
    let newScale = currentScale * CGPointMake(1.0/ratio, ratio)

    let scaleEffect = SKTScaleEffect(node: node, duration: 0.5, startScale: newScale, endScale: currentScale)
    scaleEffect.timingFunction = SKTTimingFunctionCubicEaseOut

    node.runAction(SKAction.actionWithEffect(scaleEffect))
  }

  /**
   * Scales the border in the X direction. Because shape nodes do not have an
   * anchor point, this keeps the bottom-left corner fixed. Because the border
   * nodes are rotated, this makes them grow into the scene, which looks cool.
   */
  func scaleBorder(node: SKNode) {
    let currentScale = CGPointMake(node.xScale, node.yScale)
    let newScale = CGPointMake(currentScale.x * 2.0, currentScale.y)

    let scaleEffect = SKTScaleEffect(node: node, duration: 1.0, startScale: newScale, endScale: currentScale)
    scaleEffect.timingFunction = SKTTimingFunctionElasticEaseOut

    node.runAction(SKAction.actionWithEffect(scaleEffect))
  }

  /**
   * Quickly scales the barrier down and up again.
   */
  func scaleBarrier(node: SKNode) {
    // This is the SKnode that holds the SKShapeNode. We need to scale this
    // container node and not the shape node directly, so that the barrier
    // shape appears to scale from the center instead of one of its corners.
    let containerNode = node.children[0] as SKNode
  
    let currentScale = CGPointMake(containerNode.xScale, containerNode.yScale)
    let newScale = currentScale * 0.5

    let scaleEffect = SKTScaleEffect(node: containerNode, duration: 0.5, startScale: newScale, endScale: currentScale)
    scaleEffect.timingFunction = SKTTimingFunctionElasticEaseOut

    containerNode.runAction(SKAction.actionWithEffect(scaleEffect))
  }

  /**
   * Creates a screen shake in the direction of the velocity vector, with
   * an intensity that is proportional to the velocity's magnitude.
   */
  func screenShakeWithVelocity(velocity: CGVector) {
    // Note: The velocity is from *after* the collision, so the ball is already
    // travelling in the opposite direction. To find the impact vector we have
    // to negate the velocity. Unfortunately, if the collision is only in the X
    // direction, the Y direction also gets flipped (and vice versa). It would
    // be better if we could get the velocity at exactly the moment of impact,
    // but Sprite Kit doesn't seem to make this easy.

    let inverseVelocity = CGPointMake(-velocity.dx, -velocity.dy)
    let hitVector = inverseVelocity / 50.0

    worldLayer.runAction(SKAction.screenShakeWithNode(worldLayer, amount: hitVector, oscillations: 10, duration:3.0))
  }

  /**
   * Magnifies the screen by a tiny amount (102%) and bounce back to 100%.
   */
  func screenZoomWithVelocity(velocity: CGVector) {
    let amount = CGPointMake(1.02, 1.02)
    worldPivot.runAction(SKAction.screenZoomWithNode(worldPivot, amount: amount, oscillations: 10, duration: 3.0))
  }

  /**
   * Rotates the scene around its center. The amount of rotation depends on
   * where the ball hit the border (further from the center is a bigger angle).
   */
  func screenTumbleAtContactPoint(contactPoint: CGPoint, border: SKShapeNode) {
    let length: CGFloat = (border.name == "horizontalBorder") ? size.width / 2.0 : size.height / 2.0
    
    let point = border.convertPoint(contactPoint, fromNode: worldLayer)
    let distanceToCenter = (point.y - length) / length
    let angle = 10.degreesToRadians() * distanceToCenter

    worldPivot.runAction(SKAction.screenRotateWithNode(worldPivot, angle: angle, oscillations: 1, duration: 1))
  }

  /**
   * Scales up the node and then scales it back down with "bounce ease out"
   * timing, making it wobble like jelly.
   */
  func jelly(node: SKNode) {
    let containerNode = node.children[0] as SKNode
  
    let scaleEffect = SKTScaleEffect(node: containerNode, duration: 0.25, startScale: CGPointMake(1.25, 1.25), endScale: CGPointMake(containerNode.xScale, containerNode.yScale))

    scaleEffect.timingFunction = SKTTimingFunctionBounceEaseOut

    containerNode.runAction(SKAction.actionWithEffect(scaleEffect))
  }
}

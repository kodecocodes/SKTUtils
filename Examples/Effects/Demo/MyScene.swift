
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
let BorderThickness: CGFloat = 20

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

  let sceneBackgroundColor = SKColorWithRGB(8, g: 57, b: 71)
  let borderColor = SKColorWithRGB(160, g: 160, b: 160)
  let borderFlashColor = SKColor.white
  let barrierColor = SKColorWithRGB(212, g: 212, b: 212)
  let barrierFlashColor = SKColor.white
  let ballFlashColor  = SKColor.red

  // ---- Initialization ----

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder) is not used in this app")
  }

  override init(size: CGSize) {
    super.init(size: size)

    // Preload the font, otherwise there is a small delay when creating the
    // first text label.
    _ = SKLabelNode(fontNamed: "HelveticaNeue-Light")

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
    afterDelay(6, runBlock: showLabel)

    // Make the barrier rotate around its center.
    afterDelay(4, runBlock: animateBarrier)
  }

  /**
   * Creates four border nodes, one for each screen edge. The nodes all have
   * the same shape -- a rectangle that is taller than it is wide -- but are
   * rotated by different angles.
   */
  func addBorders() {
    let distance: CGFloat = 50

    let leftBorder = newBorderNodeWithLength(length: size.height, horizontal: false)
    leftBorder.position = CGPoint(x: BorderThickness / 2 - distance, y: size.height / 2)
    worldLayer.addChild(leftBorder)

    let rightBorder = newBorderNodeWithLength(length: size.height, horizontal: false)
    rightBorder.position = CGPoint(x: size.width - BorderThickness/2 + distance, y: size.height / 2)
    rightBorder.zRotation = π
    worldLayer.addChild(rightBorder)

    let topBorder = newBorderNodeWithLength(length: size.width, horizontal: true)
    topBorder.position = CGPoint(x: size.width / 2, y: size.height - BorderThickness / 2 + distance)
    topBorder.zRotation = -π/2
    worldLayer.addChild(topBorder)

    let bottomBorder = newBorderNodeWithLength(length: size.width, horizontal: true)
    bottomBorder.position = CGPoint(x: size.width / 2, y: BorderThickness / 2 - distance)
    bottomBorder.zRotation = π/2
    worldLayer.addChild(bottomBorder)

    // Make the borders appear with a bounce animation.

    addEffectToBorder(border: leftBorder, startPosition: leftBorder.position, endPosition: CGPoint(x: leftBorder.position.x + distance, y: leftBorder.position.y), delay: 0.5)

    addEffectToBorder(border: rightBorder, startPosition: rightBorder.position, endPosition: CGPoint(x: rightBorder.position.x - distance, y: rightBorder.position.y), delay: 0.5)

    addEffectToBorder(border: topBorder, startPosition: topBorder.position, endPosition: CGPoint(x: topBorder.position.x, y: topBorder.position.y - distance), delay: 1)

    addEffectToBorder(border: bottomBorder, startPosition: bottomBorder.position, endPosition: CGPoint(x: bottomBorder.position.x, y: bottomBorder.position.y + distance), delay: 1)
  }

  func newBorderNodeWithLength(length: CGFloat, horizontal: Bool) -> SKNode {
    // IMPORTANT: When using SKTScaleEffect, the node that you're scaling must
    // not have a physics body, otherwise the physics body gets scaled as well
    // and weird stuff will happen. So make a new SKNode, give it the physics
    // body, and add the node that you're scaling as a child node!

    let rect = CGRect(x: 0, y: 0, width: BorderThickness, height: length)

    let node = SKShapeNode()
    node.path = UIBezierPath(rect: rect).cgPath
    node.fillColor = borderColor
    node.strokeColor = SKColor.clear
    node.lineWidth = 0
    node.glowWidth = 0
    node.name = horizontal ? "horizontalBorder" : "verticalBorder"
    node.position = CGPoint(x: -BorderThickness/2, y: -length/2)

    rect.offsetBy(dx: -BorderThickness/2, dy: -length/2)

    let body = SKPhysicsBody(polygonFrom: UIBezierPath(rect: rect).cgPath)
    body.isDynamic = false
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

  func addEffectToBorder(border: SKNode, startPosition: CGPoint, endPosition: CGPoint, delay: TimeInterval) {
    let moveEffect = SKTMoveEffect(node: border, duration: 0.5, startPosition: startPosition, endPosition: endPosition)
    moveEffect.timingFunction = SKTTimingFunctionBounceEaseOut
    border.run(SKAction.afterDelay(delay, performAction: SKAction.actionWithEffect(moveEffect)))
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
    pivotNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
    pivotNode.zRotation = π/2
    worldLayer.addChild(pivotNode)

    let width = BorderThickness * 2
    let height: CGFloat = 140
    let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: width, height: height))

    // Create the shape node that draws the barrier on the screen. This is a
    // child of the pivot node, so it rotates and scales along with the pivot.
    let shapeNode = SKShapeNode()
    shapeNode.path = path.cgPath
    shapeNode.fillColor = barrierColor
    shapeNode.strokeColor = SKColor.clear
    shapeNode.lineWidth = 0
    shapeNode.glowWidth = 0
    shapeNode.position = CGPoint(x: -width/2, y: -height/2)

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
    let body = SKPhysicsBody(rectangleOf: CGSize(width: width, height: height))
    body.isDynamic = false
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

    let scaleEffect = SKTScaleEffect(node: containerNode, duration: 1, startScale: CGPoint(x: containerNode.xScale, y: containerNode.yScale), endScale: CGPoint(x: 1, y: 1))
    scaleEffect.timingFunction = SKTTimingFunctionBackEaseOut

    containerNode.run(SKAction.actionWithEffect(scaleEffect))

    // Also rotate and fade in the barrier. It's OK to apply these to the 
    // pivotNode directly.
    let rotateEffect = SKTRotateEffect(node: pivotNode, duration: 1, startAngle: CGFloat.random() * π/4, endAngle:pivotNode.zRotation)
    rotateEffect.timingFunction = SKTTimingFunctionBackEaseOut

    pivotNode.alpha = 0
    pivotNode.run(SKAction.group([
      SKAction.fadeIn(withDuration: 1),
      SKAction.actionWithEffect(rotateEffect)
      ]))
  }

  func barrierNode() -> SKNode {
    return worldLayer.childNode(withName: "barrier")!
  }

  /**
   * Rotates the barrier by 45 degrees with a "back ease in-out", which makes
   * it look realistically mechanical.
   */
  func animateBarrier() {
    let node = barrierNode()
    node.run(SKAction.repeatForever(SKAction.sequence([
      SKAction.wait(forDuration: 0.75),
      SKAction.run {
        let effect = SKTRotateEffect(node: node, duration: 0.25, startAngle: node.zRotation, endAngle:node.zRotation + π/4)
        effect.timingFunction = SKTTimingFunctionBackEaseInOut
        node.run(SKAction.actionWithEffect(effect))
      }])))
  }

  func addBalls() {
    // Add a ball sprite on the left side of the screen...
    let ball1 = newBallNode()
    ball1.position = CGPoint(x: 100, y: size.height / 2)
    worldLayer.addChild(ball1)

    // ...and add a ball sprite on the right side of the screen.
    let ball2 = newBallNode()
    ball2.position = CGPoint(x: size.width - 100, y: size.height / 2)
    worldLayer.addChild(ball2)

    for ball in [ball1, ball2] {
      addEffectToBall(ball: ball)

      ball.run(SKAction.afterDelay(1, runBlock:{
        // Assign a random angle to the ball's velocity.
        let ballSpeed: CGFloat = 200
        let angle = (CGFloat.random() * 360).degreesToRadians()
        ball.physicsBody!.velocity = CGVector(dx: cos(angle)*ballSpeed, dy: sin(angle)*ballSpeed)
      }))
    }
  }

  func newBallNode() -> SKNode {
    let sprite = SKSpriteNode(imageNamed: "Ball")

    // Create a circular physics body. It collides with the borders and
    // with other balls. It is slightly smaller than the sprite.
    let body = SKPhysicsBody(circleOfRadius:(sprite.size.width / 2) * 0.9)
    body.isDynamic = true
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
    let spriteNode = ball.children[0] as! SKSpriteNode

    spriteNode.xScale = 0.2
    spriteNode.yScale = 0.2

    // TODO: Instead of doing CGPointMake(spriteNode.xScale, spriteNode.yScale)
    // you should be able to use spriteNode.scaleAsPoint. However, in Xcode 6
    // beta 1, this crashes the compiler.

    let scaleEffect = SKTScaleEffect(node: spriteNode, duration: 0.5, startScale:CGPoint(x: spriteNode.xScale, y: spriteNode.yScale), endScale:CGPoint(x: 1, y: 1))
    scaleEffect.timingFunction = SKTTimingFunctionBackEaseOut

    spriteNode.run(SKAction.actionWithEffect(scaleEffect))
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

    let moveEffect = SKTMoveEffect(node: labelNode, duration: 4, startPosition: labelNode.position, endPosition:labelNode.position.offset(dx: 0, dy: 20))
    
    moveEffect.timingFunction = SKTTimingFunctionSmoothstep
    labelNode.run(SKAction.actionWithEffect(moveEffect))

    labelNode.alpha = 0
    labelNode.run(SKAction.sequence([
      SKAction.wait(forDuration: 0.5),
      SKAction.fadeIn(withDuration: 2),
      SKAction.wait(forDuration: 1),
      SKAction.fadeOut(withDuration: 1)
      ]))
  }

  // ---- Touch Handling ----

  /**
   * Adds a random impulse to the balls whenever the user taps the screen.
   */
   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    worldLayer.enumerateChildNodes(withName: "ball") {(node, stop) in
      let speed: CGFloat = 50
      let impulse = CGVector(dx: CGFloat.random(min: -speed, max: speed), dy: CGFloat.random(min: -speed, max: speed))
      node.physicsBody!.applyImpulse(impulse)

      if STRETCH_BALL {
        self.stretchBall(node: node.children[0] as SKNode)
      }
    }
  }

  // ---- Game Logic ----

  /**
   * Rotates the balls into the direction that they're flying.
   */
  override func didSimulatePhysics() {
    worldLayer.enumerateChildNodes(withName: "ball") {(node, stop) in
      if node.physicsBody!.velocity.length() > 0 {
        node.rotateToVelocity(node.physicsBody!.velocity, rate:0.1)
      }
    }
  }

  func didBegin(_ contact: SKPhysicsContact) {
    checkContactBetween(body1: contact.bodyA, body2: contact.bodyB, contactPoint: contact.contactPoint)
    checkContactBetween(body1: contact.bodyB, body2: contact.bodyA, contactPoint: contact.contactPoint)
  }

  func checkContactBetween(body1: SKPhysicsBody, body2: SKPhysicsBody, contactPoint: CGPoint) {
    if body1.categoryBitMask & BallCategory != 0 {
      handleBallCollision(node: body1.node!)

      if body2.categoryBitMask & BorderCategory != 0 {
        handleCollisionBetweenBall(ball: body1.node!, border:body2.node!, contactPoint:contactPoint)
      } else if body2.categoryBitMask & BarrierCategory != 0 {
        handleCollisionBetweenBall(ball: body1.node!, barrier:body2.node!)
      }
    }
  }

  /**
   * This method gets called when a ball hits any other node.
   */
  func handleBallCollision(node: SKNode) {
    let ballSprite = node.children[0] as! SKSpriteNode

    if FLASH_BALL {
      flashSpriteNode(spriteNode: ballSprite, withColor: ballFlashColor)
    }

    if SCALE_BALL {
      scaleBall(node: ballSprite)
    }

    if SQUASH_BALL {
      squashBall(node: ballSprite)
    }

    if SCREEN_SHAKE {
      screenShakeWithVelocity(velocity: node.physicsBody!.velocity)
    }

    if SCREEN_ZOOM {
      screenZoomWithVelocity(velocity: node.physicsBody!.velocity)
    }
  }

  func handleCollisionBetweenBall(ball: SKNode, border: SKNode, contactPoint: CGPoint) {
    let borderShapeNode = border.children[0] as! SKShapeNode
  
    // Draw the flashing border above the other borders.
    border.bringToFront()

    if FLASH_BORDER {
      flashShapeNode(node: borderShapeNode, fromColor: borderFlashColor, toColor: borderColor)
    }

    if BARRIER_JELLY {
      jelly(node: barrierNode())
    }

    if SCREEN_TUMBLE {
      screenTumbleAtContactPoint(contactPoint: contactPoint, border: borderShapeNode)
    }

    if SCALE_BORDER {
      scaleBorder(node: borderShapeNode)
    }
  }

  func handleCollisionBetweenBall(ball: SKNode, barrier: SKNode) {
    if SCALE_BARRIER {
      scaleBarrier(node: barrier)
    }

    if FLASH_BARRIER {
      let containerNode = barrier.children[0] as SKNode
      let shapeNode = containerNode.children[0] as! SKShapeNode
      flashShapeNode(node: shapeNode, fromColor: barrierFlashColor, toColor: barrierColor)
    }

    if COLOR_GLITCH {
      run(SKAction.colorGlitchWithScene(self, originalColor: sceneBackgroundColor, duration:0.1))
    }
  }

  // ---- Special Effects ----

  /**
   * Colorizes the node for a brief moment and then fades back to
   * the original color.
   */
  func flashSpriteNode(spriteNode: SKSpriteNode, withColor color: SKColor) {

    let action = SKAction.sequence([
      SKAction.colorize(with: color, colorBlendFactor: 1, duration: 0.025),
      SKAction.wait(forDuration: 0.05),
      SKAction.colorize(withColorBlendFactor: 0, duration:0.1)])

    spriteNode.run(action)
  }

  /**
   * Changes the fill color of the node for a brief moment and then
   * restores the original color.
   */
  func flashShapeNode(node: SKShapeNode, fromColor: SKColor, toColor: SKColor) {
    node.fillColor = fromColor

    let action = SKAction.sequence([
      SKAction.wait(forDuration: 0.15),
      SKAction.run { node.fillColor = toColor }])

    node.run(action)
  }

  /**
   * Scales the ball up and then down again. This effect is cumulative; if
   * the ball collides again while still scaled up, it scales up even more.
   */
  func scaleBall(node: SKSpriteNode) {
    let currentScale = CGPoint(x: node.xScale, y: node.yScale)
    let newScale = currentScale * 1.2

    let scaleEffect = SKTScaleEffect(node: node, duration: 1.5, startScale: newScale, endScale: currentScale)
    scaleEffect.timingFunction = SKTTimingFunctionElasticEaseOut

    node.run(SKAction.actionWithEffect(scaleEffect))
  }

  /**
   * Makes the ball wider but flatter, keeping the overall volume the same.
   * Squashing is useful for when an object collides with another object.
   */
  func squashBall(node: SKNode) {
    let ratio: CGFloat = 1.5
    let currentScale = CGPoint(x: node.xScale, y: node.yScale)
    let newScale = currentScale * CGPoint(x: ratio, y: 1/ratio)

    let scaleEffect = SKTScaleEffect(node: node, duration: 1.5, startScale: newScale, endScale: currentScale)
    scaleEffect.timingFunction = SKTTimingFunctionElasticEaseOut

    node.run(SKAction.actionWithEffect(scaleEffect))
  }

  /**
   * Makes the ball thinner but taller, keeping the overall volume the same.
   * Stretching is useful for when an object accelerates.
   */
  func stretchBall(node: SKNode) {
    let ratio: CGFloat = 1.5
    let currentScale = CGPoint(x: node.xScale, y: node.yScale)
    let newScale = currentScale * CGPoint(x: 1/ratio, y: ratio)

    let scaleEffect = SKTScaleEffect(node: node, duration: 0.5, startScale: newScale, endScale: currentScale)
    scaleEffect.timingFunction = SKTTimingFunctionCubicEaseOut

    node.run(SKAction.actionWithEffect(scaleEffect))
  }

  /**
   * Scales the border in the X direction. Because shape nodes do not have an
   * anchor point, this keeps the bottom-left corner fixed. Because the border
   * nodes are rotated, this makes them grow into the scene, which looks cool.
   */
  func scaleBorder(node: SKNode) {
    let currentScale = CGPoint(x: node.xScale, y: node.yScale)
    let newScale = CGPoint(x: currentScale.x * 2, y: currentScale.y)

    let scaleEffect = SKTScaleEffect(node: node, duration: 1, startScale: newScale, endScale: currentScale)
    scaleEffect.timingFunction = SKTTimingFunctionElasticEaseOut

    node.run(SKAction.actionWithEffect(scaleEffect))
  }

  /**
   * Quickly scales the barrier down and up again.
   */
  func scaleBarrier(node: SKNode) {
    // This is the SKnode that holds the SKShapeNode. We need to scale this
    // container node and not the shape node directly, so that the barrier
    // shape appears to scale from the center instead of one of its corners.
    let containerNode = node.children[0] as SKNode
  
    let currentScale = CGPoint(x: containerNode.xScale, y: containerNode.yScale)
    let newScale = currentScale * 0.5

    let scaleEffect = SKTScaleEffect(node: containerNode, duration: 0.5, startScale: newScale, endScale: currentScale)
    scaleEffect.timingFunction = SKTTimingFunctionElasticEaseOut

    containerNode.run(SKAction.actionWithEffect(scaleEffect))
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

    let inverseVelocity = CGPoint(x: -velocity.dx, y: -velocity.dy)
    let hitVector = inverseVelocity / 50

    worldLayer.run(SKAction.screenShakeWithNode(worldLayer, amount: hitVector, oscillations: 10, duration:3))
  }

  /**
   * Magnifies the screen by a tiny amount (102%) and bounce back to 100%.
   */
  func screenZoomWithVelocity(velocity: CGVector) {
    let amount = CGPoint(x: 1.02, y: 1.02)
    worldPivot.run(SKAction.screenZoomWithNode(worldPivot, amount: amount, oscillations: 10, duration: 3))
  }

  /**
   * Rotates the scene around its center. The amount of rotation depends on
   * where the ball hit the border (further from the center is a bigger angle).
   */
  func screenTumbleAtContactPoint(contactPoint: CGPoint, border: SKShapeNode) {
    let length: CGFloat = (border.name == "horizontalBorder") ? size.width / 2 : size.height / 2
    
    let point = border.convert(contactPoint, from: worldLayer)
    let distanceToCenter = (point.y - length) / length
    let angle = CGFloat(10).degreesToRadians() * distanceToCenter

    worldPivot.run(SKAction.screenRotateWithNode(worldPivot, angle: angle, oscillations: 1, duration: 1))
  }

  /**
   * Scales up the node and then scales it back down with "bounce ease out"
   * timing, making it wobble like jelly.
   */
  func jelly(node: SKNode) {
    let containerNode = node.children[0] as SKNode
  
    let scaleEffect = SKTScaleEffect(node: containerNode, duration: 0.25, startScale: CGPoint(x: 1.25, y: 1.25), endScale: CGPoint(x: containerNode.xScale, y: containerNode.yScale))

    scaleEffect.timingFunction = SKTTimingFunctionBounceEaseOut

    containerNode.run(SKAction.actionWithEffect(scaleEffect))
  }
}

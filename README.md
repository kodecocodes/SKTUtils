# Sprite Kit Utils

A collection of Sprite Kit helper classes and functions, written in Swift. 

This code was originally written for the book [iOS Games by Tutorials, Second Edition](http://raywenderlich.com/store/ios-games-by-tutorials), which is published through [raywenderlich.com](http://raywenderlich.com).

![iOS Games by Tutorials](http://cdn2.raywenderlich.com/wp-content/themes/raywenderlich/images/store/iGT-PDF-phones-640.png "iOS Games by Tutorials")

SKTUtils requires Xcode 6.1. For the older Objective-C version of SKTUtils, see the [objective-c branch](http://github.com/raywenderlich/SKTUtils/tree/objective-c).

## What can SKTUtils do for you?

It defines handy constants such as `π`.

It extends `CGPoint` and `CGVector` so you can do:

```swift
let pt1 = CGPoint(x: 10, y: 20)
let pt2 = CGPoint(x: -5, y: 0)
let pt3 = pt1 + pt2
let pt4 = pt3 * 100
println("Point has length \(pt4.length())")
let pt5 = pt4.normalized()
let dist = pt1.distanceTo(pt2)
```

It adds handy functions to `Int` and `Float`:

```swift
let x = 100
let y = x.clamped(10...50)
let z = Int.random(20..30)

let r = 180.degreesToRadians()
let d = π.radiansToDegrees()
```

It extends various Sprite Kit classes with convenience methods, such as:

```swift
let color = SKColor(red: 255, green: 128, blue: 64)
let action = SKAction.afterDelay(2.0, runBlock: { /* your code here */ })
```

And much more... including `SKTEffects`, which lets you make your games much more [juicy](http://bitly.com/juice-it)!

## Introducting SKTEffects
 
Sprite Kit has a handy feature named *actions* that make it really easy to move, rotate and scale your sprites. However, a big downside is the omission of timing functions beyond the standard *ease in* and *ease out*. The `SKTEffects` classes from this package add support for many more easing functions to Sprite Kit.

Note: The iOS 8 version of Sprite Kit includes an `SKAction.timingFunction` property, but unfortunately it is [pretty useless](https://openradar.appspot.com/radar?id=6464265753985024). It's a step in the right direction, but it still won't let you perform the kinds of effects that make games juicy.

It lets you do things like this with just a few lines of code:

![The demo app](Examples/Effects/Demo.gif)

The only reason `SKTEffects` exists is because `SKAction` does not allow arbitrary timing functions, only standard ease-in and ease-out. The `SKTEffect` subclasses are re-implementations of what `SKAction` already does but with the addition of custom timing functions. It's a bit of a roundabout way of achieving something that really should have been built into Sprite Kit.

There are currently three `SKTEffect` subclasses:

- `SKTMoveEffect`
- `SKTRotateEffect`
- `SKTScaleEffect`

You use them like this:

```swift
let moveEffect = SKTMoveEffect(node: node, duration: 1.0, startPosition: startPoint, endPosition: endPoint)

moveEffect.timingFunction = SKTTimingFunctionBounceEaseOut

node.runAction(SKAction.actionWithEffect(moveEffect))
```

First you create the `SKTMoveEffect` object and pass it the node that it should animate, the duration of the animation in seconds, and the starting and ending position of the node.

Then you (optionally) set the timing function on the effect object. You can use the supplied timing functions -- for example, elastic, bounce, and many others -- or create your own. See **SKTTimingFunctions.swift** for a complete list.

Finally, you wrap the effect object inside a regular `SKAction` and run that action on the node.

The process for `SKTRotateEffect` and `SKTScaleEffect` is identical, but you specify rotation angles and scale vectors, respectively.

You can combine multiple effects at the same time, e.g. have more than one scale effect going at once on the same node.

### Warning about SKTScaleEffect

IMPORTANT: When using `SKTScaleEffect`, the node that you're scaling must *not* have a physics body, otherwise the physics body gets scaled as well and collision detection becomes unpredictable (objects may suddenly move through other objects).

To solve this, make a new `SKNode`, give it the physics body, and add the node that you're scaling as a child node.

### Caveats

Currently there is no "relative" version of the effects. You always have to supply an absolute starting and ending position, rotation angle, or scale. Most of the time this is no big deal, but it does mean you cannot put them into repeating actions.

For example, the demo project does the following to rotate a node every second by 45 degrees:

```swift
node.runAction(SKAction.repeatActionForever(SKAction.sequence([
  SKAction.waitForDuration(0.75),
  SKAction.runBlock {
    let effect = SKTRotateEffect(node: node, duration: 0.25, startAngle: node.zRotation, endAngle: node.zRotation + π/4)
    
    effect.timingFunction = SKTTimingFunctionBackEaseInOut
    
    node.runAction(SKAction.actionWithEffect(effect))
  }])))
```

If the effects had a relative version, this could have simply been written as:

```swift
let effect = SKTRotateEffect(node: node, duration: 0.25, byAngle: π/4)

effect.timingFunction = SKTTimingFunctionBackEaseInOut

node.runAction(SKAction.repeatActionForever(SKAction.sequence([
  SKAction.waitForDuration(0.75),
  SKAction.actionWithEffect(effect)
  ])))
```

Not only is this simpler to read, it also saves you from having to create a new effect instance for every repetition. However, this doesn't work in the current version of the library.

Effects keep state (unlike `SKActions`), so you should not reuse the same effect instance in multiple actions.

If you use a lot of effects over a long period of time, you may run into memory fragmentation problems, because you need to allocate a new object for every effect. Currently, effects cannot be reset, so it's tricky to put them into an object pool and reuse them.

Because actions keep state, you cannot put them into an action after a delay if the node also moves in the mean time. In other words, doing the following may or may not work:

```swift
let effect = SKTMoveEffect()

let action = SKAction.sequence([
  SKAction.waitForDuration(5.0),
  SKAction.actionWithEffect(effect)
  ])
```

If the node has moved during the delay, either through another `SKAction`, physics, or the app changing the node's `position` property, then the effect will start in the wrong place.

### Let's get SKTEffects included in Sprite Kit!

If you think custom timing functions are an important feature to have built into Sprite Kit, then go to [bugreport.apple.com](http://bugreport.apple.com]) and [duplicate this feature request](https://openradar.appspot.com/radar?id=5910148803461120). The more they receive, the better!

## The demo app

The **Examples/Effects** folder contains a little demo project that shows how to do animations with more interesting timing functions. This app uses physics to move the balls and detect collisions.

It has the following special effects:

- The objects appear with an animation when the game starts
- Screen shake on collisions
- Screen rotate on collisions, for extra shaky goodness!
- Screen zoom on collisions
- Color glitch (flashing background color)
- Ball scales up on collisions
- Ball smoothly rotates in the direction it is flying
- "Jelly" effect on the obstacles on collisions
- And more...

Most of these effects are cumulative; i.e. if there are several collisions in quick succession, then the screen shake movement is the sum of these hits.

All the fun happens in **MyScene.swift**. There are several `let` statements at the top that let you turn effects on or off.

Tap the screen to add a random impulse to the balls.

## Playground

The **Examples/Playground** folder contains an Xcode workspace with a Playground. To use this,

1. Open **SKTUtils.xcworkspace** in Xcode.
2. Press **Command+B** to build the SKTUtils module -- this is important!
3. Open **MyPlayground.playground** and start messing around.
4. Press **Option+Command+Enter** to open the Assistant Editor so you can see the output.

Have fun playing with SKTUtils!

## Unit tests

The **Examples/Tests** folder contains an Xcode project with unit tests for SKTUtils. Press Command+U to run the tests.
